//
//  Plant.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Kaz Born on 07/11/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import SpriteKit

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
/*
class Plant {
	static var next_id: Int = 0
	
	var id: Int
	var name: String
	var size = (water: 0, sun: 0, fertilizer: 0)
	var branches : [CGFloat: [Branch]]
	
	init () {
		self.id = Plant.next_id
		Plant.next_id += 1
		
		self.name = String(id)
		self.size.water 	 = 0
		self.size.sun 		 = 0
		self.size.fertilizer = 0
		branches = [:]
	}
	
	init(name: String, water: Int, sun: Int, fertilizer: Int) {
		self.id = Plant.next_id
		Plant.next_id += 1
		
		self.name = name
		self.size.water = water
		self.size.fertilizer = fertilizer
		self.size.sun = sun
		branches = [:]
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
*/


