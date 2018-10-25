//
//  TrackerVC.swift
//  SpenTrack
//
//  Created by Kendrew Chan on 3/3/18.
//  Copyright © 2018 KCStudios. All rights reserved.
//

import UIKit

class TrackerVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleDate: UINavigationItem!
    
    @IBOutlet weak var spentOnWhatTextField: UITextField!
    @IBOutlet weak var amtSpent: UILabel!
    var itemToEdit: Item?
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }

    var currentOperation = Operation.Empty
    var runningNumber = "0"
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var numPressed: Bool = false
    var calcOnce: Bool = false
    var decimalPoint = false // control whether decimalPoint has been pressed or not
    var newEntry = true // control whether its a newEntry or not
    var newCalculation = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true) //to end keyboard if finger touches outside of keyboard
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        spentOnWhatTextField.resignFirstResponder() //for keyboard to end when return key is touched
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spentOnWhatTextField.delegate = self // to resignFirstResponder
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.done, target: nil, action: nil)
        } 
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let currentDate = Date()
        
        let convertedDateString = dateFormatter.string(from: currentDate)
        
        if itemToEdit != nil { //if existing item/object is passed into the view, then load its data
            loadItemData()
        } else {
            titleDate.title = convertedDateString
            newEntry = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
//        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @IBAction func savePressed(_ sender: Any) {
        processOperation(operation: currentOperation)
        
        var item: Item!
        
        if itemToEdit == nil {
            item = Item(context: context) //insert entity into the "sketchpad" or the NSManagedObjectContext
        } else {
            item = itemToEdit //to avoid replicas
        }
        
        if let calcSpending = amtSpent.text {
            item.dailySpending = Double(calcSpending)!
        }
        
        if let textField = spentOnWhatTextField.text {
            item.spentText = textField
        }
        
        if let dateTitle = titleDate.title {
            item.edited = dateTitle
        }
        
        ad.saveContext()
        navigationPop()
    }
    
    @IBAction func deletePressed(_ sender: Any) {
        deleteItem()
        navigationPop()
        spentOnWhatTextField.resignFirstResponder()
    }
    
    
    @IBAction func numberPressed(_ sender: UIButton) {
        runningNumber += "\(sender.tag)"
        if runningNumber == "0" + "\(sender.tag)" {
            runningNumber = "\(sender.tag)"
        }
        amtSpent.text = runningNumber
        if calcOnce {
            currentOperation = Operation.Empty // go back to first calculation
        }
        printVals()
    }
    
    @IBAction func onDividePressed(_ sender: AnyObject) {
        processOperation(operation: .Divide)
        calcOnce = false // prepare for second calculation
        printVals()
    }
    
    @IBAction func onMultiplyPressed(_ sender: AnyObject) {
        processOperation(operation: .Multiply)
        calcOnce = false
        printVals()
    }
    
    @IBAction func onSubtractPressed(_ sender: AnyObject) {
        processOperation(operation: .Subtract)
        calcOnce = false
        printVals()
    }
    
    @IBAction func onAddPressed(_ sender: AnyObject) {
        processOperation(operation: .Add)
        calcOnce = false
        printVals()
    }
    
    @IBAction func onEqualPressed(_ sender: AnyObject) {
        if runningNumber == "0." {
            runningNumber = "0.0"
            amtSpent.text = runningNumber
        }
        processOperation(operation: currentOperation)
//        leftValStr = amtSpent.text!
        printVals()
    }
    
    @IBAction func onDecimalPressed(_ sender: Any) {
        if decimalPoint == false {
            if runningNumber == "" {
            runningNumber += "0."
            } else {
                runningNumber += "."
            }
            amtSpent.text = runningNumber
            decimalPoint = true
            if calcOnce {
                currentOperation = Operation.Empty // go back to first calculation
            }
            printVals()
        } else {
            print("decimalPoint already used")
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var decimalPlace = 1
    func processOperation(operation: Operation) {
        func firstCalculation() {
            leftValStr = runningNumber // 8
            runningNumber = ""
            currentOperation = operation
            decimalPoint = false
            print("first calculation")
        }
        func secondCalculation() {
            if runningNumber != "" { //
                rightValStr = runningNumber // rightVal == 8
                runningNumber = ""
                
                if leftValStr == "" { // for cases where leftValStr is 0
                    leftValStr = "0.0"
                }
                
                if currentOperation == Operation.Multiply {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                } else if currentOperation == Operation.Divide {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                } else if currentOperation == Operation.Subtract {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                } else if currentOperation == Operation.Add {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                } else {
                    result = "0.0"
                    printVals()
                }
                
                leftValStr = result
                amtSpent.text = result
            }
            currentOperation = operation
            decimalPoint = false
            print("second calculation")
        }
        
        if currentOperation != Operation.Empty && newEntry == false { // if there exists an operation
            //A user selected an operator, but then selected another operator without first entering a number
            
            secondCalculation()
            calcOnce = true // prepare for either pressing Number or Operator
            // if number pressed, since calcOnce is true, currentOperation becomes empty, so go back to first calculation
            // if operator pressed, calcOnce becomes false, currentOperation !- empty, so maintains at second calculation
        } else {
            //This is the first time an operator has been pressed
            
            firstCalculation()
            calcOnce = false
            newEntry = false
        }
    }
    
    func printVals() {
        print("Left: " + leftValStr)
        print("Right: " + rightValStr)
        print("CurrentOp: " + "\(currentOperation)")
    }
    
    @objc func backToInitial(sender: AnyObject) {
        if amtSpent.text != "" {
            
            var item: Item!
            
            if itemToEdit == nil {
                item = Item(context: context) //insert entity into the "sketchpad" or the NSManagedObjectContext
            } else {
                item = itemToEdit //to avoid replicas
            }
            
            if let text = spentOnWhatTextField.text {
                item.spentText = text
            }
            
            if let spent = amtSpent.text {
                item.dailySpending = Double(spent)!
            }
            
            if let title = titleDate.title {
                item.edited = title
            }
            
            ad.saveContext()
        } else {
            deleteItem()
        }
        navigationPop()
        spentOnWhatTextField.resignFirstResponder()
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            spentOnWhatTextField.text = item.spentText
            runningNumber = "\(item.dailySpending)"
            amtSpent.text = runningNumber
            currentOperation = Operation.Empty
            titleDate.title = item.edited
            decimalPoint = true
        }
    }
    
    func deleteItem() {
        if itemToEdit != nil { //check if there's an existing item
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        spentOnWhatTextField.resignFirstResponder()
    }
    
    func navigationPop() {
        navigationController?.popViewController(animated: true)
    }
    
}
