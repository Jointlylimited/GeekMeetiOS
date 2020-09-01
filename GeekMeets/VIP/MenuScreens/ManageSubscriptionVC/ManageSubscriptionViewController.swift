//
//  ManageSubscriptionViewController.swift
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
import StoreKit

protocol ManageSubscriptionProtocol: class {
    func getSubscriptionDetailsResponse(response : SubscriptionResponse)
    func getSubscriptionResponse(response : SubscriptionResponse)
    func getUpdateSubscriptionResponse(response : CommonResponse)
    func getUserProfileResponse(response : UserAuthResponseField)
}

class ManageSubscriptionViewController: UIViewController, ManageSubscriptionProtocol {
    //var interactor : ManageSubscriptionInteractorProtocol?
    var presenter : ManageSubscriptionPresentationProtocol?
    
    // MARK: Object lifecycle
    
    @IBOutlet var btnSubColl: [UIButton]!
    @IBOutlet var btnStackList: [UIButton]!
    @IBOutlet weak var btnValidDate: UIButton!
    @IBOutlet weak var bg_Image: UIImageView!
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet var btnViews: [UIView]!
    @IBOutlet weak var bgViewHeightConstant: NSLayoutConstraint!
    
    var productKey : String = ""
    var transactionInProgress = false
    var priceIn : String = "10$"
    var product : SKProduct?
    var subscriptionDetails : SubscriptionFields?
    var planDict : NSDictionary = [:]
    var isFromStory : Bool = false
    var postStoryDelegate : PostStoryDelegate!
    
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
        let interactor = ManageSubscriptionInteractor()
        let presenter = ManageSubscriptionPresenter()
        
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
        self.presenter?.callSubscriptionDetailsAPI()
    }
    
    func setTheme(){
        self.bg_Image.image = !self.isFromStory ? #imageLiteral(resourceName: "Manage Subscription_bg1") : #imageLiteral(resourceName: "Subscription_bg")
        self.btnSkip.alpha = self.isFromStory ? 1.0 : 0.0
        self.bgViewHeightConstant.constant = DeviceType.hasNotch || DeviceType.iPhone11 || DeviceType.iPhone11or11Pro ? 230 : 180
       /* for btn in btnStackList {
            btn.titleLabel?.font = DeviceType.iPhone5orSE ? UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: 12.0) : UIFont(name: FontTypePoppins.Poppins_Medium.rawValue, size: 16.0)
        }*/
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    public func GetNextDayCurrentTimeStamp() -> String {
        let df = DateFormatter()
        let date = Date()
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date)
        df.dateFormat = "yyyyMMddhhmmss"
        let NewDate = df.string(from: nextDate!)
        return NewDate.replacingOccurrences(of: ":", with: "")
    }
    
    @IBAction func btnContinueAction(_ sender: UIButton) {
//        doSubscription(key : productKey)
        if self.subscriptionDetails != nil {
            let value = self.subscriptionDetails?.tiIsPurchased
            if value == nil || value == 0 {
                var endDateStr : String = ""
                if planDict.count != 0 {
                    if planDict["tiType"] as! String == "2" {
                        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
                        endDateStr = "\(endDate!.currentTimeMillis()/1000)"
                    } else {
                        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
                        endDateStr = "\(endDate!.currentTimeMillis()/1000)"
                    }
                } else {
                    let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                    endDateStr = "\(endDate!.currentTimeMillis()/1000)"
                }
                let param = RequestParameter.sharedInstance().createSubscriptionParams(vTransactionId: "1214665932543", tiType: planDict["tiType"] as! String, fPrice: planDict["fPrice"] as! String, vReceiptData: "13ncksncocwbwibck", iStartDate: "\(Date().currentTimeMillis()/1000)", iEndDate: endDateStr)
                self.presenter?.callCreateSubscriptionAPI(param: param)
            } else {
                if UserDataModel.currentUser?.tiIsSubscribed == 0 {
                    let param = RequestParameter.sharedInstance().updateSubscriptionParams(iSubscriptionId: "\(self.subscriptionDetails!.iSubscriptionId!)", iEndDate: "\(self.subscriptionDetails!.iEndDate!)", isExpire: "1")
                    self.presenter?.callUpdateSubscriptionAPI(param: param)
                } else {
                    AppSingleton.sharedInstance().showAlert("You have already subscribed!", okTitle: "OK")
                }
            }
        }else {
            var endDateStr : String = ""
            if planDict.count != 0 {
                if planDict["tiType"] as! String == "2" {
                    let endDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())
                    endDateStr = "\(endDate!.currentTimeMillis()/1000)"
                } else {
                    let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
                    endDateStr = "\(endDate!.currentTimeMillis()/1000)"
                }
            } else {
                let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
                endDateStr = "\(endDate!.currentTimeMillis()/1000)"
            }
            let param = RequestParameter.sharedInstance().createSubscriptionParams(vTransactionId: "1214665932543", tiType: planDict["tiType"] as! String, fPrice: planDict["fPrice"] as! String, vReceiptData: "13ncksncocwbwibck", iStartDate: "\(Date().currentTimeMillis()/1000)", iEndDate: endDateStr)
            if planDict != [:] {
                self.presenter?.callCreateSubscriptionAPI(param: param)
            } else {
                AppSingleton.sharedInstance().showAlert("Please select plan", okTitle: "OK")
            }
        }
    }
    
    @IBAction func btnSubscriptionAction(_ sender: UIButton) {
        btnSubColl.forEach{
            $0.isSelected = false
        }
        sender.isSelected = true
        resetButtonView()
        btnViews[sender.tag].backgroundColor = .lightGray
        
        if sender.tag == 0 {
            productKey = SubscriptionKeys.Monthly.productKey
            planDict = ["productKey" : SubscriptionKeys.Monthly.productKey, "tiType": "2", "fPrice" : "9.99"]
        } else {
            productKey = SubscriptionKeys.Annualy.productKey
            planDict = ["productKey" : SubscriptionKeys.Monthly.productKey, "tiType": "3", "fPrice" : "89.99"]
        }
    }
    @IBAction func btnSkipAndContinueAction(_ sender: UIButton) {
        dismissVC {
            self.postStoryDelegate.getSubscriptionResponse(status: false)
        }
    }
    
    func resetButtonView(){
        btnViews.forEach {
            $0.backgroundColor = .white
        }
    }
}

extension ManageSubscriptionViewController {
    func doSubscription(key : String){
        if SKPaymentQueue.canMakePayments() {
            let productRequest = SKProductsRequest(productIdentifiers: [key])
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            print("Cannot perform In App Purchases.")
        }
    }
    
    func getSubscriptionDetailsResponse(response : SubscriptionResponse){
        if response.responseCode == 200 {
            self.subscriptionDetails = response.responseData
            if response.responseData?.iEndDate != nil {
                let timeStamp = Date(timeIntervalSince1970: Double(response.responseData!.iEndDate!)!)
                let dateString = timeStamp.formattedDateString(format: "dd MMM, yyyy")
                self.btnValidDate.setTitle("Valid till \(dateString)", for: .normal)
                let type = ((response.responseData?.tiType)! != 0 && (response.responseData?.tiType)! != 1) ? (response.responseData?.tiType)! - 2 : (response.responseData?.tiType)!
                btnViews[type].backgroundColor = .lightGray
            } else {
                self.btnValidDate.setTitle("No data available", for: .normal)
            }
        }
        self.presenter?.callUserProfileAPI()
        setTheme()
    }
    
    func getSubscriptionResponse(response : SubscriptionResponse){
        print(response)
        if response.responseCode == 200 {
            resetButtonView()
            AppSingleton.sharedInstance().showAlert(kSuccessPurSubscriptionPlan, okTitle: "OK")
            self.subscriptionDetails = response.responseData
            UserDataModel.currentUser?.tiIsSubscribed = 1
            if response.responseData?.iEndDate != nil {
                let timeStamp = Date(timeIntervalSince1970: Double(response.responseData!.iEndDate!)!)
                let dateString = timeStamp.formattedDateString(format: "dd MMM, yyyy")
                self.btnValidDate.setTitle("Valid till \(dateString)", for: .normal)
            }
            
            if self.isFromStory {
                dismissVC {
                    self.postStoryDelegate.getSubscriptionResponse(status: true)
                }
            }
        }
    }
    
    func getUpdateSubscriptionResponse(response : CommonResponse){
        if response.responseCode == 200 {
            resetButtonView()
            self.presenter?.callSubscriptionDetailsAPI()
        }
    }
    
    func getUserProfileResponse(response : UserAuthResponseField){
        UserDataModel.currentUser = response
    }
}

extension ManageSubscriptionViewController : SKProductsRequestDelegate, SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        if let transaction = transactions.first {
            switch transaction.transactionState {
                
            case .purchasing:
                print("Purchasing....")
            
            case .purchased:
                print("Transaction completed successfully.")
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                AppSingleton.sharedInstance().isSubscription = true
                LoaderView.sharedInstance.hideLoader()
                // self.goAhead()
            case .failed:
                print("Transaction Failed");
                LoaderView.sharedInstance.hideLoader()
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                AppSingleton.sharedInstance().isSubscription = true
        
            case .restored:
                print("Restored ... ")
            case .deferred:
                LoaderView.sharedInstance.hideLoader()
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count != 0 {
            guard let prod = response.products.first else { LoaderView.sharedInstance.showLoader(); return}
            self.product = prod
            
            let currencyFormatter = NumberFormatter()
            currencyFormatter.locale = prod.priceLocale
            currencyFormatter.maximumFractionDigits = 2
            currencyFormatter.minimumFractionDigits = 2
            currencyFormatter.alwaysShowsDecimalSeparator = true
            currencyFormatter.numberStyle = .currency
            let someAmount = prod.price
            let price: String? = currencyFormatter.string(from: someAmount as NSNumber)

            let formattedPrice = price!
            self.priceIn = formattedPrice
        }
        else {
            print("There are no products.")
            LoaderView.sharedInstance.hideLoader()
            request.cancel()
        }
    }
}
