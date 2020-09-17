//
//  BoostViewController.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 22/04/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol BoostProtocol: class {
    func getBoostPlansResponse(response : BoostGeekResponse)
    func getBoostResponse(response : BoostGeekResponse)
    func getActiveBoostResponse(response : BoostGeekResponse)
}

class BoostViewController: UIViewController, BoostProtocol {
    //var interactor : BoostInteractorProtocol?
    var presenter : BoostPresentationProtocol?
    
    @IBOutlet var btnBoostColl: [UIButton]!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnActiveBoostPlans: UIButton!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var btnBoostNow: UIButton!
    @IBOutlet var btnViews: [UIView]!
    @IBOutlet weak var bgViewHeightConstant: NSLayoutConstraint!
    
    var planDict : NSDictionary = [:]
    var timer = Timer()
    var totalDay : Int!
    var totalHour : Int!
    var totalMin : Int!
    var totalSecond : Int!
    
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
        let interactor = BoostInteractor()
        let presenter = BoostPresenter()
        
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
        self.bgViewHeightConstant.constant = DeviceType.hasNotch || DeviceType.iPhone11 || DeviceType.iPhone11or11Pro ? 230 : 180
        self.presenter?.callBoostPlansAPI()
    }

    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        if planDict != [:] {
            self.callCreateBoostAPI()
        } else {
            AppSingleton.sharedInstance().showAlert("Please select plan", okTitle: "OK")
        }
    }
    
    @IBAction func btnBoostNowAction(_ sender: UIButton) {
        self.callActiveBoostAPI()
    }
    
    @IBAction func btnBoostAction(_ sender: UIButton) {
        
        btnBoostColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        resetButtonView()
        btnViews[sender.tag].backgroundColor = .lightGray
        
        if sender.tag == 0 {
            planDict = ["fPlanPrice" : "1.99", "tiPlanType": "1", "iBoostGeekCount" : "1", "iGeekCount" : "0"]
        } else if sender.tag == 1 {
            planDict = ["fPlanPrice" : "3.99",  "tiPlanType": "1", "iBoostGeekCount" : "5", "iGeekCount" : "0"]
        } else if sender.tag == 2 {
            planDict = ["fPlanPrice" : "6.99", "tiPlanType": "1", "iBoostGeekCount" : "8", "iGeekCount" : "0"]
        } else {
            planDict = ["fPlanPrice" : "14.99", "tiPlanType": "3", "iBoostGeekCount" : "10", "iGeekCount" : "10"]
        }
    }
    
    func startTimer() {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
      
      if totalSecond != nil || totalMin != nil {
        if totalSecond != 0 {
          totalSecond -= 1
        }
        
        if "\(totalSecond!)".firstCharacterAsString == "0" {
         totalSecond = 60
          totalMin -= 1
        }

        if "\(totalMin!)".firstCharacterAsString == "0" {
         // totalMin = 60
          totalHour -= 1
        }
        self.lblRemainingTime.text = "\(totalMin!):\(totalSecond!) Remaining"
        
        if totalMin! == 0 && totalSecond! == 0 {
            totalMin = 0
            totalSecond = 0
          endTimer()
          self.lblRemainingTime.text = "\(00):\(00) Remaining"
        }
      } else {
        endTimer()
        self.lblRemainingTime.text = "\(00):\(00) Remaining"
      }
    }
    
    func endTimer() {
      timer.invalidate()
    }
    
    func resetButtonView(){
        btnViews.forEach {
            $0.backgroundColor = .white
        }
    }
    
    func setPlansDetails(date : String){
        let Dateformatter = DateFormatter()
        Dateformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myTimeInterval = TimeInterval(Int((date))!)
        let date1 = Date(timeIntervalSince1970: TimeInterval(myTimeInterval))
        
        let dateStr1 = Dateformatter.string(from: date1)
        let dateStr2 = Dateformatter.string(from: Date())
        
        if dateStr1 != "" {
            (totalHour, totalMin, totalSecond) = timeGapBetweenDates(previousDate: dateStr1, currentDate: dateStr2)
        }
        if dateStr1.compare(dateStr2) == .orderedDescending {
            startTimer()
        } else {
        }
    }
    
    func setBoostNowButton(data : BoostGeekFields){
        if data.pendingBoost != 0 && data.iExpireAt == "" {
            self.btnBoostNow.alpha = 1.0
            self.btnBoostNow.isUserInteractionEnabled = true
        } else {
            self.btnBoostNow.alpha = 0.5
            self.btnBoostNow.isUserInteractionEnabled = false
            if data.iExpireAt != "" {
                setPlansDetails(date: (data.iExpireAt)!)
            }
        }
    }
}

extension BoostViewController {
    func getBoostPlansResponse(response : BoostGeekResponse){
        print(response)
        if response.responseCode == 200 {
            self.btnActiveBoostPlans.setTitle("\(response.responseData?.pendingBoost ?? 0)", for: .normal)
            if response.responseData?.tiPlanType == 1 || response.responseData?.tiPlanType == 3 {
                setBoostNowButton(data : response.responseData!)
            }
        }
    }
    
    func callCreateBoostAPI() {
        let param = RequestParameter.sharedInstance().createBoostGeekParams(fPlanPrice: planDict["fPlanPrice"] as! String, tiPlanType: planDict["tiPlanType"] as! String, iBoostCount: planDict["iBoostGeekCount"] as! String, iGeekCount: planDict["iGeekCount"] as! String)
        self.presenter?.callCreateBoostAPI(param : param)
    }
    
    func getBoostResponse(response : BoostGeekResponse){
        if response.responseCode == 200 {
            resetButtonView()
            AppSingleton.sharedInstance().showAlert(kSuccessPurBoostPlan, okTitle: "OK")
            self.presenter?.callBoostPlansAPI()
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func callActiveBoostAPI(){
        self.presenter?.callActiveBoostAPI()
    }
    
    func getActiveBoostResponse(response : BoostGeekResponse){
        print(response)
        if response.responseCode == 200 {
            resetButtonView()
            self.presenter?.callBoostPlansAPI()
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}
