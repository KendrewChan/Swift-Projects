//
//  ViewController.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 9/9/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

let start = Date()
var end = Date()

class ViewController: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate{
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerBtnLabel: UIButton!
    
    
    
    var isGrantedAccess = false
    var timerValue = 25*60
    var timerText = 25*60
    var myString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let x = UserDefaults.standard.object(forKey: "goalLabel") as? String {
            textLabel.text = x
        } else {
            textLabel.text = ""
        }
        timerLabel.text = timeString(time: TimeInterval(timerText))
        
        updateInBackground() //
        
        pageRules() //
        
        notifyAccess()
        
    }
    
    let content = UNMutableNotificationContent()
    var timer = Timer()
    var isTimerRunning = false
    
    @IBAction func startTimer(_ sender: Any) { //btn to startTimer
        if isTimerRunning == false {
            runTimer()
            timerBtnLabel.alpha = 0
        }
        if isGrantedAccess{
            content.title = "Time's Up!"
            content.body = "Keep up the good work!!"
            content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerValue), repeats: false)
            addNotification(content: content, trigger: trigger , identifier: "alarm.category")
        }
    }
    
    @IBAction func timeSettings(_ sender: Any) {
        print("pressed")
    }
    
    @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {
        if sender.source is SecondView {
            if let senderVC = sender.source as? SecondView {
                myString = senderVC.myString
                UserDefaults.standard.set(myString, forKey: "goalLabel")
                textLabel.text = myString
                
                if senderVC.timerClicked == true {
                timerValue = senderVC.seconds
                timerLabel.text = timeString(time: TimeInterval(timerValue))
                resetTimer()
                }
            }
        }
    }
    
    func resetTimer() {
        timer.invalidate()
        isTimerRunning = false
        timerLabel.text = timeString(time: TimeInterval(timerValue))
        
        timerBtnLabel.alpha = 1
        removeSavedDate()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    /////////// TimerLabel on Screen
    
    func runTimer() {
        isTimerRunning = true
        timerText = timerValue
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
            if timerText > 0 && isTimerRunning == true {
                timerText -= 1
                timerLabel.text = timeString(time: TimeInterval(timerText))
                
            } else {
                resetTimer()
            }
    }
    
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    /////////// Background Timer Updating
    let calendar = NSCalendar.current
    var diffSecs = 0
    
    @objc func pauseWhenBackground(noti: Notification) {
        if isTimerRunning == true {
        self.timer.invalidate()
        UserDefaults.standard.set(Date(), forKey: "savedTime")
        } else {
            print("timer is not running")
        }
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            (diffSecs) = ViewController.getTimeDifference(savedDate: savedDate)
            self.refresh(sec: diffSecs)
        }
    }
    
    static func getTimeDifference(savedDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: Date(), to: savedDate)
        return(components.second!)
    }
    
    func refresh (sec: Int) {
        self.timerText = timerText + sec
        if timerText > 0 {
            timerLabel.text = timeString(time: TimeInterval(timerText))
            self.runTimer()
        } else {
            resetTimer()
        }
    }
    
    func updateInBackground() {
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: .UIApplicationWillEnterForeground, object: nil)
    }
    
    func removeSavedDate() {
        if (UserDefaults.standard.object(forKey: "savedTime") as? Date) != nil {
            UserDefaults.standard.removeObject(forKey: "savedTime")
        }
    }
    ///////////////////// Success Rules Page
   @IBOutlet weak var rulesPage: UIView!
    
    @IBAction func promiseButton(_ sender: Any) {
        pageRules()
        }
    
    var isPageAppeared = false
    
    func pageRules() {
        if isPageAppeared { //when rulesPage is there
            UIView.animate(withDuration: 0.5, animations: {
                self.rulesPage.center = CGPoint(x: self.rulesPage.center.x, y: self.rulesPage.center.y + 800)
                self.rulesPage.alpha = 0
            })
            isPageAppeared = false
        } else { //rulesPage is not there
            rulesPage.center = CGPoint(x: rulesPage.center.x, y: rulesPage.center.y + 800)
            UIView.animate(withDuration: 0.5, animations: {
                self.rulesPage.center = CGPoint(x: self.rulesPage.center.x, y: self.rulesPage.center.y - 800)
                self.rulesPage.alpha = 1
            })
            isPageAppeared = true
        }
    }
    
    ///////// Notifications
    func notifyAccess() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedAccess = granted
                if granted{
                    self.setCategories()
                } else {
                    let alert = UIAlertController(title: "Notification Access", message: "In order to use this application, turn on notification permissions.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alert.addAction(alertAction)
                    self.present(alert , animated: true, completion: nil)
                }
        })
    }
    
    func setCategories(){
        let commentAction = UNTextInputNotificationAction(identifier: "comment", title: "Add New Goal", options: [UNNotificationActionOptions.authenticationRequired], textInputButtonTitle: "Add", textInputPlaceholder: "Add new goal here!!")
        let alarmCategory = UNNotificationCategory(identifier: "alarm.category",actions: [commentAction,],intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }
    
    func addNotification(content:UNNotificationContent,trigger:UNNotificationTrigger?, identifier:String){
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
            (errorObject) in
            if let error = errorObject{
                print("Error \(error.localizedDescription) in notification \(identifier)")
            }
        })
    }
    
    // MARK: - Delegates
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert,.sound])
        resetTimer()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.actionIdentifier
        let request = response.notification.request
        if identifier == "comment"{ //try changing to alarm.category
            let textResponse = response as! UNTextInputNotificationResponse
            textLabel.text = textResponse.userText
            let newContent = request.content.mutableCopy() as! UNMutableNotificationContent
            newContent.body = textResponse.userText
            addNotification(content: newContent, trigger: request.trigger, identifier: request.identifier)
        }
        
        completionHandler()
}
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

