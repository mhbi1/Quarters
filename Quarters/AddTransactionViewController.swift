//
//  AddTransactionViewController.swift
//  Bettermint
//
//  Created by Michael Bi on 1/17/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit
import CoreData
import TRCurrencyTextField

class AddTransactionViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var amountTextField: TRCurrencyTextField!
    @IBOutlet weak var personalButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var transactionDescription: UITextView!
    
    var type: String = ""
    var selectedType: Bool = false
    var regFont: UIFont = UIFont()
    var boldFont: UIFont = UIFont()
    var amountAlert: UIAlertController = UIAlertController()
    var descripAlert: UIAlertController = UIAlertController()
    var typeAlert: UIAlertController = UIAlertController()
    var overviewTabVC: OverviewTabViewController = OverviewTabViewController()
    var transactionVC: TransactionsViewController = TransactionsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimate()
        // Sets add transaction popup background to transparent
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        
        // Allows keyboard to hide when tapping anywhere but the textfield
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:
            self.view, action: #selector(UIView.endEditing(_:))))
        
        //Sets up the checks for the input info
        amountAlert = UIAlertController(title: "Invalid Amount", message: "Please enter a valid amount.", preferredStyle: UIAlertControllerStyle.alert)
        amountAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        descripAlert = UIAlertController(title: "Missing Description", message: "Please enter a description.", preferredStyle: UIAlertControllerStyle.alert)
        descripAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        typeAlert = UIAlertController(title: "No Type Selected", message: "Please select a type.", preferredStyle: UIAlertControllerStyle.alert)
        typeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        //Adds the toolbar on top of the keyboard
        let toolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        toolBar.items = items
        toolBar.sizeToFit()
        
        amountTextField.inputAccessoryView = toolBar
        transactionDescription.inputAccessoryView = toolBar
        
        transactionDescription.delegate = self
        amountTextField.delegate = self 
        
        //Sets up font for expense/personal
        regFont = UIFont(name: "Mosk Normal 400", size: 32)!
        boldFont = UIFont(name: "MoskUltra-Bold900", size: 32)!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        transactionDescription.text = ""
    }
    
    @IBAction func closeAddTransactionView(_ sender: UIButton) {
        removeAnimate()
    }
    
    // MARK: Popup animations
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished: Bool) in
            if (finished){
                self.view.removeFromSuperview()
            }
        })
    }
    
    // Adds the transaction to core data
    @IBAction func addTransaction(_ sender: Any){
        if ((amountTextField.text?.isEmpty)! ){
            self.present(amountAlert, animated: true, completion: nil)
        }
        else if(transactionDescription.text.isEmpty) {
            self.present(descripAlert, animated: true, completion: nil)
        }
        else if (!selectedType){
            self.present(typeAlert, animated: true, completion: nil)
        }
        else {
            let description: String = transactionDescription.text
            let amount: Double = Double(amountTextField.text!)!
            let ent = NSEntityDescription.entity(forEntityName: "Transaction", in: overviewTabVC.transactionData)
            
            
            let newTransaction = Transaction(entity: ent!, insertInto: overviewTabVC.transactionData)
            newTransaction.setAmount(a: amount)
            newTransaction.setDescription(d: description)
            newTransaction.setTransactionType(t: type)
            
            do {
                try overviewTabVC.transactionData.save()
            } catch _ {}
        }
        removeAnimate()
    }
    
    @IBAction func selectPersonal(_ sender: Any) {
        type = "Personal"
        personalButton.titleLabel?.font = boldFont
        expenseButton.titleLabel?.font = regFont
        selectedType = true
    }
    
    @IBAction func selectExpense(_ sender: Any) {
        type = "Expense"
        expenseButton.titleLabel?.font = boldFont
         personalButton.titleLabel?.font = regFont
        selectedType = true
    }
    
}

