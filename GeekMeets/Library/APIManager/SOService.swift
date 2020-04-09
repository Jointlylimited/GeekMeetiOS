//
//  Copyright © 2018 SOTSYS220. All rights reserved.
//

import UIKit
import Moya
import Alamofire
import SwiftyJSON
import Reachability

typealias APICompletionHandler = (_ code:Int, _ error:NSError?, _ responseJson: JSON?) -> Void

enum ConnectionResult {
    case success(JSON?)
    case failure(Error?)
}


// MARK: - Provider setup
private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

class SOService {
    
    private static let easyPayProvider = MoyaProvider<SOAPI>(plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)])
    static let provider = MoyaProvider<SOAPI>()
    static var isJson = true
    
    static func isNetwork() -> Bool {
        do {
        let hostreach : Reachability = try Reachability.init()
        return !(hostreach.connection == .unavailable)
        } catch {
            return false
        }
    }
    
    //MARK: Call all kind of APIs (GET, POST, DELETE, PUT etc)
    static func callAPI(_ service : SOAPI, completionHandler:@escaping APICompletionHandler) {
        
        provider.request(service) { (result) in
            print(result.error?.errorDescription ?? "")
            switch result {
            case .success(_):
                if isJson == true {
                    do {
                        let mapData = try result.value?.mapJSON()
                        print(mapData ?? "Not getting map values")
                        
                        let jsonData = JSON(mapData ?? "Not mapping in JSON")
                        print(jsonData)

                        completionHandler(1, nil, jsonData)
                    } catch {
                        completionHandler(0, nil, nil)
                    }
                } else {
//                    do {
//                        let mapxmlData = try result.value?.mapString()
//                        print(mapxmlData ?? "Not getting map values")
//                        let mapJsonData = self.getJsonData(xmlString: mapxmlData!)
//                        let jsonData = JSON(mapJsonData ?? "Not mapping in JSON")
//                        completionHandler(1, nil, jsonData)
//                    } catch {
//                        completionHandler(0, nil, nil)
//                    }
                }
            case .failure(_):
                completionHandler(0, nil, nil)
            }
        }
    }
    
    /*
    //MARK: Call all kind of APIs (GET, POST, DELETE, PUT etc)
    static func callNewAPI(_ service : SOAPI, completionHandler:@escaping (ConnectionResult) -> ()) {
        
        provider.request(service) { (result) in
            print(result.error?.errorDescription ?? "")
            switch result {
            case .success(_):
                if isJson == true {
                    do {
                        let mapData = try result.value?.mapJSON()
                        print(mapData ?? "Not getting map values")
                        
                        let jsonData = JSON(mapData ?? "Not mapping in JSON")
                        print(jsonData)
                        
                        completionHandler(.success(jsonData))
                    } catch {
                        completionHandler(.failure(nil))
                    }
                } else {
                    do {
                        let mapxmlData = try result.value?.mapString()
                        print(mapxmlData ?? "Not getting map values")
                        let mapJsonData = self.getJsonData(xmlString: mapxmlData!)
                        let jsonData = JSON(mapJsonData ?? "Not mapping in JSON")
                        completionHandler(.success(jsonData))
                    } catch {
                        completionHandler(.failure(nil))
                    }
                }
            case .failure(_):
                completionHandler(.failure(nil))
            }
        }
    }*/
    
    
    
//    //MARK: Upload Multipart Data
//    static func callMultiPartAPI(_ service : SOAPI, completionHandler:@escaping APICompletionHandler) {
//        provider.request(service) { (result) in
//            switch result{
//            case .success(_):
//                print("Success")
//                completionHandler(1, nil, result.value)
//            case .failure(_):
//                print("Failure")
//                completionHandler(1, (result.error! as NSError), nil)
//            }
//        }
//    }
    
    //MARK: Convert Xml into Json
    static func getJsonData(xmlString : String) -> Any? {
//        do {
//            let d = try XMLReader.dictionary(forXMLString: xmlString)
//            let data = try JSONSerialization.data(withJSONObject: d, options: .prettyPrinted)
//            let dic = try JSONSerialization.jsonObject(with: data, options: [])
//            print(dic)
//            return dic
//        } catch {
//            return nil
//        }
        return nil
    }
}
