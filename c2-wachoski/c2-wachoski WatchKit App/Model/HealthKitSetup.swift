//
//  HealthKitSetup.swift
//  c2-wachoski WatchKit Extension
//
//  Created by Kelvin Javorski Soares on 06/11/19.
//  Copyright © 2019 Otávio Baziewicz Filho. All rights reserved.
//

import Foundation
import HealthKit
class HealthKitSetup {
    private enum HealthKitSetupError: Error {
        case notAvailableOnDevice
        case dataTypeNotAvailable
    }
    //1. Verify if HealthKit is available on Device, if not send an error.
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, HealthKitSetupError.notAvailableOnDevice)
            return
        }
        //2. Tries to declare a variable of HKObjectType, and return an error if there's a nil value
        guard let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
            else {
                completion(false, HealthKitSetupError.dataTypeNotAvailable)
                return
        }
        
        //3. Prepare a list of types you want to read from HealthKit (must be a Set of HKSampleType)
        
        let allTypes: Set<HKSampleType> = [HKObjectType.workoutType(),
                                           HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                           HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                           HKObjectType.quantityType(forIdentifier: .stepCount)!]
        
        let objectTypes: Set<HKObjectType> = [HKObjectType.activitySummaryType()]
        
        //4. Request Authorizarion (Tipos que seram lidos pelo app, e tipos que serão alterados pelo app)
        HKHealthStore().requestAuthorization(toShare: allTypes, read: objectTypes) { (success, error) in
            completion(success, error)
        }
        
    }
}
