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
    func getGeeksPlansResponse(response : BoostGeekResponse)
    func getGeeksResponse(response : BoostGeekResponse)
    func getActiveGeeksResponse(response : BoostGeekResponse)
    
}

class TopGeeksViewController: UIViewController, TopGeeksProtocol {
    //var interactor : TopGeeksInteractorProtocol?
    var presenter : TopGeeksPresentationProtocol?
    
    @IBOutlet var btnTopGeekColl: [UIButton]!
    @IBOutlet weak var btnActivePlans: UIButton!
    @IBOutlet weak var lblRemainingTime: UILabel!
    @IBOutlet weak var btnActiveNow: UIButton!
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
        self.bgViewHeightConstant.constant = DeviceType.hasNotch || DeviceType.iPhone11 || DeviceType.iPhone11or11Pro ? 230 : 180
        self.presenter?.callGeeksPlansAPI()
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
        if planDict != [:] {
            self.callCreateGeeksAPI()
        } else {
            AppSingleton.sharedInstance().showAlert("Please select plan", okTitle: "OK")
        }
    }
    
    @IBAction func btnActiveNowAction(_ sender: UIButton) {
        self.callActiveGeeksAPI()
    }
    
    @IBAction func btnTopGeekAction(_ sender: UIButton) {
        btnTopGeekColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        resetButtonView()
        btnViews[sender.tag].backgroundColor = .lightGray
        
        if sender.tag == 0 {
            planDict = ["fPlanPrice" : "1.99", "tiPlanType": "2", "iBoostCount" : "0", "iGeekCount" : "1"]
        } else if sender.tag == 1 {
            planDict = ["fPlanPrice" : "6.99", "tiPlanType": "2", "iBoostCount" : "0", "iGeekCount" : "4"]
        } else if sender.tag == 2 {
            planDict = ["fPlanPrice" : "9.99", "tiPlanType": "2", "iBoostCount" : "0", "iGeekCount" : "8"]
        } else {
            planDict = ["fPlanPrice" : "14.99", "tiPlanType": "3", "iBoostCount" : "10", "iGeekCount" : "10"]
        }
    }
    
    func startTimer() {
      timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
      print("Timer : \(totalMin):\(totalSecond)")
      if totalSecond != 0 || totalMin != 0 {
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
        if dateStr1.compare(dateStr2) == .orderedDescending  {
            startTimer()
        } else {
            //         viewTimer.isHidden = true
            //         viewMeeting.isHidden = false
        }
    }
    
    func setActiveNowButton(data : BoostGeekFields){
        if data.pendingGeek != 0 && data.iExpireAt == "" {
            self.btnActiveNow.alpha = 1.0
            self.btnActiveNow.isUserInteractionEnabled = true
        } else {
            self.btnActiveNow.alpha = 0.5
            self.btnActiveNow.isUserInteractionEnabled = false
            if data.iExpireAt != "" {
                setPlansDetails(date: (data.iExpireAt)!)
            }
        }
    }
}

extension TopGeeksViewController {
    
    func getGeeksPlansResponse(response : BoostGeekResponse){
        print(response)
        if response.responseCode == 200 {
            self.btnActivePlans.setTitle("\(response.responseData?.pendingGeek ?? 0)", for: .normal)
            if response.responseData?.tiPlanType == 2 || response.responseData?.tiPlanType == 3 {
                setActiveNowButton(data : response.responseData!)
            }
        }
    }
    
    func callCreateGeeksAPI() {
        let param = RequestParameter.sharedInstance().createBoostGeekParams(fPlanPrice: planDict["fPlanPrice"] as! String, tiPlanType: planDict["tiPlanType"] as! String, iBoostCount: planDict["iBoostCount"] as! String, iGeekCount: planDict["iGeekCount"] as! String)
        self.presenter?.callCreateGeeksAPI(param: param)
    }
    
    func getGeeksResponse(response : BoostGeekResponse){
        if response.responseCode == 200 {
            resetButtonView()
            AppSingleton.sharedInstance().showAlert(kSuccessPurStoryPlan, okTitle: "OK")
            self.presenter?.callGeeksPlansAPI()
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
    
    func callActiveGeeksAPI(){
        self.presenter?.callActiveGeeksAPI()
    }
    
    func getActiveGeeksResponse(response : BoostGeekResponse){
        print(response)
        if response.responseCode == 200 {
            resetButtonView()
            self.presenter?.callGeeksPlansAPI()
        } else {
            AppSingleton.sharedInstance().showAlert(response.responseMessage!, okTitle: "OK")
        }
    }
}


