//
//  SettingsTableViewController.swift
//  Quarters
//
//  Created by Michael Bi on 3/6/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newMonthlyIncome: CurrencyTextField!
    @IBOutlet weak var estimatedIncomeCell: ExpansionCellTableViewCell!
    @IBOutlet weak var estimatedExpandedIcon: UILabel!
    @IBOutlet weak var DestionationView: UIView!
    
    private var dataCellExpanded: Bool = false
    let defaults = UserDefaults.standard
    var overviewVC: OverviewTabViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.tableFooterView = UIView()
        //Adds the toolbar on top of the keyboard
        let toolBar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        toolBar.barStyle = .default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        let items = [flexSpace, done]
        toolBar.items = items
        toolBar.sizeToFit()
        
        newMonthlyIncome.inputAccessoryView = toolBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(false)
        dataCellExpanded = false
        
        let newIncome: Double = Double(newMonthlyIncome.getAmount())!
        defaults.set((newIncome * 0.01), forKey: "monthlyIncome")
        
        newMonthlyIncome.text = "$0.00"
        estimatedExpandedIcon.text = "+"
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        if (indexPath.row == 1){
            if (dataCellExpanded){
                estimatedExpandedIcon.text = "+"
                dataCellExpanded = false
            }
            else {
                dataCellExpanded = true
                estimatedExpandedIcon.text = "-"
            }
        }
        else if(indexPath.row == 2){
             overviewVC?.deleteContext()
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 1){
            return dataCellExpanded ? 96 : 40
        }
        else {
            return 40
        }
    }
    
    func deleteTransactions(){
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
}
