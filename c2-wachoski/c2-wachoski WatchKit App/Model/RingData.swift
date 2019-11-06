//
//  RingData.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Kelvin Javorski Soares on 06/11/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation

struct EnergyBurned {
    var currentValue = 0.0
    var goal = 0.0
    var accumulated = 0.0
}

struct StandTime {
    var currentValue = 0.0
    var goal = 0.0
    var accumulated = 0.0
}

struct ExerciseTime{
    var currentValue = 0.0
    var goal = 0.0
    var accumulated = 0.0
}

//Recursos disponíveis para o usuário utilizar na planta
struct Resources{
    var energyBurned = 0.0
    var standTime = 0.0
    var exerciseTime = 0.0
}
