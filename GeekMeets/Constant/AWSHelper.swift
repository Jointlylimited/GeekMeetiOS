//
//  AWSHelper.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 21/05/20.
//  Copyright © 2020 SOTSYS203. All rights reserved.
//

import Foundation
import UIKit
import AWSS3
import AWSCore
import MobileCoreServices

public struct AmazonCredentials {
    var bucketName : String
    var poolID: String
    var region : AWSRegionType
    
    public init(bucketName : String, poolID: String, region : AWSRegionType) {
        self.bucketName = bucketName
        self.poolID = poolID
        self.region = region
    }
}

/* =======================
 AWS_Credentials
========================== */
let fileUploadURL = "https://jointly-deployments-mobilehub-485669344.s3.us-east-2.amazonaws.com/"
let AWS_ACCESS_KEY_ID = "AKIAVF7QBUBTPE3BVF6O"
let AWS_SECRET_ACCESS_KEY = "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"
let AWS_BUCKET_NAME = "jointly-deployments-mobilehub-485669344/"
let AWS_REGION = "us-east-1"

/* =======================
 AWS Folder Name
========================== */
let user_Profile = "UserProfile/"
let story = "Story/"

typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3

public class AWSHelper {
    
    // public vars
    public static let shared = AWSHelper()
    
    
    // private vars
    fileprivate static var credentials : AmazonCredentials!
    fileprivate var fileURL = [String]()
    
    fileprivate var currentIndex = 0
    
    public static func setup(){
        let contryPath = Bundle.main.path(forResource: "iOSawsconfiguration", ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: contryPath))
        do {
            if let dict = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any], let credentialProvider = dict["CredentialsProvider"] as? [String:Any], let cognitoIdentity = credentialProvider["CognitoIdentity"] as? [String:Any], let credential = cognitoIdentity["Default"] as? [String:Any], let transferUtility = dict["S3TransferUtility"] as? [String:Any], let bucketDict = transferUtility["Default"] as? [String:Any], let bucket = bucketDict["Bucket"] as? String {
                let poolId = credential["PoolId"] as? String ?? ""
                let region = credential["Region"] as? String ?? ""
                let bucketID = bucket
                credentials = AmazonCredentials(bucketName: bucketID, poolID: poolId, region: AWSRegionType.regionTypeForString(regionString: region))
                
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    var completionHandler : AWSS3TransferUtilityUploadCompletionHandlerBlock? =
    { (task, error) -> Void in
        
        if ((error) != nil)
        {
            print("Upload failed")
        }
        else
        {
            print("File uploaded successfully")
        }
    }
    
    var progressBlock: AWSS3TransferUtilityProgressBlock?
    
    private init() {
        if AWSHelper.credentials != nil, !AWSHelper.credentials.bucketName.isEmpty, !AWSHelper.credentials.poolID.isEmpty {
            let credentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSHelper.credentials.region,identityPoolId:AWSHelper.credentials.poolID)

            let configuration: AWSServiceConfiguration = AWSServiceConfiguration(region: AWSHelper.credentials.region, credentialsProvider: credentialsProvider)
            AWSServiceManager.default().defaultServiceConfiguration = configuration
        } else {
            fatalError("Error - you must call setup before accessing AmazonUploader")
        }
        
        //Regular initialisation using param
    }
    
    func uploadFile(){
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.bucket = "myBucket"
        getPreSignedURLRequest.key = "myFile.txt"
        getPreSignedURLRequest.httpMethod = .PUT
        getPreSignedURLRequest.expires = Date(timeIntervalSinceNow: 3600)
        
        //Important: set contentType for a PUT request.
        let fileContentTypeStr = "text/plain"
        getPreSignedURLRequest.contentType = fileContentTypeStr
        
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as? NSError {
                print("Error: \(error)")
                return nil
            }
            
            let presignedURL = task.result
            print("Download presignedURL is: \(presignedURL)")
            
            var request = URLRequest(url: presignedURL as! URL)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.httpMethod = "PUT"
            request.setValue(fileContentTypeStr, forHTTPHeaderField: "Content-Type")
            
            let uploadTask: URLSessionTask = URLSession.shared.uploadTask(with: request, fromFile: URL(fileURLWithPath: "your/file/path/myFile.txt"))
            uploadTask.resume()
            
            return nil
        }
    }

    //MARK: Upload with normal manager
    public func upload(img: UIImage, imgPath:String, imgName:String , completed: @escaping (_ isSuccess: Bool,_ url: String?, _ error : Error?) -> Void) {
        let pathBucket = "\(AWSHelper.credentials.bucketName)"
        print("bucketName : \(pathBucket) \n poolID : \(AWSHelper.credentials.poolID) \n region : \(AWS_REGION)")
        
        self.progressBlock = {(task, progress) in
            print("Progress: \(Float(progress.fractionCompleted) * 100)")
        }
        
        if let imageData = img.jpegData(compressionQuality: 1.0) {
            DispatchQueue.main.async {
                let utility = AWSS3TransferUtility.default()
                let bucketName = pathBucket
                let mimeType = "image/jpeg"
                let expression = AWSS3TransferUtilityUploadExpression()
                expression.setValue("public-read", forRequestHeader: "x-amz-acl")
                expression.progressBlock = self.progressBlock
                
                utility.uploadData(imageData, bucket: bucketName, key: imgPath, contentType: mimeType, expression: expression, completionHandler: { (task, error) in
                    print("Request: \(String(describing: task.request))")
                    print("Response: \(String(describing: task.response))")
                    print("======== Image-Path ========== \n path: \(imgPath) || name: \(imgName)")
                    if let err = error {
                        completed(false,nil,err)
                    } else {
                        completed(true,imgPath,nil)
                    }
                })
            }
        }
    }
    
    //MARK: Upload video
    public func uploadVideo(video: URL, videoPath:String, videoName:String , completed: @escaping (_ isSuccess: Bool,_ url: String?, _ error : Error?) -> Void) {
        let pathBucket = "\(AWSHelper.credentials.bucketName)"
        print("bucketName : \(pathBucket) \n poolID : \(AWSHelper.credentials.poolID) \n region\(AWSHelper.credentials.region.rawValue)")
        let fileUrl = video
        print("File URL : \(video)")
        let mimeType = video.pathExtension
        print("mime-type: \(mimeType)")
        let utility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        self.progressBlock = {(task, progress) in
            let taskProgress = Float(progress.fractionCompleted) * 100
            print("Progress: \(taskProgress)")
//            let label = UILabel(frame: CGRect(x: _screenSize.width/2, y: _screenSize.height/2, w: _screenSize.width, h: 50))
//            label.textColor = UIColor.white
//            label.text = "\(taskProgress)%"
//            _appDelegate.window?.addSubview(label)
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "ProgressValue"), object: Float(progress.fractionCompleted))
        }
        expression.progressBlock = self.progressBlock
        
        DispatchQueue.main.async {
            print("Video name: \(videoName) \n Video path: \(videoPath)")
            utility.uploadFile(fileUrl, bucket: pathBucket, key: videoPath, contentType: mimeType, expression: expression) { (task, error) in
                print("Request: \(String(describing: task.request))")
                print("Response: \(String(describing: task.response))")
                print("======== Video-Path ========== \n path: \(videoPath) || name: \(videoName)")
                if let err = error {
                    completed(false,nil,err)
                } else {
                    completed(true,videoPath,nil)
                }
            }
        }
    }
    
    fileprivate func mimeTypeFromFileExtension(path: String) -> String {
        let url = NSURL(fileURLWithPath: path)
        let pathExtension = url.pathExtension
        
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
    
    
}

class AWSService {
    
    class func getPreSignedURL(for fileKey: String) -> String {
        var preSignedURLString = ""
        let getPreSignedURLRequest = AWSS3GetPreSignedURLRequest()
        getPreSignedURLRequest.httpMethod = AWSHTTPMethod.GET
        getPreSignedURLRequest.key = fileKey
        getPreSignedURLRequest.bucket = AWS_BUCKET_NAME
//        getPreSignedURLRequest.expires = Date.tomorrow//Date(timeIntervalSinceNow: 3600)
        
        AWSS3PreSignedURLBuilder.default().getPreSignedURL(getPreSignedURLRequest).continueWith { (task:AWSTask<NSURL>) -> Any? in
            if let error = task.error as NSError? {
                print("----Error: \(error.localizedDescription) ----")
                return nil
            }
            preSignedURLString = (task.result?.absoluteString)!
            return nil
        }
        return preSignedURLString
    }
}

extension AWSRegionType {
    /**
     Return an AWSRegionType for the given string
     
     - Parameter regionString: The Region name (e.g. us-east-1) as a string
     
     - Returns: A new AWSRegionType for the given string, Unknown if no region was found.
     */
    static func regionTypeForString(regionString: String) -> AWSRegionType {
        switch regionString {
        case "us-east-1": return .USEast1
        case "us-east-2": return .USEast2
        case "us-west-1": return .USWest1
        case "us-west-2": return .USWest2
        case "eu-west-1": return .EUWest1
        case "eu-west-2": return .EUWest2
        case "eu-central-1": return .EUCentral1
        case "ap-northeast-1": return .APNortheast1
        case "ap-northeast-2": return .APNortheast2
        case "ap-southeast-1": return .APSoutheast1
        case "ap-southeast-2": return .APSoutheast2
        case "sa-east-1": return .SAEast1
        case "cn-north-1": return .CNNorth1
        case "ap-south-1": return .APSouth1
        case "us-gov-west-1": return .USGovWest1
        default: return .Unknown
        }
    }
}

