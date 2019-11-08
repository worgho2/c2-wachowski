import Foundation
import HealthKit

class User: Codable {
    lazy var firstLoginDate: DateComponents = {
        return setFirstLoginDate()
    }()
    
    var name: String
    var plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case name
        case plants
        case firstLoginDate
    }
    
    init(name: String, plants: [Plant]) {
        self.name = name
        self.plants = plants
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(plants, forKey: .plants)
        try container.encode(firstLoginDate, forKey: .firstLoginDate)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        plants = try container.decode([Plant].self, forKey: .plants)
        firstLoginDate = try container.decode(DateComponents.self, forKey: .firstLoginDate)
    }
    
    
    private func setFirstLoginDate() -> DateComponents{
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(identifier: "UTC")!

        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.calendar = calendar
        
        return todayComponents
    }
}

class Plant: Codable {
    static var next_id: Int = 0
    
    var id: Int
    var name: String
    var water: Int
    var sun: Int
    var fertilizer: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case water
        case sun
        case fertilizer
    }
        
    init(name: String, water: Int, sun: Int, fertilizer: Int) {
        self.id = Plant.next_id
        Plant.next_id += 1
        
        self.name = name
        self.water = water
        self.fertilizer = fertilizer
        self.sun = sun
    }
    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(name, forKey: .name)
//        try container.encode(water, forKey: .water)
//        try container.encode(sun, forKey: .sun)
//        try container.encode(fertilizer, forKey: .fertilizer)
//    }
//
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        name = try container.decode(String.self, forKey: .name)
//        water = try container.decode(Int.self, forKey: .water)
//        sun = try container.decode(Int.self, forKey: .sun)
//        fertilizer = try container.decode(Int.self, forKey: .fertilizer)
//    }
}

struct ResourceData {
    var currentValue: Double = 0.0
    var goal: Double = 0.0
}

enum ResourceType {
    case stand
    case move
    case exercise
}

class HealthKitManager {
    
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    
    static func requestHealthKitAuthorization(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        
        guard let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(false, HealthKitSetupError.dataTypeNotAvailable)
            return
        }
        
        let allTypes: Set<HKSampleType> = [HKObjectType.workoutType(),
                                           HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                           HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                           HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        let objectTypes: Set<HKObjectType> = [HKObjectType.activitySummaryType()]
        
        HKHealthStore().requestAuthorization(toShare: allTypes, read: objectTypes) { (success, error) in
            completion(success, error)
        }
    }
    
    static func authorizeHealthKit() {
        HealthKitManager.requestHealthKitAuthorization() { (authorized, error) in
            guard authorized else {
                let baseMessage = "HealthKit Authorization Failed"
                if let error = error {
                    print("\(baseMessage). Reason: \(error.localizedDescription)")
                } else {
                    print(baseMessage)
                }
                return
            }
            print("HealthKit Successfully Authorized.")
        }
    }
    
    //Cria o filtro que define o período (data inicial e data final) em que o app deverá coletar os dados.
    private static func createPredicate(_ initialDate : DateComponents) -> NSPredicate? {
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        todayComponents.calendar = calendar
        
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: initialDate, end: todayComponents)
        return predicate
    }
    
    static func getResourceData(initialDate: DateComponents, type: ResourceType) -> ResourceData {
        return ResourceData(currentValue: 250, goal: 50)
        var resourceTime = 0.0
        var resourceGoal = 0.0
        
        let queryPredicate = createPredicate(initialDate)
        
        let query = HKActivitySummaryQuery(predicate: queryPredicate) { (query, summaries, error) -> Void in
            if let summaries = summaries {
                switch type {
                case .move:
                    for summary in summaries {
                        resourceGoal = summary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
                        resourceTime += summary.activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                    }
                case .stand:
                    for summary in summaries {
                        resourceGoal = summary.appleStandHoursGoal.doubleValue(for: HKUnit.count())
                        resourceTime += summary.appleStandHours.doubleValue(for: HKUnit.count())
                    }
                case .exercise:
                    for summary in summaries {
                        resourceGoal = summary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute())
                        resourceTime += summary.appleExerciseTime.doubleValue(for: HKUnit.minute())
                    }
                }
                
            }
        }
        HKHealthStore().execute(query)
        return ResourceData(currentValue: resourceTime, goal: resourceGoal)
    }
    
    
    
}
