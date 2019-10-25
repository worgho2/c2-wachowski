//
//  DataAccessObject.swift
//  c2-wachoski
//
//  Created by João Raffs on 23/10/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
class DataAccessObject {
    public init(){}
    static func loadFromUserDefaults() {
        //pegar pra salvar no model
        

        
    }
    
    static func savePlantsFromModelOnUD(){
        let plants = Model.instance.plants
        var i = 0
        while i < plants.count{
            UserDefaults.standard.set(plants[i].name , forKey: "plant\(i)name")
            UserDefaults.standard.set(plants[i].id, forKey: "plant\(i)id")
            UserDefaults.standard.set(plants[i].size.water , forKey: "plant\(i).sizeWater")
            UserDefaults.standard.set(plants[i].size.fertilizer , forKey: "plant\(i).sizeFertilizer")
            UserDefaults.standard.set(plants[i].size.sun , forKey: "plant\(i).sizeSun")

            
            i += 1
            
        }
    }
    static func loadPlantsFromUDIntoModel(){
        var i = 0
        while true{
            if let name = UserDefaults.standard.object(forKey: "plant\(i)name") as? String{
                if let sizeWater = UserDefaults.standard.object(forKey: "plant\(i)sizeWater") as? String{
                    if let id = UserDefaults.standard.object(forKey: "plant\(i)id") as? String{
                        if let sizeFertilizer = UserDefaults.standard.object(forKey: "plant\(i)sizeWater") as? String{
                            if let sizeSun = UserDefaults.standard.object(forKey: "plant\(i)sizeSuun") as? String{
                                var plant = Plant(name: name, water: Int(sizeWater)!, sun:  Int(sizeFertilizer)!, fertilizer: Int(sizeFertilizer)! )
                                plant.id = Int(id)!
                                Model.instance.plants.append(plant)
                            }
                        }
                    }
                }
            }
        }
    }
    static func saveOnUserDefaults() {
        savePlantsFromModelOnUD()
        
        //limpar tudo e escrever de novo ou verificar se tem mudanças
    }
}
