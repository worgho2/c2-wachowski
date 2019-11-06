//
//  HealthKitData.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Kelvin Javorski Soares on 06/11/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import HealthKit

enum HKError: Error {
    case noData
}

class HealthKitData{
    
    //Função que pega os dados de EnergyBurned da Will (Ring), referentes ao dia atual e o último dia logado no app (initialDate)
    class func getMostRecentEnergySample(initialDate : DateComponents) -> EnergyBurned{
        
        var activeEnergyBurned = 0.0
        var activeEnergyBurnedGoal = 0.0
        let queryPredicate = createPredicate(initialDate)
        let query = HKActivitySummaryQuery(predicate: queryPredicate) { (query, summaries, error) -> Void in
            if let summaries = summaries {
                for summary in summaries {
                     //Para cada summary referente ao tipo (energyburned) que ele retorna, será feito uma soma de todos os resultados.
                    activeEnergyBurned += summary.activeEnergyBurned.doubleValue(for: HKUnit.kilocalorie())
                    activeEnergyBurnedGoal += summary.activeEnergyBurnedGoal.doubleValue(for: HKUnit.kilocalorie())
                }
            }
        }
        print("energy burned: ", activeEnergyBurned)
        HKHealthStore().execute(query)
        return EnergyBurned(currentValue: activeEnergyBurned, goal: activeEnergyBurnedGoal)
    }
    
    //Função que pega os dados de horas em pé da Will (Ring), referentes ao dia atual e o último dia logado no app (initialDate)
    class func getMostRecentStandSample(initialDate : DateComponents) -> StandTime{
        
        var standTime = 0.0
        var standTimeGoal = 0.0
        let queryPredicate = createPredicate(initialDate)
        let query = HKActivitySummaryQuery(predicate: queryPredicate) { (query, summaries, error) -> Void in
            if let summaries = summaries {
                for summary in summaries {
                     //Para cada summary referente ao tipo (standtime) que ele retorna, será feito uma soma de todos os resultados.
                    standTime += summary.appleStandHours.doubleValue(for: HKUnit.count())
                    standTimeGoal += summary.appleStandHoursGoal.doubleValue(for: HKUnit.count())
                }
            }
        }
        print("stand:", standTime)
        HKHealthStore().execute(query)
        
        
        return StandTime(currentValue: standTime, goal: standTimeGoal)
    }
    
    //Função que pega os dados de minutos realizando exercicio da Will (Ring), referentes ao dia atual e o último dia logado no app (initialDate)
    class func getMostRecentExerciseSample(initialDate : DateComponents) -> ExerciseTime{
        
        var exerciseTime = 0.0
        var exerciseTimeGoal = 0.0
        let queryPredicate = createPredicate(initialDate)
        let query = HKActivitySummaryQuery(predicate: queryPredicate) { (query, summaries, error) -> Void in
            if let summaries = summaries {
                for summary in summaries {
                    //Para cada summary referente ao tipo (exercisetime) que ele retorna, será feito uma soma de todos os resultados.
                    exerciseTime += summary.appleExerciseTime.doubleValue(for: HKUnit.minute())
                    exerciseTimeGoal += summary.appleExerciseTimeGoal.doubleValue(for: HKUnit.minute())
                }
            }
        }
        print("exercise:", exerciseTime)
        HKHealthStore().execute(query)
        
        
        return ExerciseTime(currentValue: exerciseTime, goal: exerciseTimeGoal)
    }

    //Cria o filtro que define o período (data inicial e data final) em que o app deverá coletar os dados.
    class func createPredicate(_ initialDate : DateComponents) -> NSPredicate? {
        
        var calendar = Calendar.autoupdatingCurrent
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
        
        todayComponents.calendar = calendar
        
        var teste = initialDate
        teste.day = 31
        teste.month = 10
        
        let predicate = HKQuery.predicate(forActivitySummariesBetweenStart: teste, end: todayComponents)
        return predicate
    }
    
    
}
