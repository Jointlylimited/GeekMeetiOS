//
//  InstagramLoginVC.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 12/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import WebKit

protocol InstagramAuthDelegate {
    func instagramAuthControllerDidFinish(accessToken: String?,id: String?, error: Error?)
}

class InstagramLoginVC: UIViewController {
    
    private let baseURL = "https://api.instagram.com"
    
    var clientId: String! = "274396683687750"
    var clientSecret: String! = "4eeac737c36ea3bdf3e5df4725bba574"
    var redirectUri: String! = "https://www.google.com/"
    
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
        
        //webView = UIWebView(frame: view.frame)
        /*let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script: WKUserScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController: WKUserContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)*/
        webView = WKWebView(frame: view.frame)
    //webView.configuration.userContentController.addUserScript(self.getZoomDisableScript())

        
        //webView.delegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.center = webView.center
        activityIndicatorView.isHidden = true
        activityIndicatorView.hidesWhenStopped = true
        webView.addSubview(activityIndicatorView)
        getLoginPage()
        
    }
    
    private func getZoomDisableScript() -> WKUserScript {
        let source: String = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum- scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" + "head.appendChild(meta);"
        return WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
    
    private func getLoginPage() {
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        //  let authUrl = baseURL + InstagramEndpoints.Authorize.rawValue +
        
        
        
        
        let authUrl = "\(baseURL)\(InstagramEndpoints.Authorize.rawValue)?client_id=\(clientId!)&redirect_uri=\(redirectUri!)&scope=\(InstagramEndpoints.Scope.rawValue)&response_type=\(InstagramEndpoints.response_type.rawValue)"
        print("****AuthUrl : \(authUrl)")
        let request = URLRequest(url: URL(string: authUrl)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
        //webView.loadRequest(request)
        webView.load(request)
    }
    
    private func requestAccessToken(code: String)
    {
        let fullName: String = code
        let fullNameArr = fullName.components(separatedBy: "\(redirectUri!)?code=")
        let strcode = fullNameArr[1]
        let tokenUrl = baseURL + InstagramEndpoints.AccessToken.rawValue
        var components = URLComponents(string: tokenUrl)!
        components.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: redirectUri),
            URLQueryItem(name: "code", value: strcode),
            
        ]
        var request = URLRequest(url: URL(string: tokenUrl)!)
        request.httpMethod = "POST"
        request.httpBody = components.percentEncodedQuery!.data(using: String.Encoding.utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                guard let delegate = self.delegate else {
                    fatalError("InstagramAuthDelegate method needs to be implemented")
                }
               
                self.dismiss()
                delegate.instagramAuthControllerDidFinish(accessToken: nil,id: nil, error: error)
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
            self.dismiss()
            delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)
        }
    }
    private func dismiss() {
        OperationQueue.main.addOperation {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension InstagramLoginVC : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        var action: WKNavigationActionPolicy?
//        defer {decisionHandler(action ?? .allow)}
        
        guard let url = navigationAction.request.url else { return }
        let urlString = url.absoluteString
        print("*****url : \(urlString)")
        // https://www.techumiya.com/
        if let _ = urlString.range(of: "\(redirectUri!)?code=") {
            let code = urlString.dropLast(2)
            requestAccessToken(code: String(code))
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicatorView.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        guard let delegate = self.delegate else {
            fatalError("InstagramAuthDelegate method needs to be implemented")
        }
        self.dismiss()
        delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)
    }
}

//import UIKit
//import WebKit
//
//protocol InstagramAuthDelegate {
//    func instagramAuthControllerDidFinish(accessToken: String?,id: String?, error: Error?)
//}
//
//class InstagramLoginVC: UIViewController {
//
//    let baseURL = "https://api.instagram.com"
//
//    var clientId: String!
//    var clientSecret: String!
//    var redirectUri: String!
//
//    private enum InstagramEndpoints: String {
//        case Authorize = "/oauth/authorize/"
//        case AccessToken = "/oauth/access_token/"
//        case Scope = "user_profile,user_media"
//        case response_type = "code"
//
//    }
//
//    private var webView: WKWebView!
//    private var activityIndicatorView: UIActivityIndicatorView!
//    var accessToken : String?
//    var userID : String?
//
//
//    var delegate: InstagramAuthDelegate?
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    init(clientId: String, clientSecret: String, redirectUri: String) {
//        self.clientId = clientId
//        self.clientSecret = clientSecret
//        self.redirectUri = redirectUri
//
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
////        URLCache.shared.removeAllCachedResponses()
////        HTTPCookieStorage.shared.deleteAllCookies()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//            webView = WKWebView(frame: view.frame)
//            webView.navigationDelegate = self
//            view.addSubview(webView)
//
//            activityIndicatorView = UIActivityIndicatorView(style: .gray)
//            activityIndicatorView.center = webView.center
//            activityIndicatorView.isHidden = true
//            activityIndicatorView.hidesWhenStopped = true
//            webView.addSubview(activityIndicatorView)
//            getLoginPage()
//
//    }
//
//    private func getLoginPage() {
//        activityIndicatorView.isHidden = false
//        activityIndicatorView.startAnimating()
//
//      //  let authUrl = baseURL + InstagramEndpoints.Authorize.rawValue +
//        let authUrl = "\(baseURL)\(InstagramEndpoints.Authorize.rawValue)?client_id=\(INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID )&redirect_uri=\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)&scope=\(InstagramEndpoints.Scope.rawValue)&response_type=\(InstagramEndpoints.response_type.rawValue)"
//        let request = URLRequest(url: URL(string: authUrl)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10)
//        webView.load(request)
//    }
//
//    private func requestAccessToken(code: String)
//    {
//        let fullName: String = code
//        let fullNameArr = fullName.components(separatedBy: "\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)?code=")
//        let strcode = fullNameArr[1]
//        let tokenUrl = baseURL + InstagramEndpoints.AccessToken.rawValue
//        var components = URLComponents(string: tokenUrl)!
//        components.queryItems = [
//            URLQueryItem(name: "client_id", value: clientId),
//            URLQueryItem(name: "client_secret", value: clientSecret),
//            URLQueryItem(name: "grant_type", value: "authorization_code"),
//            URLQueryItem(name: "redirect_uri", value: INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI),
//            URLQueryItem(name: "code", value: strcode),
//
//        ]
//        var request = URLRequest(url: URL(string: tokenUrl)!)
//        request.httpMethod = "POST"
//        request.httpBody = components.percentEncodedQuery!.data(using: String.Encoding.utf8)
//        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                guard let delegate = self.delegate else {
//                    fatalError("InstagramAuthDelegate method needs to be implemented")
//                }
//                self.dismissVC {
//                    delegate.instagramAuthControllerDidFinish(accessToken: nil,id: nil, error: error)
//                }
//            } else {
//                self.getAccessToken(data: data!)
//            }
//        }.resume()
//    }
//
//    private func getAccessToken(data: Data) {
//        do {
//            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
//            var accessToken1 = ""
//            guard let delegate = self.delegate else {
//                fatalError("InstagramAuthDelegate method needs to be implemented")
//            }
//
//            if let accessToken = result["access_token"]
//            {
//                accessToken1 = (accessToken as? String)!
//                let strid = result["user_id"]
//                self.dismiss()
//                delegate.instagramAuthControllerDidFinish(accessToken: accessToken1,id: "\(strid!)", error: nil)
//            }
//        } catch let error {
//            print("Error parsing for access token: \(error.localizedDescription)")
//            guard let delegate = self.delegate else {
//                fatalError("InstagramAuthDelegate method needs to be implemented")
//            }
//            delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)
//        }
//    }
//    private func dismiss() {
//        OperationQueue.main.addOperation {
//            self.dismiss(animated: true, completion: nil)
//        }
//    }
//}
//extension InstagramLoginVC: WKNavigationDelegate
//{
//     func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping ((WKNavigationActionPolicy) -> Void)) {
//
//
//        if let url = navigationAction.request.url {
//                print(url.absoluteString)
//                    let urlString = url.absoluteString
//
//            if let range = urlString.range(of: "\(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)?code=")
//                    {
//                        let location = range.lowerBound
//                        var code = urlString.substring(from: location)
//                        code.removeLast(2) //Str
//                        requestAccessToken(code: code)
//                    print("SUCCESS")
//             }
//        }
//
//        decisionHandler(.allow)
//    }
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//                activityIndicatorView.stopAnimating()
//    }
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)
//    {
//            guard let delegate = self.delegate else {
//            fatalError("InstagramAuthDelegate method needs to be implemented")
//        }
//        delegate.instagramAuthControllerDidFinish(accessToken: nil, id: nil, error: error)
//
//    }
//}
