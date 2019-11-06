import Foundation

class User: Codable {
    var name: String
    var plants: [Plant]
    
    enum CodingKeys: String, CodingKey {
        case name
        case plants
    }
    
    init(name: String, plants: [Plant]) {
        self.name = name
        self.plants = plants
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(plants, forKey: .plants)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        plants = try container.decode([Plant].self, forKey: .plants)
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(water, forKey: .water)
        try container.encode(sun, forKey: .sun)
        try container.encode(fertilizer, forKey: .fertilizer)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        water = try container.decode(Int.self, forKey: .water)
        sun = try container.decode(Int.self, forKey: .sun)
        fertilizer = try container.decode(Int.self, forKey: .fertilizer)
    }
    
    
    public func growBasedInResource(resource: Resource){
        let growthByResource = resource.growthBasedInRatio()
        growAllResources(growth: resource.growth)
    }
    
    public func growAllResources(growth: (water: Int, sun: Int, fertilizer: Int)){
        self.fertilizer += growth.fertilizer
        self.sun += growth.sun
        self.water += growth.water
    }
}

protocol Resource{
    func interpretDataFromCircle() -> Int
    func useResource()// used when the resource button is   ssed
    func growthBasedInRatio() -> Int/* uses growthRatio*/ // returnes how much the plant should grow based in circle results.
    
    var growth : (water : Int, sun : Int, fertilizer: Int) { get set }
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
    
}
