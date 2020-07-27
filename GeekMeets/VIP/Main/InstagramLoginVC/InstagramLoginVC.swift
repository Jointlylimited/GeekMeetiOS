//
//  InstagramLoginVC.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 12/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import WebKit

//
//  InstagramAuthViewController.swift
//  InstagramAuth
//
//  Created by Isuru Nanayakkara on 5/17/16.
//  Copyright © 2016 BitInvent. All rights reserved.
//

import UIKit
import WebKit
protocol InstagramAuthDelegate {
    func instagramAuthControllerDidFinish(accessToken: String?,id: String?, error: Error?)
}

class InstagramLoginVC: UIViewController {

    let baseURL = "https://api.instagram.com"
    
    var clientId: String!
    var clientSecret: String!
    var redirectUri: String!
    
    private enum InstagramEndpoints: String {
        case Authorize = "/oauth/authorize/"
        case AccessToken = "/oauth/access_token/"
        case Scope = "user_profile,user_media"
        case response_type = "code"

    }
    
    private var webView: WKWebView!
    private var activityIndicatorView: UIActivityIndicatorView!
    var accessToken : String?
    var userID : String?

    
    var delegate: InstagramAuthDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(clientId: String, clientSecret: String, redirectUri: String) {
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.redirectUri = redirectUri
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        URLCache.shared.removeAllCachedResponses()
//        HTTPCookieStorage.shared.deleteAllCookies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            webView = WKWebView(frame: view.frame)
            webView.navigationDelegate = self
            view.addSubview(webView)
            
            activityIndicatorView = UIActivityIndicatorView(style: .gray)
            activityIndicatorView.center = webView.center
            activityIndicatorView.isHidden = true
            activityIndicatorView.hidesWhenStopped = true
            webView.addSubview(activityIndicatorView)
            getLoginPage()
        
    }
    
    private func getLoginPage() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
      //  let authUrl = baseURL + InstagramEndpoints.Authorize.rawValue +
        


        
        let authUrl = "\(baseURL)\(InstagramEndpoints.Authorize.rawValue)?client_id=\(INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID )&redirect_uri=\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)&scope=\(InstagramEndpoints.Scope.rawValue)&response_type=\(InstagramEndpoints.response_type.rawValue)"
        let request = URLRequest(url: URL(string: authUrl)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        webView.load(request)
    }
    
    private func requestAccessToken(code: String)
    {
        let fullName: String = code
        let fullNameArr = fullName.components(separatedBy: "\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)?code=")
        let strcode = fullNameArr[1]
        let tokenUrl = baseURL + InstagramEndpoints.AccessToken.rawValue
        var components = URLComponents(string: tokenUrl)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI),
            URLQueryItem(name: "code", value: strcode),

        ]
        var request = URLRequest(url: URL(string: tokenUrl)!)
        request.httpMethod = "POST"
        request.httpBody = components.percentEncodedQuery!.data(using: String.Encoding.utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                guard let delegate = self.delegate else {
                    fatalError("InstagramAuthDelegate method needs to be implemented")
                }
                self.dismissVC {
                    delegate.instagramAuthControllerDidFinish(accessToken: nil,id: nil, error: error)
                }
            } else {
                self.getAccessToken(data: data!)
            }
        }.resume()
    }
    
    private func getAccessToken(data: Data) {
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
            var accessToken1 = ""
            guard let delegate = self.delegate else {
                fatalError("InstagramAuthDelegate method needs to be implemented")
            }

            if let accessToken = result["access_token"]
            {
                accessToken1 = (accessToken as? String)!
                let strid = result["user_id"]
                self.dismiss()
                delegate.instagramAuthControllerDidFinish(accessToken: accessToken1,id: "\(strid!)", error: nil)
            }
        } catch let error {
            print("Error parsing for access token: \(error.localizedDescription)")
            guard let delegate = self.delegate else {
                fatalError("InstagramAuthDelegate method needs to be implemented")
            }
            delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)
        }
    }
    private func dismiss() {
        OperationQueue.main.addOperation {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension InstagramLoginVC: WKNavigationDelegate
{
     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {


        if let url = navigationAction.request.url {
                print(url.absoluteString)
                    let urlString = url.absoluteString

            if let range = urlString.range(of: "\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)?code=")
                    {
                        let location = range.lowerBound
                        var code = urlString.substring(from: location)
                        code.removeLast(2) //Str
                        requestAccessToken(code: code)
                    print("SUCCESS")
             }
        }

        decisionHandler(.allow)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
                activityIndicatorView.stopAnimating()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
    {
            guard let delegate = self.delegate else {
            fatalError("InstagramAuthDelegate method needs to be implemented")
        }
        delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)

    }

}

//extension HTTPCookieStorage {
//    func deleteAllCookies() {
//        if let cookies = self.cookies {
//            for cookie in cookies {
//                self.deleteCookie(cookie)
//            }
//        }
//    }
//}


//class InstagramLoginVC: UIViewController {
//
//    @IBOutlet weak var loginWebView: UIWebView!
//    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
//    var delegate : InstagramAuthenticationDelegate!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE])
//        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
//        self.loginWebView.delegate = self
//        self.loginWebView.loadRequest(urlRequest)
//
////        self.loginWebView.delegate = self
////        self.unSignedRequest()
//    }
//
//    //MARK: - unSignedRequest - Instagram
//     func unSignedRequest () {
//            let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE])
//            let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
//        loginWebView.loadRequest(urlRequest)
//    }
//
//    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
//           let requestURLString = (request.url?.absoluteString)! as String
//           if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
//               let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
//               handleAuth(authToken: requestURLString.substring(from: range.upperBound))
//               return false;
//           }
//           return true
//       }
//       func handleAuth(authToken: String) {
//           INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN = authToken
//           print("Instagram authentication token ==", authToken)
//           getUserInfo(){(data) in
//               DispatchQueue.main.async {
//                   self.dismiss(animated: true, completion: nil)
//               }
//
//           }
//       }
//       func getUserInfo(completion: @escaping ((_ data: Bool) -> Void)){
//           let url = String(format: "%@%@", arguments: [INSTAGRAM_IDS.INSTAGRAM_USER_INFO,INSTAGRAM_IDS.INSTAGRAM_ACCESS_TOKEN])
//           var request = URLRequest(url: URL(string: url)!)
//           request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//           let session = URLSession.shared
//           let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
//               guard error == nil else {
//                    completion(false)
//                   //failure
//                   return
//               }
//               // make sure we got data
//               guard let responseData = data else {
//                   completion(false)
//                    //Error: did not receive data
//                   return
//               }
//               do {
//                   guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
//                       as? [String: AnyObject] else {
//                           completion(false)
//                           //Error: did not receive data
//                           return
//                   }
//                   completion(true)
//                   // success (dataResponse) dataResponse: contains the Instagram data
//               } catch let err {
//                   completion(false)
//                   //failure
//               }
//           })
//           task.resume()
//       }
////    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
////
////        let requestURLString = (request.url?.absoluteString)! as String
////
////        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
////            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
////            DispatchQueue.main.async {
////                self.handleAuth(authToken: requestURLString.substring(from: range.upperBound))
////            }
////            return false;
////        }
////        return true
////    }
//
////    func handleAuth(authToken: String)  {
////        print("Instagram authentication token ==", authToken)
////        self.dismissVC {
////            self.delegate.fetchAuthToken(token: authToken)
////        }
////    }
//    @IBAction func btnCloseAction(_ sender: UIButton) {
//        self.dismissVC(completion: nil)
//    }
//}
//
//extension InstagramLoginVC: UIWebViewDelegate{
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
//        return checkRequestForCallbackURL(request: request)
//    }
//}
//extension InstagramLoginVC: WKNavigationDelegate{
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
//
//        if checkRequestForCallbackURL(request: navigationAction.request){
//            decisionHandler(.allow)
//        }else{
//            decisionHandler(.cancel)
//        }
//    }
//}
//
//// MARK: - UIWebViewDelegate
////extension InstagramLoginVC : UIWebViewDelegate, WKNavigationDelegate {
////
////    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
////
////
////        if let url = navigationAction.request.url {
////                print(url.absoluteString)
////                    let urlString = url.absoluteString
////
////            if let range = urlString.range(of: "\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)?code=")
////                    {
////                        let location = range.lowerBound
////                        var code = urlString.substring(from: location)
////                        code.removeLast(2) //Str
//////                        requestAccessToken(code: code)
////                    print("SUCCESS")
////             }
////        }
////
////        decisionHandler(.allow)
////    }
////
////    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
////        return checkRequestForCallbackURL(request: request)
////    }
////
////    func webViewDidStartLoad(_ webView: UIWebView) {
////        loginActivityIndicator.isHidden = false
////        loginActivityIndicator.startAnimating()
////    }
////
////    func webViewDidFinishLoad(_ webView: UIWebView) {
////        loginActivityIndicator.isHidden = true
////        loginActivityIndicator.stopAnimating()
////    }
////
////    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
////        webViewDidFinishLoad(webView)
////    }
////}
