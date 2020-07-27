//
//  TopGeeksViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 23/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol TopGeeksProtocol: class {
    func getGeeksResponse(response : BoostGeekResponse)
    func getActiveGeeksResponse(response : BoostGeekResponse)
}

class TopGeeksViewController: UIViewController, TopGeeksProtocol {
    //var interactor : TopGeeksInteractorProtocol?
    var presenter : TopGeeksPresentationProtocol?
    
    @IBOutlet var btnTopGeekColl: [UIButton]!
    var planDict : NSDictionary = [:]
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = TopGeeksInteractor()
        let presenter = TopGeeksPresenter()
        
        //View Controller will communicate with only presenter
        viewController.presenter = presenter
        //viewController.interactor = interactor
        
        //Presenter will communicate with Interector and Viewcontroller
        presenter.viewController = viewController
        presenter.interactor = interactor
        
        //Interactor will communucate with only presenter.
        interactor.presenter = presenter
    }
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
//        self.callCreateGeeksAPI()
    }
    
    @IBAction func btnActiveNowAction(_ sender: UIButton) {
        
    }
    
    @IBAction func btnTopGeekAction(_ sender: UIButton) {
        btnTopGeekColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        
        if sender.tag == 0 {
            planDict = ["fPlanPrice" : "10", "iBoostGeekCount" : "10"]
        } else {
            planDict = ["fPlanPrice" : "18", "iBoostGeekCount" : "20"]
        }
    }
}

extension TopGeeksViewController {
    func callCreateGeeksAPI() {
        
        let param = RequestParameter.sharedInstance().createBoostGeekParams(fPlanPrice: planDict["fPlanPrice"] as! String, iBoostGeekCount: planDict["iBoostGeekCount"] as! String)
        self.presenter?.callCreateGeeksAPI(param: param)
    }
    
    func getGeeksResponse(response : BoostGeekResponse){
        AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
    }
    func callActiveBoostAPI(){
        self.presenter?.callActiveBoostAPI()
    }
    
    func getActiveGeeksResponse(response : BoostGeekResponse){
        print(response)
    }
}
