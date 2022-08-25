//
//  LoanController.swift
//  financial-calculator
//
//  Created by Mohamed Shazni on 2022-04-11.
//

// Formula Attribute Naming
//
// P = present/principal/amount value
// F = future value
// r = interest rate
// t = (time) number of payments
// n = compound per year
// PMT = payment
 

import Foundation

import UIKit

class LoanController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var interestRateTf: UITextField!
    @IBOutlet weak var noOfPaymentsTf: UITextField!
    @IBOutlet weak var paymentTf: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    var loan : LoanValue = LoanValue(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("LoanHistory")
        self.loadInputWhenAppOpen()
    }
    
    //array data load func
    func loadDefaultsData(_ historyKey :String) {
        let defaultStand = UserDefaults.standard
        loan.historyStringArray = defaultStand.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    //diable the system keyboard popup
    func assignDelegates() {
        amountTf.delegate = self
        amountTf.inputView = UIView()
        interestRateTf.delegate = self
        interestRateTf.inputView = UIView()
        noOfPaymentsTf.delegate = self
        noOfPaymentsTf.inputView = UIView()
        paymentTf.delegate = self
        paymentTf.inputView = UIView()
    }
    
    //save the data to relevant key
    @IBAction func editAmountSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(amountTf.text, forKey:"loan_amount")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(interestRateTf.text, forKey:"loan_interest_rate")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(noOfPaymentsTf.text, forKey:"loan_noOfPayments")
    }
    
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(paymentTf.text, forKey:"loan_payment")
    }
  
    //loading data
    func loadInputWhenAppOpen(){
        let dfValue =  UserDefaults.standard
        let dfAmount = dfValue.string(forKey:"loan_amount")
        let dfInterestRate = dfValue.string(forKey:"loan_interest_rate")
        let dfNoOfPayments = dfValue.string(forKey:"loan_noOfPayments")
        let dfPayment = dfValue.string(forKey:"loan_payment")
        
        amountTf.text = dfAmount
        interestRateTf.text = dfInterestRate
        noOfPaymentsTf.text = dfNoOfPayments
        paymentTf.text = dfPayment
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    //clear function for text fields
    @IBAction func onClear(_ sender: UIButton) {
        
        amountTf.text = ""
        interestRateTf.text = ""
        noOfPaymentsTf.text = ""
        paymentTf.text = ""
    }
    
    //button onclick calculate formula
    @IBAction func onCalculate(_ sender: UIButton) {
        
        //condition checking for filled or not filled
        if amountTf.text! == "" && interestRateTf.text! == "" &&
           paymentTf.text! == "" && noOfPaymentsTf.text! == "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: "Please enter values to calculate ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
            } else if amountTf.text! != "" && interestRateTf.text! != "" &&
                  paymentTf.text! != "" && noOfPaymentsTf.text! != "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: " Need one field empty.", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        //calculate the payment
        } else if paymentTf.text! == "" && amountTf.text! != "" &&
        interestRateTf.text! != "" && noOfPaymentsTf.text! != ""{
            
               let amountVal = Double(amountTf.text!)!
               let interestRateVal = Double(interestRateTf.text!)!
               let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
               let interestDiv = interestRateVal/100
               
                //payment calculation formula - M = P[i(1+i)n] / (1+i)nt
                let paymentCalFormula = amountVal * ( (interestDiv/12 * pow(1 + interestDiv/12 , noOfPaymentsVal) ) / ( pow(1 + interestDiv/12 , noOfPaymentsVal) - 1 ) )
                paymentTf.text = String(format: "%.2f",paymentCalFormula)
            
        //amaount calculations
        } else if amountTf.text! == "" && noOfPaymentsTf.text! != "" && interestRateTf.text! != "" && paymentTf.text! != "" {
                
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            let interestRateVal = Double(interestRateTf.text!)!
            let paymentVal = Double(paymentTf.text!)!
            let interestDiv = interestRateVal/100
        
            //mortgage amout calculate  formula - P= (M * ( pow ((1 + R/t), (n*t)) - 1 )) / ( R/t * pow((1 + R/t), (n*t)))
            let PresentAmountCal  = (paymentVal * ( pow((1 + interestDiv / noOfPaymentsVal), (noOfPaymentsVal)) - 1 )) / ( interestDiv / noOfPaymentsVal * pow((1 + interestDiv / noOfPaymentsVal), (noOfPaymentsVal)))
            amountTf.text = String(format: "%.2f",PresentAmountCal)
           
        //rate calculations
        } else if interestRateTf.text! == "" && amountTf.text! != "" && noOfPaymentsTf.text! != "" && paymentTf.text! != "" {
            
            let alert = UIAlertController(title: "Warning", message: "Interest rate calculation is not set. ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)        
            
        //number of payment calculations
        } else if noOfPaymentsTf.text! == "" && amountTf.text! != "" && interestRateTf.text! != "" && paymentTf.text! != "" {
            
            let amountVal = Double(amountTf.text!)!
            let interestRateVal = Double(interestRateTf.text!)!
            let paymentVal = Double(paymentTf.text!)!
            let interestDiv = (interestRateVal / 100) / 12
            
            //number of payments calculations formula - log((PMT / i) / ((PMT / i) - P)) / log(1 + i)
            let calculatNoOfMonthsFormula = log((paymentVal / interestDiv) / ((paymentVal / interestDiv) - amountVal)) / log(1 + interestDiv)
            //calculatedNumOfYears formula = round(100 * (calculatedNumOfMonths / 12)) / 100
            noOfPaymentsTf.text = String(format: "%.2f",calculatNoOfMonthsFormula)
            
        } else {
        
            let alert = UIAlertController(title: "Warning", message: "Please enter value(s) to calculate ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    //button onclick function for save data
    @IBAction func onSave(_ sender: UIButton){
        
        if amountTf.text != "" && interestRateTf.text != "" &&
        paymentTf.text != "" && noOfPaymentsTf.text != ""{
        
        let defaultStand = UserDefaults.standard
        let saveDis = "Loan Amount  \(amountTf.text!), Interest Rate  \(interestRateTf.text!) %, No.of Payment  \(noOfPaymentsTf.text!), Payment  \(paymentTf.text!)"
           
           loan.historyStringArray.append(saveDis)
           defaultStand.set(loan.historyStringArray, forKey: "LoanHistory")
        
            let alert = UIAlertController(title: "Success Alert", message: " Saved.", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        } else if amountTf.text == "" || interestRateTf.text == "" ||
        paymentTf.text == "" || noOfPaymentsTf.text == "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: "Inputs Empty", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        } else {
            let alert = UIAlertController(title: "Error Alert", message: "UnSuccessful Save", preferredStyle: .alert)
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        }
          
       }
}
