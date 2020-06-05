//
//  SubscriptionVC.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 01/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit

class SubscriptionVC: UIViewController {

    @IBOutlet var btnPopularColl: [UIButton]!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.popVC()
    }
    @IBAction func btnContinueAction(_ sender: GradientButton) {
        moveToTabVC()
    }
    @IBAction func btnSkipAction(_ sender: UIButton) {
        moveToTabVC()
    }
    
    @IBAction func btnPopularAction(_ sender: UIButton) {
        btnPopularColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
    }
    
    func moveToTabVC(){
        let tabVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.TabbarScreen) as! TabbarViewController
        tabVC.isFromMatch = false
        self.pop(toLast: tabVC.classForCoder)
    }
}
