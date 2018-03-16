//
//  OverviewTabViewController.swift
//  Bettermint
//
//  Created by Michael Bi on 1/19/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit
import CoreData
import Charts

class OverviewTabViewController: UIViewController, UITextViewDelegate, ChartViewDelegate {
    
    var transactionData: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var newTransaction: Transaction?
    
    var transactionHeaders: [String] = ["Expense", "Personal"]
    var transactions: [Transaction] = []
    let defaults = UserDefaults.standard
    var transactionType: String?
    var monthlyIncome: Double?
    var expensesAmount: Double?
    var personalAmount: Double?
    var savingsAmount: Double?
    
    var amountAlert: UIAlertController = UIAlertController()
    var descripAlert: UIAlertController = UIAlertController()
    var typeAlert: UIAlertController = UIAlertController()
    
    @IBOutlet weak var expenseTable: UITableView!
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var savingsAmountText: UILabel!
    @IBOutlet weak var totalSpentAmountText: UILabel!
    @IBOutlet weak var incomeAmountText: UILabel!
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var personalButton: UIButton!
    @IBOutlet weak var expenseButton: UIButton!
    @IBOutlet weak var transactionDescription: UITextView!
   
    func fetchList() {
        // Fetches the request, executes and adds to the array
        transactions = ((try? transactionData.fetch(Transaction.fetchRequest())))!
    }
    
    public func deleteContext(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Delete all data in Transaction error : \(error) \(error.userInfo)")
        }
    }
    
    // MARK: Chart
    // Selecting value brings you to transactions tableView
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let temp: PieChartDataEntry = entry.copyWithZone(nil) as! PieChartDataEntry
        if (temp.label != "Savings") {
            transactionType = temp.label
            self.performSegue(withIdentifier: "toTransactions", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toTransactions"){
            let destVC = segue.destination as! TransactionsViewController
            destVC.transactionType = transactionType
        }
    }
    
    @IBAction func unwindToOverviewVC(segue: UIStoryboardSegue){
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        transactionDescription.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList()
        monthlyIncome = defaults.double(forKey: "monthlyIncome")
        pieChart.delegate = self
        updatePieChart()
        updateAccountOverview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchList()
        getMonthlyIncome()
        updatePieChart()
        updateAccountOverview()
    }
    
    func updateAccountOverview(){
        incomeAmountText.text = String(format: "$%.02f", monthlyIncome!)
        totalSpentAmountText.text = String(format: "$%.02f", personalAmount! + expensesAmount!)
        savingsAmountText.text = String(format: "$%.02f", savingsAmount!)
    }
    
    func updatePieChart(){
        expensesAmount = getExpensesAmount()
        personalAmount = getPersonalAmount()
        savingsAmount = monthlyIncome! - expensesAmount! - personalAmount!
        let expenses = PieChartDataEntry(value: expensesAmount!, label: "Expenses")
        let personal = PieChartDataEntry(value: personalAmount!, label: "Personal")
        let savings =  PieChartDataEntry(value: savingsAmount!, label: "Savings")
        let dataSet = PieChartDataSet(values: [expenses, personal, savings], label: "")
        let data = PieChartData(dataSet: dataSet)
        dataSet.selectionShift = 15
        dataSet.sliceSpace = 2
        data.setValueTextColor(UIColor.gray)
        pieChart.data = data
        pieChart.drawHoleEnabled = false
        pieChart.drawEntryLabelsEnabled = false
        pieChart.drawSlicesUnderHoleEnabled = true
        pieChart.chartDescription?.text = ""
        
        dataSet.colors = ChartColorTemplates.liberty()
        
        
        pieChart.notifyDataSetChanged()
    }
    
    func getMonthlyIncome(){
        monthlyIncome = defaults.double(forKey: "monthlyIncome")
    }
    
    func getExpensesAmount() -> Double{
        var amount = 0.00
        for t in transactions{
            if (t.type == "Expense"){
                amount += t.getAmount()
            }
        }
        return amount
    }
    
    func getPersonalAmount() -> Double{
        var amount = 0.00
        for t in transactions{
            if (t.type == "Personal"){
                amount += t.getAmount()
            }
        }
        return amount
    }
}



