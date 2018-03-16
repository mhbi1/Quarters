//
//  Transaction+CoreDataProperties.swift
//  Bettermint
//
//  Created by Michael Bi on 2/7/18.
//  Copyright © 2018 MB&JG. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {
  
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        let fetchRequest = NSFetchRequest<Transaction>(entityName: "Transaction")
        //let primarySortDescriptor = NSSortDescriptor(key: "type", ascending: false)
        //fetchRequest.sortDescriptors = [primarySortDescriptor]
        return fetchRequest
    }
    
    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var descrip: String?
    @NSManaged public var type: String?
    
    // Get Functions
    func getAmount() -> Double{
        return amount
    }
    
    func getDescription() -> String{
        return descrip!
    }
    
    func getTransactionType() -> String{
        return type!
    }
    
    func getDate() -> NSDate{
        return date!
    }
    
    // Set Functions
    func setAmount(a:Double){
        amount = a * 0.01
    }
    
    func setDescription(d:String){
        descrip = d
    }
    
    func setTransactionType(t: String){
        type = t
    }


}
