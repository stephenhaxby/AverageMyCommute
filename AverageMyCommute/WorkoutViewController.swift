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
    
    @IBOutlet weak var totalCaloriesLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    @IBOutlet weak var heartRateLabel: UILabel!
    
    @IBOutlet weak var speedLabel: UILabel!
    
    //------------------------------------------------
    
    @IBOutlet weak var avgTotalCalories: UILabel!
    
    @IBOutlet weak var avgDistanceLabel: UILabel!
    
    @IBOutlet weak var avgTotalTimeLabel: UILabel!
    
    @IBOutlet weak var avgHeartRateLabel: UILabel!
    
    @IBOutlet weak var avgSpeedLabel: UILabel!
    
    //------------------------------------------------
    
    @IBOutlet weak var commuteHeadingLabel: UILabel!
    
    @IBOutlet weak var commuteHeadingDaysLabel: UILabel!
    
    var commute : Commute?
    
    let healthManager = HealthManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
     
        commuteHeadingLabel.text = "\(Utility.timeStringFrom(date : commute!.timeStart! as Date)) - \(Utility.timeStringFrom(date : commute!.timeEnd! as Date))"
        
        var headingDays = String()
        headingDays += (commute!.monday) ? "Mon " : ""
        headingDays += (commute!.tuesday) ? "Tue " : ""
        headingDays += (commute!.wednesday) ? "Wed " : ""
        headingDays += (commute!.thursday) ? "Thur " : ""
        headingDays += (commute!.friday) ? "Fri " : ""
        headingDays += (commute!.saturday) ? "Sat " : ""
        headingDays += (commute!.sunday) ? "Sun " : ""
        
        commuteHeadingDaysLabel.text = headingDays
        
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
            
                // Populate Heart Rate
                self.getHeartRateFor(workout : mostRecentWorkout) {
                
                    (heartRate) -> Void in
                    
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.heartRateLabel.text = self.getFormattedDoubleFor(value: heartRate)
                    })
                }
            
                // Populate Workout data
                DispatchQueue.main.async(execute: { () -> Void in
                    
                    let workoutStats : WorkOutAverages = self.getWorkoutAverages(workouts: [mostRecentWorkout])
                    
                    self.populateMostRecent(workoutStats: workoutStats)
                })

                if filteredWorkouts.count > 1 {
                    
                    filteredWorkouts.removeFirst()
                    
                    self.getHeartRateFor(workouts : filteredWorkouts) {
                        
                        (heartRate) -> Void in
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            self.avgHeartRateLabel.text = self.getFormattedDoubleFor(value: heartRate)
                            
                            // Comopare to most recent
                            if let mostRecentHeartRate : Double = self.getDoubleFrom(string: self.heartRateLabel.text!) {
                                
                                let difference = mostRecentHeartRate - heartRate
                                var differenceLabel : String = self.getFormattedDoubleFor(value: difference)

                                if heartRate > mostRecentHeartRate {

                                    differenceLabel = "  \(differenceLabel)"
                                    
                                    self.append(label: self.heartRateLabel, withDifference: differenceLabel, andColor: UIColor.green)
                                }
                                else if heartRate < mostRecentHeartRate {
                                    
                                    differenceLabel = "  +\(differenceLabel)"
                                    
                                    self.append(label: self.heartRateLabel, withDifference: differenceLabel, andColor: UIColor.red)
                                }
                                else {
                                    
                                    self.heartRateLabel.textColor = UIColor.black
                                }
                            }
                        })
                    }
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        let workOutAverages : WorkOutAverages = self.getWorkoutAverages(workouts: filteredWorkouts)

                        self.populate(workoutStats: workOutAverages)
                        
                        // Compare to most recent
                        self.setMostRecentWorkoutHighlightsFor(workOutAverages: workOutAverages)
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
    
    func append(label : UILabel, withDifference : String, andColor color : UIColor) {
        
        let newLabelText = NSMutableAttributedString(string: label.text!)
        
        let labelRange = NSRange(location:0,length:withDifference.characters.count)
        let differenceAttributedString = NSMutableAttributedString(string: withDifference)
        differenceAttributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location:0,length:withDifference.characters.count))
        differenceAttributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightBold), range: labelRange)
        
        newLabelText.append(differenceAttributedString)
        label.text = nil
        label.attributedText = newLabelText
    }
    
    func setMostRecentWorkoutHighlightsFor(workOutAverages : WorkOutAverages) {

        setMostRecentLabelColorFor(label: totalCaloriesLabel, withDouble: workOutAverages.calories, invertColor: false)
        
        setMostRecentLabelColorFor(label: distanceLabel, withDouble: workOutAverages.distance, invertColor: false)
        
        setMostRecentLabelColorFor(label: speedLabel, withDouble: workOutAverages.speed, invertColor: true)

        setMostRecentLabelColorFor(label: totalTimeLabel, withDateComponents: workOutAverages.time)

    }
    
    func dateIsBeforeDate(_ date1 : Date, date2 : Date) -> Bool {
        
        let dateCompareResult = date1.compare(date2)
        
        return dateCompareResult == ComparisonResult.orderedDescending
    }
    
    func dateIsAfterDate(_ date1 : Date, date2 : Date) -> Bool {
        
        let dateCompareResult = date1.compare(date2)
        
        return dateCompareResult == ComparisonResult.orderedAscending
    }
    
    func setMostRecentLabelColorFor(label : UILabel, withDateComponents value : DateComponents) {
        
        //TODO: Time comparason
        
        let mostRecentDateComponents = getDateComponentsFrom(string: label.text!)
        
        let mostRecentSeconds = dateComponentsToSeconds(dateComponents: mostRecentDateComponents)
        let averageSeconds = dateComponentsToSeconds(dateComponents: value)
        
        
        let difference = mostRecentSeconds - averageSeconds
        //var differenceLabel : String = getFormattedIntFor(value: difference)
        
        let differenceDateComponents = getDateComponentsFrom(totalSecondsDuration: abs(Double(difference)), andNumberOfWorkouts: 1)
        var differenceLabel = "\(getFormattedIntFor(value: differenceDateComponents.minute ?? 0)):\(getFormattedIntFor(value: differenceDateComponents.second ?? 0))"
        
        if averageSeconds > mostRecentSeconds {
            
            differenceLabel = "  -\(differenceLabel)"
            
            append(label: label, withDifference: differenceLabel, andColor: .green)
        }
        else if averageSeconds < mostRecentSeconds {
            
            differenceLabel = "  +\(differenceLabel)"
            append(label: label, withDifference: differenceLabel, andColor: .red)
        }
        else {
            
            label.textColor = UIColor.black
        }
    }
    
    func setMostRecentLabelColorFor(label : UILabel, withDouble value : Double, invertColor : Bool) {
        
        if let mostRecentValue : Double = getDoubleFrom(string : label.text!) {
            
            let difference = mostRecentValue - value
            var differenceLabel : String = getFormattedDoubleFor(value: difference)
            
            if value > mostRecentValue {
                
                differenceLabel = "  \(differenceLabel)"
                
                append(label: label, withDifference: differenceLabel, andColor: invertColor ? .red : .green)
            }
            else if value < mostRecentValue {
                
                differenceLabel = "  +\(differenceLabel)"
                
                append(label: label, withDifference: differenceLabel, andColor: invertColor ? .green : .red)
            }
            else {
                
                label.textColor = UIColor.black
            }
        }
    }
    
    func getDateComponentsFrom(string : String) -> DateComponents {
        
        let calendar = Calendar.current
        var dateComponents : DateComponents = DateComponents()
        
        dateComponents.calendar = calendar
        dateComponents.hour = Int(String(string.characters.dropLast(6)))
        dateComponents.minute = Int(String(String(string.characters.dropFirst(2)).characters.dropLast(3)))
        dateComponents.second = Int(String(string.characters.dropFirst(5)))
        
        return dateComponents
    }
    
    func getDoubleFrom(string : String) -> Double? {
        
        let formatter = NumberFormatter()
        
        return formatter.number(from: string) as? Double
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
        
        avgTotalCalories.text = getFormattedDoubleFor(value: workoutStats.calories)
        
        avgDistanceLabel.text = getFormattedDoubleFor(value: workoutStats.distance)
        
        avgTotalTimeLabel.text = "\(String(describing: workoutStats.time.hour ?? 0)):\(getFormattedIntFor(value: workoutStats.time.minute ?? 0)):\(getFormattedIntFor(value: workoutStats.time.second ?? 0))"
        
        avgSpeedLabel.text = getFormattedDoubleFor(value: workoutStats.speed)
    }
    
    func populateMostRecent(workoutStats : WorkOutAverages) {
       
        totalCaloriesLabel.text = getFormattedDoubleFor(value: workoutStats.calories)
        
        distanceLabel.text = getFormattedDoubleFor(value: workoutStats.distance)
        
        totalTimeLabel.text = "\(String(describing: workoutStats.time.hour ?? 0)):\(getFormattedIntFor(value: workoutStats.time.minute)):\(getFormattedIntFor(value: workoutStats.time.second))"
        
        speedLabel.text = getFormattedDoubleFor(value: workoutStats.speed)
    }
    
    func getFormattedIntFor(value: Int?) -> String {
        
        if let inValue : Int = value {
            
            if inValue <= 9 && inValue >= 0 {
                
                return "0\(inValue)"
            }
            
            if inValue <= -9 && inValue >= -1 {
                
                return "-0\(abs(inValue))"
            }
            
            return String(describing: inValue)
        }
        
        return "-"
    }
    
    func getFormattedDoubleFor(value : Double) -> String {
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        return formatter.string(from: NSNumber(value: value)) ?? "-"
    }
    
    func clearMostRecent() {
        
        totalCaloriesLabel.text = "-"
        
        distanceLabel.text = "-"
        
        totalTimeLabel.text = "-"
        
        heartRateLabel.text = "-"
        
        speedLabel.text = "-"
    }
    
    func clearAverages() {
        
        avgTotalCalories.text = "-"
        
        avgDistanceLabel.text = "-"
        
        avgTotalTimeLabel.text = "-"
        
        avgHeartRateLabel.text = "-"
        
        avgSpeedLabel.text = "-"
        
    }
    
    func getWorkoutAverages(workouts : [HKWorkout]) -> WorkOutAverages {
        
        var averages = WorkOutAverages(calories: 0, distance: 0, time: DateComponents(), speed: 0)

        var totalSecondsDuration = 0.0
        var totalDistance = 0.0
        var totalCalories = 0.0
        
        // sum all hours & minutes together
        for workout in workouts {

            let totalEnergyBurned : Double? = workout.totalEnergyBurned?.doubleValue(for: HKUnit.jouleUnit(with: HKMetricPrefix.kilo))
            
            totalCalories += totalEnergyBurned == nil ? 0 : totalEnergyBurned!
            
            totalSecondsDuration += workout.duration
            
            let distance : Double? = workout.totalDistance?.doubleValue(for: HKUnit.meter())
            totalDistance += distance == nil ? 0 : distance!
        }
        
        averages.calories = totalCalories / Double(workouts.count)
        averages.distance = (totalDistance / 1000) / Double(workouts.count)
        averages.time = getDateComponentsFrom(totalSecondsDuration: totalSecondsDuration, andNumberOfWorkouts: workouts.count)
        averages.speed = (totalDistance / 1000) / Double(workouts.count) / ((totalSecondsDuration / Double(workouts.count)) / 3600 )
        
        return averages
    }
    
    func getHeartRateFor(workout : HKWorkout, completion : @escaping (Double) -> Void) {
        
        healthManager.readHeartRateFor(startDate: workout.startDate, toEndDate: workout.endDate) {
            
            (results, error) -> Void in
            
            if error != nil {
                
                //TODO: Display error
            }
            
            let heartRateSamples = results as! [HKQuantitySample]
            
            var totalHeartRate = 0.0
            
            for heartRate in heartRateSamples {
                
                totalHeartRate += heartRate.quantity.doubleValue(for: HKUnit(from : "count/s"))
            }
            
            completion((totalHeartRate / Double(heartRateSamples.count)) * 60.0)
        }
    }
    
    var workoutTotal = 0.0
    var totalHeartRate = 0.0
    
    func getHeartRateFor(workouts : [HKWorkout], completion : @escaping (Double) -> Void) {
     
        workoutTotal = 0
        totalHeartRate = 0.0
        
        for workout in workouts {
            
            getHeartRateFor(workout: workout) {
                
                (heartRate) -> Void in
                
                self.workoutTotal += 1
                self.totalHeartRate += heartRate
                
                if self.workoutTotal == Double(workouts.count) {
                    
                    completion(self.totalHeartRate / self.workoutTotal)
                }
            }
        }
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
    
    func dateComponentsToSeconds(dateComponents : DateComponents) -> Int {
        
        var totalSeconds = 0
        
        totalSeconds += dateComponents.second ?? 0
        totalSeconds += (dateComponents.minute ?? 0) * 60
        totalSeconds += (dateComponents.hour ?? 0) * 3600
        
        return totalSeconds
    }
    
    func secondsToHoursMinutesSeconds(seconds : Int) -> (Int, Int, Int) {
        
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    struct WorkOutAverages {

        var calories : Double
        
        var distance : Double
        
        var time : DateComponents
        
        var speed : Double
    }
}
