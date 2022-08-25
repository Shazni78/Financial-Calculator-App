//
//  CompoundInterestViewController.swift
//  financial-calculator
//
//  Created by Mohamed Shazni on 2022-04-11.
//

//   Formula Attribute Naming
//
//   P = present/principal/amount value
//   F = future value
//   r = interest rate
//   t = (time) number of payments
//   n = compound per year
//   PMT = payment


import Foundation
import UIKit

class CompoundInterestController : UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var noOfPaymentsTf: UITextField!
    @IBOutlet weak var keyboardView: Keyboard!
    @IBOutlet weak var presentValueTf: UITextField!
    @IBOutlet weak var futureValueTf: UITextField!
    @IBOutlet weak var interestRateTf: UITextField!
  
    
    var compoundInterestRate : CompoundInterest = CompoundInterest(presentValue: 0.0, futureValue: 0.0, interestRate: 0.0,  noOfPayments: 0.0)
    
    override func viewDidLoad() {
          super.viewDidLoad()
          self.assignDelegates()
          self.loadDefaultsData("CompoundInterestHistory")
          self.loadInputWhenAppOpen()
      }
      
      //load data to array
      func loadDefaultsData(_ historyKey :String) {
          let defaults = UserDefaults.standard
          compoundInterestRate.historyStringArray = defaults.object(forKey: historyKey) as? [String] ?? [String]()
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
      }
    
    //save the data to relevant key
    @IBAction func editPresentSaveDefault(_ sender: UITextField) {
        
        let dfValue = UserDefaults.standard
        dfValue.set(presentValueTf.text, forKey:"compound_present")
    }
    
    @IBAction func editFutureSaveDefault(_ sender: UITextField) {
        
        let dfValue = UserDefaults.standard
        dfValue.set(futureValueTf.text, forKey:"compound_future")
    }
    
    @IBAction func editInterestRateSaveDefault(_ sender: UITextField) {
        
        let dfValue = UserDefaults.standard
        dfValue.set(interestRateTf.text, forKey:"compound_interest")
    }
    
    @IBAction func editNoOfPaymentsSaveDefault(_ sender: UITextField) {
        
        let dfValue = UserDefaults.standard
        dfValue.set(noOfPaymentsTf.text, forKey:"compound_noOfPayment")
    }

      //loading data
      func loadInputWhenAppOpen(){
          let dfValue =  UserDefaults.standard
          let dfPresent = dfValue.string(forKey:"compound_present")
          let dfInterestRate = dfValue.string(forKey:"compound_interest")
          let dfNoOfPayments = dfValue.string(forKey:"compound_noOfPayment")
          let dfFuture = dfValue.string(forKey:"compound_future")
          
          presentValueTf.text = dfPresent
          futureValueTf.text = dfFuture
          interestRateTf.text = dfInterestRate
          noOfPaymentsTf.text = dfNoOfPayments
          
      }
    
      func textFieldDidBeginEditing(_ textField: UITextField) {
          keyboardView.activeTextField = textField
      }
      
    //clear function for text fields
    @IBAction func onClear(_ sender: UIButton) {
          
          presentValueTf.text = ""
          futureValueTf.text = ""
          interestRateTf.text = ""
          noOfPaymentsTf.text = ""
      }
   
    
    //button onclick calculate formula
    @IBAction func onCalculate(_ sender: UIButton) {
          
        //condition checking for filled or not filled
        if presentValueTf.text! == "" && futureValueTf.text! == "" &&
           interestRateTf.text! == "" && noOfPaymentsTf.text! == "" {
            
            let alert = UIAlertController(title: "Alert", message: "Please enter values to calculate ", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
            } else if presentValueTf.text! != "" && futureValueTf.text! != "" &&
                  interestRateTf.text! != "" && noOfPaymentsTf.text! != "" {
            
            let alert = UIAlertController(title: "Warning", message: "Need one empty field.", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        //calculate the present value
        } else if presentValueTf.text! == "" && futureValueTf.text! != "" && interestRateTf.text! != "" && noOfPaymentsTf.text! != ""{
            
            let futureVal = Double(futureValueTf.text!)!
            let interestVal = Double(interestRateTf.text!)!
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            let interestDiv = interestVal/100
            
            //present value calculate formula - P =  A/(1+rn)nt
            let presentValueCalculateFormula = futureVal / pow(1 + (interestDiv / 12), 12 * noOfPaymentsVal)
            
            presentValueTf.text = String(format: "%.2f",presentValueCalculateFormula)
            
        //future value caluclations
        } else if futureValueTf.text! == "" && presentValueTf.text! != "" && interestRateTf.text! != "" && noOfPaymentsTf.text! != "" {
            
            let presentVal = Double(presentValueTf.text!)!
            let interestVal = Double(interestRateTf.text!)!
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            let interestDiv = interestVal/100
            
            //future value calculate formula - A = P(1+(r/n)nt)
            let futureValueCalculateFormula = presentVal * pow (1 + (interestDiv / 12 ), 12 * noOfPaymentsVal )
            //paymet decimal calculations formula= Double(round(100*payment)/100)
            futureValueTf.text = String(format: "%.2f",futureValueCalculateFormula)
            
        //interest rate calculations
        } else if interestRateTf.text! == "" && presentValueTf.text! != ""
        && futureValueTf.text! != "" && noOfPaymentsTf.text! != "" {
            
            let presentVal = Double(presentValueTf.text!)!
            let futureVal = Double(futureValueTf.text!)!
            let noOfPaymentsVal = Double(noOfPaymentsTf.text!)!
            //interest rate calculations formula - r = n[(A/P)1/nt-1]
            let interestRateCalculateFormula = 12 * ( pow ( ( futureVal / presentVal ), 1 / ( 12 * noOfPaymentsVal ) ) - 1 )
            
            interestRateTf.text = String(format: "%.2f",interestRateCalculateFormula * 100)
            
        //number of paymets calculations
        } else if noOfPaymentsTf.text! == "" && presentValueTf.text! != "" && futureValueTf.text! != "" && interestRateTf.text! != "" {
            
            let presentVal = Double(presentValueTf.text!)!
            let futureVal = Double(futureValueTf.text!)!
            let interestVal = Double(interestRateTf.text!)!
            let interestDiv = interestVal/100
            //number of payments calculations formula - t = log(A/P) /n [log(1+r/n)]
            let noOfPaymentsCalculateFormula = log (futureVal/presentVal) / (12*log(1+interestDiv/12))
            
             noOfPaymentsTf.text = String(format: "%.2f",noOfPaymentsCalculateFormula)
           
        } else {
            
            let alert = UIAlertController(title: "Warning", message: "Please enter values to calculate ", preferredStyle: .alert)
    
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
    }
    
    alert.addAction(success)
    self.present(alert, animated: true, completion:nil)
        }          
              
      }
  
    //onclick button save data
    @IBAction func onSave(_ sender: UIButton){
          
        if presentValueTf.text! != "" && futureValueTf.text! != "" &&
        interestRateTf.text! != "" && noOfPaymentsTf.text! != "" {
            
          let defaultStand = UserDefaults.standard
            //save data diplay
        let saveDisp = "Present Value  \(presentValueTf.text!), Future Value \(futureValueTf.text!), Interest Rate \(interestRateTf.text!)%,  No.of Payment \(noOfPaymentsTf.text!)"
             
             compoundInterestRate.historyStringArray.append(saveDisp)
             defaultStand.set(compoundInterestRate.historyStringArray, forKey: "CompoundInterestHistory")
        
            let alert = UIAlertController(title: "Success Alert", message: "Successfully Saved.", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                
            }
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
            
        } else if presentValueTf.text! == "" || futureValueTf.text! == "" ||
        interestRateTf.text! == "" || noOfPaymentsTf.text! == "" {
            
            let alert = UIAlertController(title: "Warning Alert", message: "One or More Input are Empty", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        } else {
            
            let alert = UIAlertController(title: "Error Alert", message: "Please do calculate. Save Unsuccessful", preferredStyle: .alert)
            
            let success = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            
            alert.addAction(success)
            self.present(alert, animated: true, completion:nil)
            
        }
        
         }
}
