//
//  HistoryViewController.swift
//  financial-calculator
//
//  Created by Mohamed Shazni on 2022-04-11.
//

import Foundation
import UIKit

class HistoryViewController: UITableViewController {
    

    var history : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initHistoryInfo()
    }
    
    //history data load function
    func initHistoryInfo() {
        if let viewControllerSave = self.navigationController?.viewControllers {
            let lastViewController = viewControllerSave[viewControllerSave.count - 2]
            
            if lastViewController is MortgageViewController {
                loadDefaultsData("MortgageHistory")
            }
            
            if lastViewController is CompoundInterestController {
                loadDefaultsData("CompoundInterestHistory")
            }
            
            if lastViewController is SavingsController {
                loadDefaultsData("SavingsHistory")
            }
        
            if lastViewController is LoanController {
                loadDefaultsData("LoanHistory")
            }
        }
    }
    
    
    func loadDefaultsData(_ historyKey :String) {
        let defaultsStand = UserDefaults.standard
        history = defaultsStand.object(forKey: historyKey) as? [String] ?? [String]()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellTab = tableView.dequeueReusableCell(withIdentifier: "reusableHistoryCell")!
        cellTab.textLabel?.textAlignment = .center
        cellTab.textLabel?.numberOfLines = 0
        cellTab.textLabel?.text = history[indexPath.row]
        return cellTab
    }
    
    }
