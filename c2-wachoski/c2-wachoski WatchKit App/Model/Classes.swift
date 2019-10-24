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
    
    var id: Int
    var name: String
    var size = (water: 0, sun: 0, fertilizer: 0)
        
    init(name: String, water: Int, sun: Int, fertilizer: Int) {
        self.id = Plant.next_id
        Plant.next_id += 1
        
        self.name = name
        self.size.water = water
        self.size.fertilizer = fertilizer
        self.size.sun = sun
    }
    
    public func growBasedInResource(resource: Resource){
        let growthByResource = resource.growthBasedInRatio()
        growAllResources(growth: resource.growth)
    }
    
    public func growAllResources(growth: (water: Int, sun: Int, fertilizer: Int)){
        self.size.fertilizer += growth.fertilizer
        self.size.sun += growth.sun
        self.size.water += growth.water
    }
}

protocol Resource{
    func interpretDataFromCircle() -> Int
    func useResource()// used when the resource button is   ssed
    func growthBasedInRatio() -> Int/* uses growthRatio*/ // returnes how much the plant should grow based in circle results.
    
    var growth : (water : Int, sun : Int, fertilizer: Int) {get set}
    
}

extension Resource{
    
}

class Water: Resource{
    var growth: (water: Int, sun: Int, fertilizer: Int)
    
    init(){
        growth = (0,0,0)
    }
    
    func interpretDataFromCircle() -> Int {
        return -1
    }
    
    func useResource() {
        
    }
    
    func growthBasedInRatio() -> Int {
        return -1
    }
}

class Sun: Resource{
    var growth: (water: Int, sun: Int, fertilizer: Int)
    
    init(){
        growth  = (0,0,0)
    }
    
    func interpretDataFromCircle() -> Int {
        return -1
    }
    
    func useResource() {
        
    }
    
    func growthBasedInRatio() -> Int {
        return -1
    }
    
    //
}

class Fertilizer: Resource{
    var growth: (water: Int, sun: Int, fertilizer: Int)

    init(){
        self.growth = (0,0,0)
    }
    
    func interpretDataFromCircle() -> Int {
        return -1
    }
    
    func useResource() {
        
    }
    
    func growthBasedInRatio() -> Int {
        return -1
    }
    
    
    //
}
class VisualPlant { // decide pelo growth index, qual imagem mostrar
    let referencePlant: Plant
    
    init(referencePlant: Plant) {
        self.referencePlant = referencePlant
    }
    
}
