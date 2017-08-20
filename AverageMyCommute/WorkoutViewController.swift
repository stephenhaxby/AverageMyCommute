//
//  WorkoutViewController.swift
//  AverageMyCommute
//
//  Created by Stephen Haxby on 17/8/17.
//  Copyright © 2017 Stephen Haxby. All rights reserved.
//

import UIKit
import HealthKit

class WorkoutViewController : UIViewController {
    
    @IBOutlet weak var activeCaloriesLabel: UILabel!
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    //------------------------------------------------
    
    @IBOutlet weak var avgActiveCaloriesLabel: UILabel!
    
    @IBOutlet weak var avgTotalCalories: UILabel!
    
    @IBOutlet weak var avgDistanceLabel: UILabel!
    
    @IBOutlet weak var avgTotalTimeLabel: UILabel!
    
    @IBOutlet weak var avgHeartRateLabel: UILabel!
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    
    //------------------------------------------------
    
    var commute : Commute?
    
    let healthManager = HealthManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        healthManager.authorizeHealthKit(completion: {
            
            (success, error) -> Void in
            
                if success {
                    
                    self.readWorkouts()
                }
                else {
                
                    //TODO: Display error
                }
        })
    }
    
    func readWorkouts() {
        
        healthManager.readRunningWorkOuts(completion: {
            
            (results, error) -> Void in
            
                if error != nil {
                    
                    //TODO: Display error
                }
                
                // Keep workouts and refresh tableview in main thread
                let workouts : [HKWorkout] = results as! [HKWorkout]
            
                // Filter out workouts that aren't for our commute
                var filteredWorkouts : [HKWorkout] = workouts.filter({
                    (workout : HKWorkout) -> Bool in
                    
                    var commuteStartDateComponents : DateComponents = self.getDateComponentsFromDate(self.commute!.timeStart! as Date)
                    var commuteEndDateComponents : DateComponents = self.getDateComponentsFromDate(self.commute!.timeEnd! as Date)
                    
                    let workoutDateComponents : DateComponents = self.getDateComponentsFromDate(workout.startDate)
                    
                    commuteStartDateComponents.year = workoutDateComponents.year
                    commuteStartDateComponents.month = workoutDateComponents.month
                    commuteStartDateComponents.day = workoutDateComponents.day
                    
                    commuteEndDateComponents.year = workoutDateComponents.year
                    commuteEndDateComponents.month = workoutDateComponents.month
                    commuteEndDateComponents.day = workoutDateComponents.day
                    
                    let commuteStartDate : Date = self.getDateFromComponents(commuteStartDateComponents)
                    let commuteEndDate : Date = self.getDateFromComponents(commuteEndDateComponents)
                    
                    //TODO: THIS IS BACKWARDS!
                    return (commuteStartDate...commuteEndDate).contains(workout.startDate)
                })
                
                if filteredWorkouts.count == 0 {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                    
                        self.clearMostRecent()
                        self.clearAverages()
                    })
                    
                    return
                }
            
                let mostRecentWorkout : HKWorkout = filteredWorkouts[0]
            
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let workoutStats : WorkOutAverages = self.getWorkoutAverages(workouts: [mostRecentWorkout])
                    
                    self.populateMostRecent(workoutStats: workoutStats)
                })

                if filteredWorkouts.count > 1 {
                    
                    filteredWorkouts.removeFirst()
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        let workOutAverages : WorkOutAverages = self.getWorkoutAverages(workouts: filteredWorkouts)

                        self.populate(workoutStats: workOutAverages)
                        
                    })
                }
                else {
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        self.clearAverages()
                    })
                    
                    //TODO: No Average to show, only show top section results
                }
        })
    }
    
    func getDateFromComponents(_ components : DateComponents) -> Date {
        
        return Calendar.current.date(from: components)!
    }
    
    func getDateComponentsFromDate(_ date : Date) -> DateComponents {
        
        let calendar = Calendar.current
        var dateComponents : DateComponents = DateComponents()
        
        dateComponents.calendar = calendar
        dateComponents.year = (calendar as NSCalendar).component(NSCalendar.Unit.year, from: date)
        dateComponents.month = (calendar as NSCalendar).component(NSCalendar.Unit.month, from: date)
        dateComponents.day = (calendar as NSCalendar).component(NSCalendar.Unit.day, from: date)
        dateComponents.hour = (calendar as NSCalendar).component(NSCalendar.Unit.hour, from: date)
        dateComponents.minute = (calendar as NSCalendar).component(NSCalendar.Unit.minute, from: date)
        dateComponents.second = (calendar as NSCalendar).component(NSCalendar.Unit.second, from: date)
        
        return dateComponents;
    }
    
    func populate(workoutStats : WorkOutAverages) {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        avgTotalCalories.text = formatter.string(from: NSNumber(value: workoutStats.calories))
        
        avgDistanceLabel.text = formatter.string(from: NSNumber(value: workoutStats.distance))
        
        avgTotalTimeLabel.text = "\(String(describing: workoutStats.time.hour ?? 0)):\(String(describing: workoutStats.time.minute ?? 0)):\(String(describing: workoutStats.time.second ?? 0))"
    }
    
    func populateMostRecent(workoutStats : WorkOutAverages) {

        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        
        totalCaloriesLabel.text = formatter.string(from: NSNumber(value: workoutStats.calories))
        
        distanceLabel.text = formatter.string(from: NSNumber(value: workoutStats.distance))
        
        totalTimeLabel.text = "\(String(describing: workoutStats.time.hour ?? 0)):\(String(describing: workoutStats.time.minute ?? 0)):\(String(describing: workoutStats.time.second ?? 0))"
    }
    
    func readHeartBeat() {
        
        //healthManager.readHeartRateFor(startDate: <#T##Date#>, toEndDate: <#T##Date#>, completion: <#T##([AnyObject]?, Error?) -> Void#>)
        
//        healthManager.readRunningWorkOuts(completion: {
//            
//            (results, error) -> Void in
//            
//            if error != nil {
//                
//                //TODO: Display error
//            }
//        }
    }
    
    func clearMostRecent() {
        
        
    }
    
    func clearAverages() {
        
        
    }
    
    func getWorkoutAverages(workouts : [HKWorkout]) -> WorkOutAverages {
        
        var averages = WorkOutAverages(calories: 0, distance: 0, time: DateComponents())

        var totalSecondsDuration = 0.0
        var totalDistance = 0.0
        var totalCalories = 0.0
        
        // sum all hours & minutes together
        for workout in workouts {

            let totalEnergyBurned : Double? = workout.totalEnergyBurned?.doubleValue(for: HKUnit.kilocalorie())
            
            totalCalories += totalEnergyBurned == nil ? 0 : totalEnergyBurned!
            
            totalSecondsDuration += workout.duration
            
            let distance : Double? = workout.totalDistance?.doubleValue(for: HKUnit.meter())
            totalDistance += distance == nil ? 0 : distance!
            
            // Heart Rate must be seperate
            // Speed must be seperate too...
        }
        
        averages.calories = totalCalories / Double(workouts.count)
        averages.distance = (totalDistance / 1000) / Double(workouts.count)
        averages.time = getDateComponentsFrom(totalSecondsDuration: totalSecondsDuration, andNumberOfWorkouts: workouts.count)
        
        return averages
    }
    
    func getDateComponentsFrom(totalSecondsDuration : Double, andNumberOfWorkouts numberOfWorkouts : Int) -> DateComponents {
        
        let totalSeconds = totalSecondsDuration / Double(numberOfWorkouts)
        
        let (hours,minutes,seconds) = secondsToHoursMinutesSeconds(seconds : Int(totalSeconds))
        
        let calendar = Calendar.current
        var dateComponents : DateComponents = DateComponents()
        
        dateComponents.calendar = calendar
        dateComponents.hour = Int(hours)
        dateComponents.minute = Int(minutes)
        dateComponents.second = Int(seconds)
        
        return dateComponents
    }
    
    //SPEED
    
    //HEART RATE
    //            let heartRateUnit = HKUnit(from : "count/min")
    //            quantity.doubleValueForUnit(heartRateUnit))
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    struct WorkOutAverages {

        var calories : Double
        
        var distance : Double
        
        var time : DateComponents
    }
}
