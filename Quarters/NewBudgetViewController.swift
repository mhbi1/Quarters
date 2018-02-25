//
//  NewBudgetViewController.swift
//  Bettermint
//
//  Created by Michael Bi on 2/3/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit
import CoreData

class NewBudgetViewController: UIViewController {
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var incomeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startNewBudget(_ sender: UIButton) {
        let income: Double = Double(incomeText.text!)!
        
        defaults.set(true, forKey: "doesUserExist")
        defaults.set(income, forKey: "monthlyIncome")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
