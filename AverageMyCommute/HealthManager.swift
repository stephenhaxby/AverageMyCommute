//
//  HealthManager.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 18/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import HealthKit

class HealthManager {
    
    private let healthStore = HKHealthStore()
    
    class var sharedInstance: HealthManager {
        struct Singleton {
            static let instance = HealthManager()
        }
        return Singleton.instance
    }
    
    func authorizeHealthKit(completion : @escaping (_ success : Bool, _ error : Error?) -> Void) {
        
        let healthTypesToWrite: Set<HKSampleType> = Set<HKSampleType>()
        
        let healthTypesToRead: Set<HKSampleType> = [HKWorkoutType.workoutType(), HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
//        let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKWorkoutType.workoutType(), HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!, HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!]
        
        
        if !HKHealthStore.isHealthDataAvailable() {
            
            let error = NSError(domain: "com.MyCompany.AverageMyCommute", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available in this Device"])
            
            completion(false, error)
            
            return
        }
        
        // 4.  Request HealthKit authorization
        healthStore.requestAuthorization(toShare: healthTypesToWrite, read: healthTypesToRead) {
            
            (success, error) -> Void in
            
                completion(success, error)
        }
    }
    
    func readRunningWorkOuts(completion: @escaping ([AnyObject]?, Error?) -> Void) {
        
        // Predicate to read only running workouts
        let predicate = HKQuery.predicateForWorkouts(with: HKWorkoutActivityType.cycling)
        
        HKQuery.predicate
        
        // Order the workouts by date
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: false)

        // Create the query
        let sampleQuery = HKSampleQuery(sampleType: HKWorkoutType.workoutType(), predicate: predicate, limit: 0, sortDescriptors: [sortDescriptor]) {
            
            (sampleQuery, results, error) -> Void in
            
                completion(results, error)
        }
        
        // Execute the query
        healthStore.execute(sampleQuery)
    }
    
    func readHeartRateFor(startDate : Date, toEndDate endDate : Date, completion: @escaping ([AnyObject]?, Error?) -> Void) {
        
        let heartRateType : HKQuantityType = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
        
        let sortDescriptors = [NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)]
        
        let sampleQuery = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: 0, sortDescriptors: sortDescriptors) {
            
            (sampleQuery, results, error) -> Void in
            
            completion(results, error)
        }
        
        // Execute the query
        healthStore.execute(sampleQuery)
    }
}
