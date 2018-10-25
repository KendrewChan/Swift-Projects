//
//  SecondView.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 23/11/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit
import UserNotifications

class SecondView: UIViewController, UITextFieldDelegate, UNUserNotificationCenterDelegate {

    
    @IBOutlet weak var goalsTextField: UITextField!
    @IBOutlet weak var m30: UIButton!
    @IBOutlet weak var m45: UIButton!
    @IBOutlet weak var m60: UIButton!
    
    var seconds = Int()
    var timerValue = 25*60
    var myString = String()
    
    var viewC = ViewController()
    var timerClicked = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true) //to end keyboard if finger touches outside of keyboard
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        goalsTextField.resignFirstResponder() //for keyboard to end when return key is touched
        
        return true
        
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        goalsTextField.resignFirstResponder()
    }
    
    
    @IBAction func minutes30(_ sender: Any) { //temp var and values do not match, temp change, 30 > 25
        timerValue = 25*60
        m45.alpha = 0
        m60.alpha = 0
        timerClicked = true
    }
    
    @IBAction func minutes45(_ sender: Any) { //temp var and values do not match, temp change 45 > 35
        timerValue = 35*60
        m30.alpha = 0
        m60.alpha = 0
        timerClicked = true
    }
    
    @IBAction func minutes60(_ sender: Any) { //temp var and values do not match, temp change 60 > 45
        timerValue = 45*60
        m45.alpha = 0
        m30.alpha = 0
        timerClicked = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setGoals()
        if timerClicked == true {
        seconds = timerValue
        }
    }
    
    func setGoals() {
        if goalsTextField.text == "", let x = UserDefaults.standard.object(forKey: "goalLabel") as? String {
            myString = x
        } else {
            myString = goalsTextField.text!
            UserDefaults.standard.set(myString, forKey: "goalLabel")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        timerClicked = false
        
        goalsTextField.delegate = self //for textfield to resignFirstResponder
        
        setGoals()
        resetAlphas()
        // Do any additional setup after loading the view.
    }

    @IBAction func resetSettings(_ sender: Any) {
        resetAlphas()
        timerValue = 25*60
        seconds = timerValue
        goalsTextField.text = ""
        goalsTextField.resignFirstResponder()
    }
    func resetAlphas() {
        m30.alpha = 1
        m45.alpha = 1
        m60.alpha = 1
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
