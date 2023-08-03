

import Foundation
import StoreKit
import SwiftyStoreKit

typealias BlockCompletion = (() -> Void)
typealias BlockCompletionResult = ((SubscriptionResult) -> Void)

//MARK:- Enum
extension Constant {
    static let sharedSecretKey = "da8c857160b646a7b942556aad21a8f1"
    static let weeklyProductId = ""
    static let monthlyProductId = "com.jointly.monthlysubscription"
    static let yearlyProductId = "com.jointly.yearlysubscription"
    static let quarterlyProductId = ""
    static let allProductIds: [String] = [monthlyProductId, yearlyProductId]
    static let allActiveProdictIds: [String] = [monthlyProductId, yearlyProductId]
}

enum SubscriptionPlan: String {
    case weekly
    case montly
    case yearly
    case quarterly

    static let allPlans: [SubscriptionPlan] = [.montly, .yearly]
    static let allPlansIDs: [String] = allPlans.map({$0.productId})

    
    var productId: String {
        switch self {
        case .weekly:
            return Constant.weeklyProductId
        case .montly:
            return Constant.monthlyProductId
        case .yearly:
            return Constant.yearlyProductId
          case .quarterly:
            return Constant.quarterlyProductId
        }
    }
    
    var price:String {
        let key = self.productId.appending("_price")
        if let savedPrice = UserDefaults.standard.string(forKey: key){
            return savedPrice
        }
        switch self {
        case .weekly:
            return "$0.0"
        case .montly:
            return "$0.0"
        case .yearly:
            return "$0.0"
        case .quarterly:
            return "$0.0"
        }
    }
    
    var duration:String {
        if self == .quarterly {return "Quarterly"}
        
        let key = self.productId.appending("_duration")
        if let savedPrice = UserDefaults.standard.string(forKey: key){
            return savedPrice
        }
        
        switch self {
        case .weekly:
            return "Week"
        case .montly:
            return "Month"
        case .yearly:
            return "Year"
        case .quarterly:
            return "Quarterly"
        }
    }
    
    var trialPeriod: String {
        let key = self.productId.appending("_trial")
        if let savedPrice = UserDefaults.standard.string(forKey: key){
            return savedPrice
        }
        
        switch self {
        case .weekly:
            return ""
        case .montly:
            return ""
        case .yearly:
            return ""
        case .quarterly:
            return ""
        }
    }
    
    init?(from productID: String) {
        if productID == Constant.weeklyProductId {
            self = .weekly
        } else if productID == Constant.monthlyProductId {
            self = .montly
        } else if productID == Constant.yearlyProductId {
            self = .yearly
        }else if productID == Constant.quarterlyProductId {
            self = .quarterly
        } else {
            return nil
        }
    }
}

enum SubscriptionResult {
    case purchased(validDate: Date?, product: String)
    case expired(date: Date?, product: String)
    case notPurchased
    case error(error: Error?)
}

//MARK:- SubscriptionManager
class SubscriptionManager: NSObject {
    static let shared = SubscriptionManager()
    var allProductIDs:[String] = SubscriptionPlan.allPlansIDs
    
    func isPlanActive(_ plan:String) -> Bool {
        return UserDefaults.standard.bool(forKey: plan)
    }
    
    func getEncriptReceiptData() -> Data? {
        return SwiftyStoreKit.localReceiptData
    }
    
    func getDecriptReceiptDataString() -> String? {
        let receiptData = SwiftyStoreKit.localReceiptData
        return receiptData?.base64EncodedString(options: [])
    }
    
    func completeTransactions() {
        catchProduct()
        
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                // Unlock content
                case .failed, .purchasing, .deferred:
                break // do nothing
                @unknown default: break
                }
            }
        }
    }
    
    func getProductPrice(productId: String) -> String? {
        if let plan = SubscriptionPlan(from: productId) {
            return plan.price
        }
        
        let key = productId.appending("_price")
        if let savedPrice = UserDefaults.standard.string(forKey: key){
            return savedPrice
        }
        return nil
    }
    
    func getProductDuration(productId: String) -> String? {
        if let plan = SubscriptionPlan(from: productId) {
            return plan.duration
        }
        
        let key = productId.appending("_duration")
        if let savedDuration = UserDefaults.standard.string(forKey: key){
            return "/" + savedDuration
        }
        return nil
    }
    
    func getProductTrialPeriod(productId: String) -> String? {
        if let plan = SubscriptionPlan(from: productId) {
            return plan.trialPeriod
        }
        
        let key = productId.appending("_trial")
        if let savedDuration = UserDefaults.standard.string(forKey: key){
            return savedDuration
        }
        return nil
    }
    
    func catchProduct() {
        checkRemoteProductId()
        
        SwiftyStoreKit.retrieveProductsInfo(Set.init(allProductIDs)) { (result) in
            for product in result.retrievedProducts{
                if let priceLocal = product.localizedPrice {
                    let keyPrice = product.productIdentifier.appending("_price")
                    UserDefaults.standard.set(priceLocal, forKey: keyPrice)
                    UserDefaults.standard.synchronize()
                }
                
                if #available(iOS 11.2, *), let period = product.subscriptionPeriod {
                    let duration = localizedPeriod(period: period)
                    let keyDuration = product.productIdentifier.appending("_duration")
                    UserDefaults.standard.set(duration, forKey: keyDuration)
                    UserDefaults.standard.synchronize()
                }
                
                if #available(iOS 11.2, *),
                   let period = product.introductoryPrice?.subscriptionPeriod {
                    let trialPeriodDesc = period.unit.description(capitalizeFirstLetter: true, numberOfUnits: period.numberOfUnits)
                    let keyDuration = product.productIdentifier.appending("_trial")
                    UserDefaults.standard.set(trialPeriodDesc, forKey: keyDuration)
                    UserDefaults.standard.synchronize()
                }
            }
        }
        
        @available(iOS 11.2, *)
        func localizedPeriod(period: SKProductSubscriptionPeriod) -> String {
            switch period.unit {
            case .day:  return "Week"
            case .week: return "Week"
            case .month: return "Month"
            case .year: return "Year"
            @unknown default:
                return ""
            }
        }
    }
    
    func checkRemoteProductId() {
        let remoteActiveProductIDs = Constant.allProductIds
        if remoteActiveProductIDs.count > 0 {
            allProductIDs.append(contentsOf: remoteActiveProductIDs)
            allProductIDs.unique()
        }
    }
    
    func buy(_ plan:String, completion: BlockCompletionResult? = nil) {
        SwiftyStoreKit.purchaseProduct(plan) { [unowned self] (purchaseResult) in
            if case .success(let purchase) = purchaseResult {
                SwiftyStoreKit.finishTransaction(purchase.transaction)
                self.validateSubscriptionStatus(completion: completion)
                
            }else if case .error(let error) = purchaseResult{
                completion?(.error(error: nil))
            }
        }
    }
    
    func restore(completion: BlockCompletionResult? = nil) {
        SwiftyStoreKit.restorePurchases { [unowned self] (restoreResult) in
            if restoreResult.restoredPurchases.count > 0 {
                self.validateSubscriptionStatus(completion: completion)
                
            }else if restoreResult.restoreFailedPurchases.count > 0{
                completion?(.error(error: nil))
            } else {
                completion?(.error(error: nil))
            }
        }
    }
    
    func validateSubscriptionStatus(completion: BlockCompletionResult? = nil) {
        var isExpired = false
        var isPurchased = false
        var latestExpiryDate: Date? = nil
        var latestExpiryProductId: String = ""
        
        let appleValidator = AppleReceiptValidator(service: AppDelObj.isDeveloperMode ? .sandbox : .production, sharedSecret: Constant.sharedSecretKey)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { [unowned self] (result) in
            switch result {
            case .success(let receipt): do {
                for productId in self.allProductIDs {
                    let purchaseResult = SwiftyStoreKit.verifySubscription(
                        ofType: .autoRenewable, // or .nonRenewing (see below)
                        productId: productId,
                        inReceipt: receipt)
                    
                    print("----------------------------------------------------------------------")
                    switch purchaseResult {
                    case .purchased(let expiryDate, let items):
                        UserDefaults.standard.set(true, forKey: "isPaid")
                        UserDefaults.standard.set(true, forKey: productId)
                        isPurchased = true
                        let xDate = expiryDate.toLocalTime()
                        if latestExpiryDate == nil || xDate > latestExpiryDate! {
                            latestExpiryDate = xDate
                            latestExpiryProductId = productId
                        }
                        let timeRemain:Int = Int(expiryDate.timeIntervalSince1970 - Date().timeIntervalSince1970)
                        print("\(productId) is valid until \(timeRemain)\n\(items)\n")
                        
                    case .expired(let expiryDate, let items):
                        UserDefaults.standard.set(false, forKey: "isPaid")
                        UserDefaults.standard.set(false, forKey: productId)
                        isExpired = true
                        
                        let xDate = expiryDate.toLocalTime()
                        if latestExpiryDate == nil || xDate > latestExpiryDate! {
                            latestExpiryDate = xDate
                            latestExpiryProductId = productId
                        }
                        print("\(productId) is expired since \(expiryDate)\n\(items)\n")
                        
                    case .notPurchased:
                        UserDefaults.standard.set(false, forKey: "isPaid")
                        UserDefaults.standard.set(false, forKey: productId)
                        print("The user has never purchased \(productId)")
                    }
                }
                
                if isPurchased {
                    completion?(.purchased(validDate: latestExpiryDate, product: latestExpiryProductId))
                } else if isExpired {
                    completion?(.expired(date: latestExpiryDate, product: latestExpiryProductId))
                } else {
                    completion?(.notPurchased)
                }
            }
                
            case .error(let error):
                completion?(.error(error: error))
            }
        }
    }
    
    func isSubscribed() -> Bool {
        //FIXME: Comment default return value when goes live
        for productID in allProductIDs {
            if self.isPlanActive(productID) {
                return true
            }
        }
        return false
    }
}

//MARK:- Other Extension
extension Date {
    func getDateString(with fromate: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = fromate
        let myString = formatter.string(from: self)
        return myString
    }
    
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

extension Array where Element : Hashable {
    mutating func unique() {
        self = Array(Set(self))
    }
}

@available(iOS 11.2, *)
extension SKProduct.PeriodUnit {
    func description(capitalizeFirstLetter: Bool = false, numberOfUnits: Int? = nil) -> String {
        let period:String = {
            switch self {
            case .day: return "day"
            case .week: return "week"
            case .month: return "month"
            case .year: return "year"
            }
        }()
        
        var numUnits = ""
        var plural = ""
        if let numberOfUnits = numberOfUnits {
            numUnits = "\(numberOfUnits) " // Add space for formatting
            plural = numberOfUnits > 1 ? "s" : ""
        }
        return "\(numUnits)\(capitalizeFirstLetter ? period.capitalized : period)\(plural)"
    }
}
