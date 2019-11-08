
import Foundation

class Model {
    static let instance = Model()
    
    var user: User
    
    private init() {
        user = DataAccessObject.retrieveUser() ?? User(name: "Novo", plants: [])
    }

//	func updatePlant (plant: Plant) {
//		plants[plant.id] = plant
//	}
}

