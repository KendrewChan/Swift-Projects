//
//  sizeView.swift
//  MuscleAmp
//
//  Created by Kendrew Chan on 23/11/17.
//  Copyright © 2017 KCStudios. All rights reserved.
//

import UIKit
import UserNotifications

class sizeView: UIViewController, UNUserNotificationCenterDelegate {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var currentSets: UILabel!
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func restBtn(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
        }
    }
    
    @IBAction func resetBtn(_ sender: Any) {
        sets = 0
        resetTimer()
    }
    
    var timer = Timer()
    var isTimerRunning = false
    let calendar = NSCalendar.current
    var seconds = 60
    var sets = 0
    
    var timerValue = 60 //change this value per the View
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(sizeView.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    func updateTimer() {
        if seconds > 0 {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
            
        } else if seconds <= 0 {
            if sets < 5 {
                sets += 1
                resetTimer()
            } else {
                sets = 0
                resetTimer()
            }
        }
    }
    
    func resetTimer() {
        currentSets.text = "\(sets)"
        timer.invalidate()
        self.isTimerRunning = false
        seconds = timerValue
        timerLabel.text = timeString(time: TimeInterval(seconds))
        UserDefaults.standard.removeObject(forKey: "sizeTime")
    }
    
    //////////
    func timeString(time:TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%01i:%02i", minutes, seconds)
    }
    
    func pauseWhenBackground(noti: Notification) {
        self.timer.invalidate()
        UserDefaults.standard.set(end, forKey: "sizeTime")
    }
    
    func willEnterForeground(noti: Notification) {
        if let y = UserDefaults.standard.object(forKey: "sizeTime") as? Date {
            let end = y
            
            let components = calendar.dateComponents([.second], from: start, to: end)
            self.refresh(sec: components.second!)
        }
    }
    
    static func getTimeDifference(startDate: Date) -> (Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.second], from: start, to: Date())
        return(components.second!)
    }
    
    func refresh (sec: Int) {
        self.seconds += sec
        timerLabel.text = timeString(time: TimeInterval(seconds))
        self.runTimer()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: .UIApplicationWillEnterForeground, object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
