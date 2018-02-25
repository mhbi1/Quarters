//
//  TransactionsViewController.swift
//  Bettermint
//
//  Created by Michael Bi on 2/24/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//

import UIKit
import CoreData

class TransactionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let refreshControl = UIRefreshControl()
    
    var transactionData: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var transactions: [Transaction] = []
    var personalTransactions: [Transaction] = []
    var expenseTransactions: [Transaction] = []
    var transactionType: String?
    @IBOutlet weak var transactionsTable: UITableView!
    
    func fetchList() {
        // Fetches the request, executes and adds to the array
        transactions = ((try? transactionData.fetch(Transaction.fetchRequest())))!
    }
    
    func getTransactionTypeList(){
        
        for t in transactions{
            if (t.getTransactionType() == "Personal"){
                personalTransactions.append(t)
            }
            else{
               expenseTransactions.append(t)
            }
        }
    }
    
    // MARK: TableView
    // Returns the number of rows and data for each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //If no transactions
        if (transactions.count == 0){
            let noDataLabel: UILabel        = UILabel(frame: CGRect(x: 0, y: 0, width:
                tableView.bounds.size.width, height: tableView.bounds.size.height-20))
            noDataLabel.text                = "No transactions available"
            noDataLabel.textColor           = UIColor.black
            noDataLabel.textAlignment       = .center
            tableView.backgroundView        = noDataLabel
            tableView.separatorStyle        = .none
            return transactions.count
        }
        else{
            tableView.separatorStyle = .none
            return transactionType == "Personal" ?  personalTransactions.count : expenseTransactions.count
        }
    }
    
    // This datasource method will create each cell of the table
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionCell", for: indexPath) as! TransactionTableViewCell
        
       
        if (transactionType == "Personal"){
            if (indexPath.row < personalTransactions.count){
                //Get the transactions for personal
                let t = personalTransactions[indexPath.row]
                
                cell.descriptionLabel?.text = t.getDescription()
                cell.amountLabel?.text = String(format: "%.2f", t.getAmount())
                cell.detailTextLabel?.textAlignment = .left
            }
        }
        else{
            if (indexPath.row < expenseTransactions.count){
                //Get the transactions for expenses
                let t = expenseTransactions[indexPath.row]
                
                cell.descriptionLabel?.text = t.getDescription()
                cell.amountLabel?.text = String(format: "%.2f", t.getAmount())
                cell.detailTextLabel?.textAlignment = .left
            }
        }
        
        return cell
    }
    
    //Header titles for sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        /*if (section < transactionHeaders.count){
            return transactionHeaders[section]
        }*/
        return transactionType
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        if let textlabel = header.textLabel {
            textlabel.font = textlabel.font.withSize(24)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchList()
        getTransactionTypeList()
        // Set up refresh control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTransactionData(_:)), for: .valueChanged)
        self.transactionsTable.addSubview(refreshControl)
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func refreshTransactionData(_: Any){
        fetchTransactionData()
    }
    
    private func fetchTransactionData(){
        fetchList()
        getTransactionTypeList()
        self.refreshControl.endRefreshing()
        transactionsTable.reloadData()
    }

}

class TransactionTableViewCell: UITableViewCell{
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
}
