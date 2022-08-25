//
//  MainTabController.swift
//  financial-calculator
//
//  Created by Mohamed Shazni on 2022-04-11.

//

import Foundation
import UIKit

class MainTabController : UITabBarController {
    
    @IBOutlet weak var userInterfaceTabBarItem: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //font size -- check it
        let fontAttribute = [NSAttributedString.Key.font:UIFont.systemFont(ofSize:14)]
        
        UITabBarItem.appearance().setTitleTextAttributes(fontAttribute, for: .normal)
        
    }
    
}
