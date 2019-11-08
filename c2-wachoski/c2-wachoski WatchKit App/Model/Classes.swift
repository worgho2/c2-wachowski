import Foundation

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


