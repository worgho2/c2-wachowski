import Foundation

class User {
    static var next_id: Int = 0
    
    let id: Int
    var name: String
    var plants: [Plant]
    
    init(name: String, plants: [Plant]) {
        self.id = User.next_id
        User.next_id += 1
        
        self.name = name
        self.plants = plants
    }
    
    func addPlant(_ plant: Plant) {
        if !plants.contains(where: { $0.id == plant.id } ) {
            plants.append(plant)
            print("Sucesso")
        } else {
            print("Erro do brabo")
        }
    }
    
    func deletePlant(fromId id: Int) {
        guard let index = plants.firstIndex(where: { $0.id == id } ) else {
            print("erro")
            return
        }
        plants.remove(at: index)
        print("deuboa")
    }
    
    func updatePlant(fromId id: Int, infos: [String : Any]) {
        //
    }
    
}

struct Frequency {
    let singular: String
    let plural: String
    let value: Int
}

class Plant {
    static var next_id: Int = 0
    
    let id: Int
    var name: String
    var frequency: Frequency
    var startHourAllert: Date // a hora que vamos alertar a pessoa de fazer
    var duration: Double // timeinterval
    var growthIndex: Int
    
    var toggleManager: Toggler = Toggler()
    
    init(name: String, frequency: Frequency, startHourAllert: Date, duration: Double, growthIndex: Int) {
        self.id = Plant.next_id
        Plant.next_id += 1
        
        self.name = name
        self.frequency = frequency
        self.startHourAllert = startHourAllert
        self.duration = duration
        self.growthIndex = growthIndex
    }
    
    func toggle() {
        self.toggleManager.startToggle()
    }
    
    func distoggle() {
        self.growthIndex += self.toggleManager.getGrowth()
    }
    
}

class Toggler {
    var startDate: Date?
    
    func startToggle() {
         //hora atual
    }
    
    func getGrowth() -> Int { // retorna quanto deve ser incrementado no growthIndex
        //pega a hora atual , a inicial e calcula e devorve
        return 0
    }
}

class VisualPlant { // decide pelo growth index, qual imagem mostrar
    let referencePlant: Plant
    
    init(referencePlant: Plant) {
        self.referencePlant = referencePlant
    }
    
}
