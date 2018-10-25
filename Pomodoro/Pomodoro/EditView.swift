//
//  EditView.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 23/10/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit


class EditView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var labelGoals: UILabel!
    @IBOutlet weak var goalsLabel: UILabel!
    
    var end = Date()
    var goalsString = String()
    var daysString = String()
    
//    @IBAction func backBtn(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func unwindFromAddVC(_ sender: UIStoryboardSegue) {
        if sender.source is EditGoalsView {
            if let senderVC = sender.source as? EditGoalsView {
                end = senderVC.endDate
                UserDefaults.standard.set(end, forKey: "goalDay")
                
                goalsString = senderVC.goalsString
                UserDefaults.standard.set(goalsString, forKey: "goalSave")
                goalsLabel.text = goalsString
                
                
                let start = Date()
                
                let calendar = NSCalendar.current
                
                // Replace the hour (time) of both dates with 00:00
                let date1 = calendar.startOfDay(for: start)
                let date2 = calendar.startOfDay(for: end)
                
                let components = calendar.dateComponents([.day], from: date1, to: date2)
                
                UserDefaults.standard.set(end, forKey: "goalDay")
                
                labelGoals.text = "\(components.day!)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        loadData()
//    }
    
    override func viewWillAppear(_ animated: Bool) { //loads data
        super.viewWillAppear(true)
        loadData()
    }
    
    func loadData() {
        if let x = UserDefaults.standard.object(forKey: "goalSave") as? String {
            goalsLabel.text = x
        } else {
            goalsLabel.text = ""
        }
        if let y = UserDefaults.standard.object(forKey: "goalDay") as? Date {
            let start = Date()
            let end = y
            
            let calendar = NSCalendar.current
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: start)
            let date2 = calendar.startOfDay(for: end)
            
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            labelGoals.text = "\(components.day!)"
        }
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
