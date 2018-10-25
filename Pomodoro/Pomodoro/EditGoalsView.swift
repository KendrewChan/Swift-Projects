//
//  EditGoalsView.swift
//  Pomodoro
//
//  Created by Kendrew Chan on 23/11/17.
//  Copyright © 2017 testtest. All rights reserved.
//

import UIKit

class EditGoalsView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func doneBtn(_ sender: Any) {
        setGoals()
        setDate()
        isPickerUp = false
        datePicker.alpha = 0
        textField.resignFirstResponder()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true) //to end keyboard if finger touches outside of keyboard
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder() //for keyboard to end when return key is touched
        
        return true
        
    }
    
    var isPickerUp = false
    var goalsString = String()
    var daysString = String()
    var endDate = Date()
    
    @IBAction func pickerBtn(_ sender: Any) {
        pickerAlphaSwap()
        setDate()
    }
    
    func pickerAlphaSwap() {
        if isPickerUp == false {
            datePicker.alpha = 1
            isPickerUp = true
        } else {
            isPickerUp = false
            datePicker.alpha = 0
        }
    }
    
    @IBAction func pickerChanged(_ sender: Any) {
        setDate()
        datePicker.setDate(datePicker.date, animated: false)
    }
    
    
    func setDate(){
        if isPickerUp == false, let y = UserDefaults.standard.object(forKey: "goalDay") as? Date {
            endDate = y
        } else {
        endDate = datePicker.date
        UserDefaults.standard.set(endDate, forKey: "goalDay")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        btnDate.setTitle(dateFormatter.string(from: endDate), for: .normal)
    }
    
    func setGoals() {
        if textField.text == "", let x = UserDefaults.standard.object(forKey: "goalSave") as? String {
                goalsString = x
            } else {
            goalsString = textField.text!
            UserDefaults.standard.set(goalsString, forKey: "goalSave")
        }
        // UserDefaults.standard.set(goalsString, forKey: "goalSave")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
        if let y = UserDefaults.standard.object(forKey: "goalDay") as? Date {
            endDate = y
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            btnDate.setTitle(dateFormatter.string(from: endDate), for: .normal)
            datePicker.setDate(endDate, animated: false)
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
