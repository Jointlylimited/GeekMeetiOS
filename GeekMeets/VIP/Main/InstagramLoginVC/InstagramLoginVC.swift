//
//  InstagramLoginVC.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 12/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import UIKit
import WebKit

class InstagramLoginVC: UIViewController {

    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    var delegate : InstagramAuthenticationDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginWebView.delegate = self
        self.unSignedRequest()
    }
    
    //MARK: - unSignedRequest - Instagram
     func unSignedRequest () {
            let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_IDS.INSTAGRAM_AUTHURL,INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID,INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI, INSTAGRAM_IDS.INSTAGRAM_SCOPE])
            let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
        loginWebView.loadRequest(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        
        let requestURLString = (request.url?.absoluteString)! as String
        
        if requestURLString.hasPrefix(INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            DispatchQueue.main.async {
                self.handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            }
            return false;
        }
        return true
    }
    
    func handleAuth(authToken: String)  {
        print("Instagram authentication token ==", authToken)
        self.dismissVC {
            self.delegate.fetchAuthToken(token: authToken)
        }
    }
    @IBAction func btnCloseAction(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
}

// MARK: - UIWebViewDelegate
extension InstagramLoginVC : UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        return checkRequestForCallbackURL(request: request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loginActivityIndicator.isHidden = false
        loginActivityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loginActivityIndicator.isHidden = true
        loginActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        webViewDidFinishLoad(webView)
    }
}
