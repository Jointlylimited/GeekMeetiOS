//
// ContentPageAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class ContentPageAPI {
    /**
     * enum for parameter slug
     */
    public enum Slug_contentPage: String { 
        case aboutUs = "about-us"
        case privacyPolicy = "privacy-policy"
        case terms = "terms"
    }

    /**
     Content Page
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter slug: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func contentPage(nonce: String, timestamp: String, token: String, slug: Slug_contentPage, completion: @escaping ((_ data: ContentPageResponse?,_ error: Error?) -> Void)) {
        contentPageWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, slug: slug).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Content Page
     - GET /content-pages/{slug}
     - examples: [{contentType=application/json, example={
  "responseCode" : 200,
  "responseMessage" : "Success.",
  "responseData" : {
    "vPageName" : "About Us",
    "txContent" : ""
  }
}}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter slug: (path)  

     - returns: RequestBuilder<ContentPageResponse> 
     */
    open class func contentPageWithRequestBuilder(nonce: String, timestamp: String, token: String, slug: Slug_contentPage) -> RequestBuilder<ContentPageResponse> {
        var path = "/content-pages/{slug}"
        let slugPreEscape = "\(slug.rawValue)"
        let slugPostEscape = slugPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{slug}", with: slugPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<ContentPageResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
