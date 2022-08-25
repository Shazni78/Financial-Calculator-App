//
//  SavingsController.swift
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

class SavingsController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var endBeginLabel: UILabel!
    @IBOutlet weak var presentValueTf: UITextField!
    @IBOutlet weak var futureValueTf: UITextField!
    @IBOutlet weak var interestRateTf: UITextField!
    @IBOutlet weak var noOfPaymentsTf: UITextField!
    @IBOutlet weak var paymentTf: UITextField!
    @IBOutlet weak var compoundPerYearTf: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    
    
    @IBOutlet weak var endBeginSwitch: UISwitch!
    
    var savingValues : Savings = Savings(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0,  noOfPayments: 0.0)
    
    override func viewDidLoad() {
          super.viewDidLoad()
          self.assignDelegates()
          self.loadDefaultsData("SavingsHistory")
          self.loadInputWhenAppOpen()
      }
      
      //array data load func
      func loadDefaultsData(_ historyKey :String) {
          let defaultStand = UserDefaults.standard
          savingValues.historyStringArray = defaultStand.object(forKey: historyKey) as? [String] ?? [String]()
      }
      
      //diable the system keyboard popup
      func assignDelegates() {
          presentValueTf.delegate = self
          presentValueTf.inputView = UIView()
          futureValueTf.delegate = self
          futureValueTf.inputView = UIView()
          interestRateTf.delegate = self
          interestRateTf.inputView = UIView()
          noOfPaymentsTf.delegate = self
          noOfPaymentsTf.inputView = UIView()
          paymentTf.delegate = self
          paymentTf.inputView = UIView()
          endBeginLabel.text = "END - ON / BEGIN - OFF"
          compoundPerYearTf.text = "12"
      }
    
    //save the data to relevant key
    @IBAction func editPresentSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(presentValueTf.text, forKey:"savings_present")
    }
    
    @IBAction func editFutureSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(futureValueTf.text, forKey:"savings_future")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(interestRateTf.text, forKey:"savings_interest")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(noOfPaymentsTf.text, forKey:"savings_noOfPayment")
    }
    
    @IBAction func editPaymentSaveDefault(_ sender: UITextField) {
        let dfValue = UserDefaults.standard
        dfValue.set(paymentTf.text, forKey:"savings_payment")
    }
    
    @IBAction func editSwitchSaveDefault(_ sender: UISwitch) {
        let dfValue = UserDefaults.standard
        dfValue.set(endBeginSwitch.isOn, forKey:"savings_endBegin")
    }
    

    //loading data
    func loadInputWhenAppOpen(){
        let dfValue =  UserDefaults.standard
        let dfPresent = dfValue.string(forKey:"savings_present")
        let dfInterestRate = dfValue.string(forKey:"savings_interest")
        let dfNoOfPayments = dfValue.string(forKey:"savings_noOfPayment")
        let dfFuture = dfValue.string(forKey:"savings_future")
        let dfPayment = dfValue.string(forKey:"savings_payment")
        
        //end begin defualt
        dfValue.set(true, forKey:"savings_endBegin")
        
        presentValueTf.text = dfPresent
        futureValueTf.text = dfFuture
        interestRateTf.text = dfInterestRate
        noOfPaymentsTf.text = dfNoOfPayments
        paymentTf.text = dfPayment
    }
    
      //keybord used input display
      func textFieldDidBeginEditing(_ textField: UITextField) {
          keyboardView.activeTextField = textField
      }
    
    //switch changer
    @IBAction func endBeginClicked(_ sender: UISwitch) {
        
        if sender.isOn {
            endBeginLabel.text! = "END - ON / BEGIN - OFF"
        }
        else {
            endBeginLabel.text! = "END - OFF / BEGIN - ON"
        }
    }
    
    //clear function for all inputs
    @IBAction func onClear(_ sender: UIButton) {
          
          presentValueTf.text! = ""
          futureValueTf.text! = ""
          interestRateTf.text! = ""
          noOfPaymentsTf.text! = ""
          paymentTf.text! = ""
      }
    
    //onclick calculate function
    @IBAction func onCalculate(_ sender: UIButton) {
        
    //check the validity of input
    if presentValueTf.text! == "" && futureValueTf.text! == "" &&
           interestRateTf.text! == "" && noOfPaymentsTf.text! == "" &&
        paymentTf.text! == "" {
            
            let alert = UIAlertController(title: "Warning", message: "Please enter values to calculate ", preferredStyle: .alert)
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
                } else if presentValueTf.text! != "" && futureValueTf.text! != "" &&
                      interestRateTf.text! != "" && noOfPaymentsTf.text! != ""
    && paymentTf.text! != ""{
                
                let alert = UIAlertController(title: "Warning", message: "Need one empty field.", preferredStyle: .alert)
                
                let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                }
                
                alert.addAction(success)
                self.present(alert, animated: true, completion:nil)
                
    //present value calcultion
    } else if presentValueTf.text! == "" && futureValueTf.text! != "" && interestRateTf.text! != "" && noOfPaymentsTf.text! != ""{
            
           let futureVal = Double(futureValueTf.text!)!
            let interestVal = Double(interestRateTf.text!)!
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            let interestDiv = interestVal/100
            
            //present value calculate  formula - P = A/(1+rn)nt
            let presentValueCalculateFormula = futureVal / pow(1 + (interestDiv / 12), 12 * noOfPaymentsVal)
            presentValueTf.text = String(format: "%.2f",presentValueCalculateFormula)
            
    //interst rate calculations
    } else if interestRateTf.text! == "" && presentValueTf.text! != "" && futureValueTf.text! != "" && noOfPaymentsTf.text! != ""  {
            
            let presentVal = Double(presentValueTf.text!)!
            let futureVal = Double(futureValueTf.text!)!
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            
            //interest rate calculate formula - r = n[(A/P)1/nt-1]
            let interestRateCalculateFormula = 12 * ( pow ( ( futureVal / presentVal ), 1 / ( 12 * noOfPaymentsVal ) ) - 1 )
            interestRateTf.text! = String(format: "%.2f",interestRateCalculateFormula*100)
            
    //number of payments calculations
    } else if noOfPaymentsTf.text! == "" && presentValueTf.text! != ""
        && futureValueTf.text! != "" && interestRateTf.text! != ""{
                
            let presentVal = Double(presentValueTf.text!)!
            let futureVal = Double(futureValueTf.text!)!
            let interestVal = Double(interestRateTf.text!)!
            
            let interestDiv = interestVal/100
            
            //number of payments calculation formula - t = log(A/P) /n [log(1+r/n)]
            let noOfPaymentsCalculateFormula = log (futureVal/presentVal) / (12*log(1+interestDiv/12))
            noOfPaymentsTf.text! = String(format: "%.2f",noOfPaymentsCalculateFormula)
        
    } else if futureValueTf.text! == "" && paymentTf.text! == "" {
        
         let alert = UIAlertController(title: "Warning", message: "Need Values to Calculate", preferredStyle: .alert)
               
               let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
               }
               alert.addAction(success)
               self.present(alert, animated: true, completion:nil)
        
    //future value calculations for regular
    } else if paymentTf.text! != "" && endBeginSwitch.isOn == true && presentValueTf.text! != "" && noOfPaymentsTf.text! != "" && interestRateTf.text! != "" {
        
        let presentVal = Double(presentValueTf.text!)!
        let interestVal = Double(interestRateTf.text!)!
        let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
        let paymentVal = Double(paymentTf.text!)!
        let compoundPerYearVal = 12.00
        let interestDiv = interestVal/100
        
        //regular calculations for end formula = P * pow( 1 + ( r / n ),n * t )
        let compoundInterestEndFormula = presentVal * pow( 1.00 + ( interestDiv / compoundPerYearVal ),compoundPerYearVal * noOfPaymentsVal )
        
        let futureValues = paymentVal * (  pow(( 1.00 + interestDiv / compoundPerYearVal  ), compoundPerYearVal * noOfPaymentsVal  ) - 1.00) /  ( interestDiv / compoundPerYearVal )
        
         let  total = compoundInterestEndFormula + futureValues
        
        futureValueTf.text! = String(format: "%.2f",total)
        
        
    } else if paymentTf.text! != "" && endBeginSwitch.isOn == false && presentValueTf.text! != "" && noOfPaymentsTf.text! != "" && interestRateTf.text! != ""{
        
        
         let presentVal = Double(presentValueTf.text!)!
         let interestVal = Double(interestRateTf.text!)!
         let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
         let paymentVal = Double(paymentTf.text!)!
         let compoundPerYearVal = 12.00
         let interestDiv = interestVal/100
         
         // regular calculations for begin formula = P * pow( 1 + ( r / n ),n * t )
         let compoundInterestBegin = presentVal * pow( 1.00 + ( interestDiv / compoundPerYearVal ),compoundPerYearVal * noOfPaymentsVal )
      
         let futureValues = paymentVal * (  pow(( 1.00 + interestDiv / compoundPerYearVal  ), compoundPerYearVal * noOfPaymentsVal  ) - 1.00) /  ( interestDiv / compoundPerYearVal ) *  (1 + interestDiv / compoundPerYearVal)
         
          let  total = compoundInterestBegin + futureValues
         
         futureValueTf.text! = String(format: "%.2f",total)
        
    } else if paymentTf.text! == "" && endBeginSwitch.isOn == true && presentValueTf.text! != "" && noOfPaymentsTf.text! != "" && interestRateTf.text! != "" {
        
        let alert = UIAlertController(title: "Warning", message: "Payment value calculate is not set.", preferredStyle: .alert)
        let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alert.addAction(success)
        self.present(alert, animated: true, completion:nil)
      
    // this if statment pass only payment box switch off
    } else if paymentTf.text! == "" && endBeginSwitch.isOn == false && presentValueTf.text! != "" && noOfPaymentsTf.text! != "" && interestRateTf.text! != "" {
        
        let alert = UIAlertController(title: "Warning", message: "Payment value calculation is not set.", preferredStyle: .alert)
        
        let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alert.addAction(success)
        self.present(alert, animated: true, completion:nil)
        
        } else {
        
        let alert = UIAlertController(title: "Warning", message: " Please enter values to calculate.", preferredStyle: .alert)
        let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
        }
        
        alert.addAction(success)
        self.present(alert, animated: true, completion:nil)
        
      }

    }
    
    //button onclick function for save data
    @IBAction func onSave(_ sender: UIButton){
          
        if presentValueTf.text! != "" && futureValueTf.text! != "" &&
        interestRateTf.text! != "" && noOfPaymentsTf.text! != ""
        && paymentTf.text! != "" {
        
          let defaultStand = UserDefaults.standard
            let saveDis = "Present Value \(presentValueTf.text!), Future Value \(futureValueTf.text!), Interest Rate \(interestRateTf.text!)%, No. of Payments  \(noOfPaymentsTf.text!), Payment   \(paymentTf.text!), END - \(endBeginSwitch.isOn)"
             
             savingValues.historyStringArray.append(saveDis)
             defaultStand.set(savingValues.historyStringArray, forKey: "SavingsHistory")
        
            let alert = UIAlertController(title: "Success Alert", message: " Saved ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
      
        }
    
        else if presentValueTf.text! == "" || futureValueTf.text! == "" ||
           interestRateTf.text! == "" || noOfPaymentsTf.text! == "" ||
        paymentTf.text! == "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        }
        else {
            
            let alert = UIAlertController(title: "Error Alert", message: "UnSuccessful Save", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
        }
        
         }
}
