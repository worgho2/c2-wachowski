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
    var size: Int
        
    init(name: String, size: Int) {
        self.id = Plant.next_id
        Plant.next_id += 1
        
        self.name = name
        self.size = size
    }
    
    public func growBasedInResource(resource: Resource){
        let growthByResource = resource.growthBasedInRatio()
        self.size += growthByResource
    }
}

class Resource{
    public func interpretDataFromCircle() -> Int{ return -1}
    public func useResource(){} // used when the resource button is pressed
    public func growthBasedInRatio() -> Int{ return -1 /* uses growthRatio*/} // returnes how much the plant should grow based in circle results.
    
    public var growthRatio: Int = 0
}

class Water: Resource{
    var teste: String?
}

class Sun: Resource{
    //
}

class Fertilizer: Resource{
    //
}


class VisualPlant { // decide pelo growth index, qual imagem mostrar
    let referencePlant: Plant
    
    init(referencePlant: Plant) {
        self.referencePlant = referencePlant
    }
    
}
