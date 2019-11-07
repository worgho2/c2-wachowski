import Foundation

class User {
    static var next_id: Int = 0
    
    var id: Int
    var name: String
    var plants: [Plant] = []
    
    init(name: String) {
        self.id = User.next_id
        User.next_id += 1
        
        self.name = name
        self.id = 0
        
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

class VisualPlant { // decide pelo growth index, qual imagem mostrar
    let referencePlant: Plant
    
    init(referencePlant: Plant) {
        self.referencePlant = referencePlant
    }
    
}
