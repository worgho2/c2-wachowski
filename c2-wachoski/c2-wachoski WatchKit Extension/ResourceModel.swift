import WatchKit
import Foundation
import HealthKit

struct Resource: Codable {
    var available: Double
    var total: Double
}

class ResourceModel {
    static var instance : ResourceModel = ResourceModel()
    
    var sol : Resource = Resource(available: 0, total: 0)
    var agua : Resource = Resource(available: 0, total: 0)
    var fertilizante: Resource = Resource(available: 0, total: 0)
    
    private init() {
        loadResources()
    }
    
    func loadResources() {
        //Carregar os dados
        sol = DataAccessObject.load(type: Resource.self, key: "sol") ?? Resource(available: 0, total: 0)
        agua = DataAccessObject.load(type: Resource.self, key: "agua") ?? Resource(available: 0, total: 0)
        fertilizante = DataAccessObject.load(type: Resource.self, key: "fertilizante") ?? Resource(available: 0, total: 0)
        
        print(sol)
        print(agua)
        print(fertilizante)
        
        if let user = Model.instance.user as User? {
            
            let solTotal = HealthKitManager.getResourceData(initialDate: user.firstLoginDate, type: .stand)
            let solAvailable = solTotal.currentValue - sol.total
            sol.total = solTotal.currentValue
            sol.available += solAvailable
            
            let aguaTotal = HealthKitManager.getResourceData(initialDate: user.firstLoginDate, type: .move)
            let aguaAvailable = aguaTotal.currentValue - agua.total
            agua.total = aguaTotal.currentValue
            agua.available += aguaAvailable
            
            let fertilizanteTotal = HealthKitManager.getResourceData(initialDate: user.firstLoginDate, type: .exercise)
            let fertilizanteAvailable = fertilizanteTotal.currentValue - fertilizante.total
            fertilizante.total = fertilizanteTotal.currentValue
            fertilizante.available += fertilizanteAvailable
            
            fertilizante.available -= 100
            agua.available -= 30
            
            //Salvar dados
            DataAccessObject.save(object: sol, key: "sol")
            DataAccessObject.save(object: agua, key: "agua")
            DataAccessObject.save(object: fertilizante, key: "fertilizante")
        }
    }
}
