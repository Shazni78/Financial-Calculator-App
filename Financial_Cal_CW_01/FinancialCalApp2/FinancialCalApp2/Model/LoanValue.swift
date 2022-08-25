//
//  Loan.swift
//  financial-calculator
//
//  Created by Mohamed Shazni on 2022-04-11.
//

import Foundation

class LoanValue {
    var amount : Double
    var interestRate : Double
    var noOfPayments : Double
    var payment : Double
    var historyStringArray : [String]
    
    init(amount: Double, interestRate: Double, noOfPayments: Double, payment: Double) {
        self.amount = amount
        self.interestRate = interestRate
        self.noOfPayments = noOfPayments
        self.payment = payment
        self.historyStringArray = [String]()
    }
}
