//
//  CompoundOptSelectController.swift
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

class MortgageViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var interestRateTf: UITextField!
    @IBOutlet weak var noOfPayementsTf: UITextField!
    @IBOutlet weak var paymentTf: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    var mortgageValues : Mortgage = Mortgage(amount: 0.0, interestRate: 0.0, noOfPayments: 0.0, payment: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assignDelegates()
        self.loadDefaultsData("MortgageHistory")
        self.loadInputWhenAppOpen()
        
    }
    
    //array data load func
    func loadDefaultsData(_ historyKey :String) {
        let defaultStand = UserDefaults.standard
        mortgageValues.historyStringArray = defaultStand.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    //disable the system keyboard popup
    func assignDelegates() {
        amountTf.delegate = self
        amountTf.inputView = UIView()
        interestRateTf.delegate = self
        interestRateTf.inputView = UIView()
        noOfPayementsTf.delegate = self
        noOfPayementsTf.inputView = UIView()
        paymentTf.delegate = self
        paymentTf.inputView = UIView()
    }
    
    //save the data to relevant key
    @IBAction func editAmountSaveDefault(_ sender: UITextField)  {
        let dfValue = UserDefaults.standard
        dfValue.set(amountTf.text, forKey:"mortgage_amount")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(interestRateTf.text, forKey:"mortgage_interest_rate")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(noOfPayementsTf.text, forKey:"mortgage_noOfPayments")
    }
    
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
          dfValue.set(paymentTf.text, forKey:"mortgage_payment")
    }

    //loading data
    func loadInputWhenAppOpen(){
        let dfValue =  UserDefaults.standard
        let dfAmount = dfValue.string(forKey:"mortgage_amount")
        let dfInterestRate = dfValue.string(forKey:"mortgage_interest_rate")
        let dfNoOfPayments = dfValue.string(forKey:"mortgage_noOfPayments")
        let dfPayment = dfValue.string(forKey:"mortgage_payment")
        
        amountTf.text = dfAmount
        interestRateTf.text = dfInterestRate
        noOfPayementsTf.text = dfNoOfPayments
        paymentTf.text = dfPayment
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        keyboardView.activeTextField = textField
    }
    
    //clear function for text fields
    @IBAction func onClear(_ sender: UIButton) {
        
        amountTf.text = ""
        interestRateTf.text = ""
        noOfPayementsTf.text = ""
        paymentTf.text = ""
    }
    
    //button onclick calculate formula
    @IBAction func onCalculate(_ sender: UIButton) {
        
        //condition checking for filled or not filled
        if amountTf.text! == "" && interestRateTf.text! == "" &&
           paymentTf.text! == "" && noOfPayementsTf.text! == "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: "Enter Values to Calculate ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            
            self.present(alert, animated: true, completion:nil)
            
            } else if amountTf.text! != "" && interestRateTf.text! != "" &&
                  paymentTf.text! != "" && noOfPayementsTf.text! != "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: " Keep One Empty Field.", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            
            self.present(alert, animated: true, completion:nil)
            
        //calculate the payment
        } else if paymentTf.text! == "" && amountTf.text! != "" &&
        interestRateTf.text! != "" && noOfPayementsTf.text! != "" {
            
               let amountVal = Double(amountTf.text!)!
               let interestRateVal = Double(interestRateTf.text!)!
               let noOfPaymentsVal = Double(noOfPayementsTf.text!)!
                
               let interestDiv = interestRateVal/100
                //payment calculation formula - M = P[i(1+i)n] / (1+i)nt
                let paymentFormula = amountVal * ( (interestDiv/12 * pow(1 + interestDiv/12 , noOfPaymentsVal) ) / ( pow(1 + interestDiv/12 , noOfPaymentsVal) - 1 ) )
               
                //decimal calculations formula = Double(round(100*payment)/100)
                paymentTf.text = String(format: "%.2f",paymentFormula )
            
        //amount calculations
        } else if amountTf.text! == "" && noOfPayementsTf.text! != "" &&
        interestRateTf.text! != "" && paymentTf.text! != ""{
          
             let noOfPaymentsVal = Double(noOfPayementsTf.text!)!
             let interestRateVal = Double(interestRateTf.text!)!
             let paymentVal = Double(paymentTf.text!)!
             let interestDiv = interestRateVal/100
           
            //mortgage calculate formula - P= (M * ( pow ((1 + R/t), (n*t)) - 1 )) / ( R/t * pow((1 + R/t), (n*t)))
             let PresentCalFormula  = (paymentVal * ( pow((1 + interestDiv / noOfPaymentsVal), (noOfPaymentsVal)) - 1 )) / ( interestDiv / noOfPaymentsVal * pow((1 + interestDiv / noOfPaymentsVal), (noOfPaymentsVal)))
             amountTf.text = String(format: "%.2f",PresentCalFormula)
            
        //calculate the interest rate
        } else if interestRateTf.text! == "" && amountTf.text! != "" &&
        noOfPayementsTf.text! != "" && paymentTf.text! != "" {
            
            let alert = UIAlertController(title: "Warning", message: "Interest rate calculation is not defined. ", preferredStyle: .alert)
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        //number of payments calculations
        } else if noOfPayementsTf.text! == "" && interestRateTf.text! != "" && amountTf.text! != "" && paymentTf.text! != ""{
            
            let amountVal = Double(amountTf.text!)!
            let interestRateVal = Double(interestRateTf.text!)!
            let paymentVal = Double(paymentTf.text!)!
            let interestDiv = (interestRateVal / 100) / 12
            
            //number of payments calculations formula- log((PMT / i) / ((PMT / i) - P)) / log(1 + i)
            let numOfMonthsCalFormula = log((paymentVal / interestDiv) / ((paymentVal / interestDiv) - amountVal)) / log(1 + interestDiv)
            // calculate the no of years formula = round(100 * (calculatedNumOfMonths / 12)) / 100
            noOfPayementsTf.text = String(format: "%.2f",numOfMonthsCalFormula)
            
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
        
        if amountTf.text! != "" && interestRateTf.text! != "" &&
        paymentTf.text! != "" && noOfPayementsTf.text! != ""
        {
        let defaultStand = UserDefaults.standard
        //save format
        let saveDisplay = "Mortgage Amount \(amountTf.text!), Interest Rate \(interestRateTf.text!)%, No.of Payment \(noOfPayementsTf.text!), Payment \(paymentTf.text!)"
           
           mortgageValues.historyStringArray.append(saveDisplay)
           defaultStand.set(mortgageValues.historyStringArray, forKey: "MortgageHistory")
            
            let alert = UIAlertController(title: "Success Alert", message: "Saved", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
        }
        else if amountTf.text == "" || interestRateTf.text == "" ||
        paymentTf.text == "" || noOfPayementsTf.text == ""{
            
            let alert = UIAlertController(title: "Warning Alert", message: "Inputs Empty", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
        }  else{
            
        let alert = UIAlertController(title: "Error Alert", message: "UnSuccessful Save", preferredStyle: .alert)
            
        let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
            
        alert.addAction(success)
        self.present(alert, animated: true, completion:nil)
        }
       }
}
