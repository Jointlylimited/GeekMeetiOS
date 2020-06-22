//
// MediaAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class MediaAPI {
    /**
     Apply reaction on user pic
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter iUserId: (form) user id for other user 
     - parameter iMediaId: (form) media id for pic 
     - parameter tiRactionType: (form) 1-heart,2-hearteyes,3-heartkiss 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func applyReaction(nonce: String, timestamp: String, token: String, authorization: String, iUserId: String, iMediaId: String, tiRactionType: String, completion: @escaping ((_ data: MediaReaction?,_ error: Error?) -> Void)) {
        applyReactionWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, authorization: authorization, iUserId: iUserId, iMediaId: iMediaId, tiRactionType: tiRactionType).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     Apply reaction on user pic
     - POST /users-story/apply-reaction
     - examples: [{contentType=application/json, example=""}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter iUserId: (form) user id for other user 
     - parameter iMediaId: (form) media id for pic 
     - parameter tiRactionType: (form) 1-heart,2-hearteyes,3-heartkiss 

     - returns: RequestBuilder<MediaReaction> 
     */
    open class func applyReactionWithRequestBuilder(nonce: String, timestamp: String, token: String, authorization: String, iUserId: String, iMediaId: String, tiRactionType: String) -> RequestBuilder<MediaReaction> {
        let path = "/users-story/apply-reaction"
        let URLString = SwaggerClientAPI.basePath + path
        let formParams: [String:Any?] = [
            "iUserId": iUserId,
            "iMediaId": iMediaId,
            "tiRactionType": tiRactionType
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token,
            "authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<MediaReaction>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     post users story
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter txStory: (form) story content 
     - parameter tiStoryType: (form) 0-Image, 1-Video, 2-Text 
     - parameter vThumbnail: (form) video thumbnail (optional, default to abc.mp4)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func createStory(nonce: String, timestamp: String, token: String, authorization: String, txStory: String, tiStoryType: String, vThumbnail: String? = nil, completion: @escaping ((_ data: CommonResponse?,_ error: Error?) -> Void)) {
        createStoryWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, authorization: authorization, txStory: txStory, tiStoryType: tiStoryType, vThumbnail: vThumbnail).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     post users story
     - POST /users-story/create
     - examples: [{contentType=application/json, example={
  "responseMessage" : "responseMessage",
  "responseCode" : 0
}}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter txStory: (form) story content 
     - parameter tiStoryType: (form) 0-Image, 1-Video, 2-Text 
     - parameter vThumbnail: (form) video thumbnail (optional, default to abc.mp4)

     - returns: RequestBuilder<CommonResponse> 
     */
    open class func createStoryWithRequestBuilder(nonce: String, timestamp: String, token: String, authorization: String, txStory: String, tiStoryType: String, vThumbnail: String? = nil) -> RequestBuilder<CommonResponse> {
        let path = "/users-story/create"
        let URLString = SwaggerClientAPI.basePath + path
        let formParams: [String:Any?] = [
            "txStory": txStory,
            "tiStoryType": tiStoryType,
            "vThumbnail": vThumbnail
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token,
            "authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CommonResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     delete users story
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteStory(nonce: String, timestamp: String, token: String, authorization: String, _id: String, completion: @escaping ((_ data: CommonResponse?,_ error: Error?) -> Void)) {
        deleteStoryWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, authorization: authorization, _id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     delete users story
     - DELETE /users-story/delete/{id}
     - examples: [{contentType=application/json, example={
  "responseMessage" : "responseMessage",
  "responseCode" : 0
}}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter _id: (path)  

     - returns: RequestBuilder<CommonResponse> 
     */
    open class func deleteStoryWithRequestBuilder(nonce: String, timestamp: String, token: String, authorization: String, _id: String) -> RequestBuilder<CommonResponse> {
        var path = "/users-story/delete/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token,
            "authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CommonResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     list users story
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter _id: (path) 0-No,1-Yes 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func listStory(nonce: String, timestamp: String, token: String, authorization: String, _id: Int, completion: @escaping ((_ data: StoryResponse?,_ error: Error?) -> Void)) {
        listStoryWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, authorization: authorization, _id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     list users story
     - GET /users-story/list/{id}
     - examples: [{contentType=application/json, example=""}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter _id: (path) 0-No,1-Yes 

     - returns: RequestBuilder<StoryResponse> 
     */
    open class func listStoryWithRequestBuilder(nonce: String, timestamp: String, token: String, authorization: String, _id: Int) -> RequestBuilder<StoryResponse> {
        var path = "/users-story/list/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token,
            "authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<StoryResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

    /**
     view users story
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter iStoryId: (form) story content 
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func viewStory(nonce: String, timestamp: String, token: String, authorization: String, iStoryId: String, completion: @escaping ((_ data: CommonResponse?,_ error: Error?) -> Void)) {
        viewStoryWithRequestBuilder(nonce: nonce, timestamp: timestamp, token: token, authorization: authorization, iStoryId: iStoryId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     view users story
     - POST /users-story/view
     - examples: [{contentType=application/json, example={
  "responseMessage" : "responseMessage",
  "responseCode" : 0
}}]
     
     - parameter nonce: (header)  
     - parameter timestamp: (header)  
     - parameter token: (header)  
     - parameter authorization: (header)  
     - parameter iStoryId: (form) story content 

     - returns: RequestBuilder<CommonResponse> 
     */
    open class func viewStoryWithRequestBuilder(nonce: String, timestamp: String, token: String, authorization: String, iStoryId: String) -> RequestBuilder<CommonResponse> {
        let path = "/users-story/view"
        let URLString = SwaggerClientAPI.basePath + path
        let formParams: [String:Any?] = [
            "iStoryId": iStoryId
        ]

        let nonNullParameters = APIHelper.rejectNil(formParams)
        let parameters = APIHelper.convertBoolToString(nonNullParameters)
        
        let url = URLComponents(string: URLString)
        let nillableHeaders: [String: Any?] = [
            "nonce": nonce,
            "timestamp": timestamp,
            "token": token,
            "authorization": authorization
        ]
        let headerParameters = APIHelper.rejectNilHeaders(nillableHeaders)

        let requestBuilder: RequestBuilder<CommonResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false, headers: headerParameters)
    }

}
