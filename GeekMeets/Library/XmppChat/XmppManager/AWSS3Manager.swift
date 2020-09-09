//
//  AWSS3Manager.swift
//  xmppchat
//
//  Created by SOTSYS255 on 17/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//


import UIKit
import AWSS3
//import Backendless

typealias progressBlock = (_ progress: Double) -> Void //2
//typealias completionBlock = (_ response: Any?, _ error: Error?) -> Void //3


 
class AWSS3Manager {
    
    static let shared = AWSS3Manager() // 4
    private init () { }
    let bucketName = "" // your bucket name
    
    
    var index = 0
    
    var activeUploads: [ChatUploadTask] = [ChatUploadTask]()
    
    //Divya added
    var thumbURlUpload: (path: String, name: String) {
        let folderName = "Chat/" //"user_critique/"
        let timeStamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let imgExtension = ".jpeg"
        let path = "\(folderName)\(timeStamp)\(imgExtension)" //"\(folderName)\(prefix)\(timeStamp)\(imgExtension)"
        return (path: path, name: "\(timeStamp)\(imgExtension)" /*"\(prefix)\(timeStamp)\(imgExtension)"*/)
    }
    
    // video data Path/Name
    var videoURlUpload: (path: String, name: String) {
        let folderName = "Chat/"
        let timeStamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let videoExtension = ".mp4"
        let path = "\(folderName)\(timeStamp)\(videoExtension)"
        return (path: path, name: "\(timeStamp)\(videoExtension)")
    }
    
    // video data Path/Name
    var gifURlUpload: (path: String, name: String) {
        let folderName = "Chat/"
        let timeStamp = Authentication.sharedInstance().GetCurrentTimeStamp()
        let gifExtension = ".gif"
        let path = "\(folderName)\(timeStamp)\(gifExtension)"
        return (path: path, name: "\(timeStamp)\(gifExtension)")
    }
    
    func sequenceUpload()  {
        
        guard index < activeUploads.count else {
            index = 0
            activeUploads.removeAll()
            return
        }

        let task = activeUploads[index]
        index += 1
        
        let msgType =  XMPP_Message_Type.init(rawValue: task.objChat.msgType!)
        
        switch msgType {
        case .image:
            
            let fileName = task.localPath.lastPathComponent
            self.uploadfile(fileUrl: task.localPath, fileName: fileName, contenType: "image", progress: task.progressCallback, completion: task.completionCallback)
            
        case .video:
            
            let fileName = task.localPath.lastPathComponent
            self.uploadfile(fileUrl: task.localPath, fileName: fileName, contenType: "video", progress: task.progressCallback, completion: task.completionCallback)
            
        case .document:
            
            let fileName = task.localPath.lastPathComponent
            self.uploadfile(fileUrl: task.localPath, fileName: fileName, contenType: "pdf", progress: task.progressCallback, completion: task.completionCallback)
            
        case .gif:
            
            let fileName = task.localPath.lastPathComponent
            self.uploadfile(fileUrl: task.localPath, fileName: fileName, contenType: "gif", progress: task.progressCallback, completion: task.completionCallback)
            
        default:
            break
        }
        
    }
    
    func CancelAllDownloadAndUploadTask() {
        
        self.activeUploads.removeAll()
        self.index = 0
        
        XMPP_MessageArchiving_Custom.ResetUplodingMessage()
        
        URLSession.shared.getAllTasks { (tasks) in
            //tasks.filter{$0.state == .running}.filter { $0.originalRequest?.url == url }.first?.cancel()
        }
    }
//    // Upload image using UIImage object
//    func uploadImage(image: UIImage, progress: progressBlock?, completion: completionBlock?) {
//
//        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
//            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
//            completion?(nil, error)
//            return
//        }
//
//        let fileName: String = ProcessInfo.processInfo.globallyUniqueString + (".jpeg")
//
//        let fileUrl = Chat_Utility.documentsPath.appendingPathComponent(fileName)
//
//        do {
//            try imageData.write(to: fileUrl)
//            self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: "image", progress: progress, completion: completion)
//        } catch {
//            let error = NSError(domain:"", code:402, userInfo:[NSLocalizedDescriptionKey: "invalid image"])
//            completion?(nil, error)
//        }
//    }
    
    // Upload video from local path url
    func uploadVideo(videoUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: videoUrl)
        self.uploadfile(fileUrl: videoUrl, fileName: fileName, contenType: "video", progress: progress, completion: completion)
    }
    
    // Upload auido from local path url
    func uploadAudio(audioUrl: URL, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: audioUrl)
        self.uploadfile(fileUrl: audioUrl, fileName: fileName, contenType: "audio", progress: progress, completion: completion)
    }
    
    // Upload files like Text, Zip, etc from local path url
    func uploadOtherFile(fileUrl: URL, conentType: String, progress: progressBlock?, completion: completionBlock?) {
        let fileName = self.getUniqueFileName(fileUrl: fileUrl)
        self.uploadfile(fileUrl: fileUrl, fileName: fileName, contenType: conentType, progress: progress, completion: completion)
    }
    
    // Get unique file name
    func getUniqueFileName(fileUrl: URL) -> String {
        let strExt: String = "." + (URL(fileURLWithPath: fileUrl.absoluteString).pathExtension)
        return (ProcessInfo.processInfo.globallyUniqueString + (strExt))
    }
    
    //MARK:- AWS file upload
    // fileUrl :  file local path url
    // fileName : name of file, like "myimage.jpeg" "video.mov"
    // contenType: file MIME type
    // progress: file upload progress, value from 0 to 1, 1 for 100% complete
    // completion: completion block when uplaoding is finish, you will get S3 url of upload file here
    private func uploadfile(fileUrl: URL, fileName: String, contenType: String, progress: progressBlock?, completion: completionBlock?) {
        
        let fileData = try? Data.init(contentsOf: fileUrl)
        if contenType == "image" {
            let image = activeUploads.count == 0 ? activeUploads[0].image : activeUploads[activeUploads.count - 1].image
            AWSHelper.setup()
            AWSHelper.shared.upload(img: image!, imgPath: self.thumbURlUpload.path, imgName: self.thumbURlUpload.name) { [weak self] (isUploaded, path, error) in
                //                    DispatchQueue.main.async {
                //                        LoaderView.sharedInstance.hideLoader()
                //                    }
                guard let `self` = self else {return}
                if let err = error {
                    print("ERROR : \(err.localizedDescription)")
                    AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
                    //                        _ = ValidationToast.showStatusMessage(message: err.localizedDescription)
                } else if isUploaded {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            if let completionBlock = completion {
                                completionBlock(path, path, nil)
                            }
                            //                AWSS3Manager.shared.sequenceUpload()
                        }
                        //                            self.arryMsgs.removeLast()
                        //                            self.viewController?.successLoadMessages(arry: self.arryMsgs, isLast:false)
                        //                    SKxmpp.manager()?.xmpp_SendMessage(self.dictBody(type: MediaType.image, text: nil, url: path, thumb_url: path, sticker_cat: nil, sticker_id: nil), timeStamp: appSingleton.getCurrentTimeStamp(), toUser: (self.receiver?.user_id)!)
                    }
                } else {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                    //                        _ = ValidationToast.showStatusMessage(message: kSomethingWentWrong)
                }
            }
        } else if contenType == "video" {
            let image = activeUploads.count == 0 ? activeUploads[0].image : activeUploads[activeUploads.count - 1].image
            AWSHelper.setup()
            var thumbPath : String = ""
            AWSHelper.shared.upload(img: image!, imgPath: self.thumbURlUpload.path, imgName: self.thumbURlUpload.name) { [weak self] (isUploaded, path, error) in
                guard let `self` = self else {return}
                if let err = error {
                    print("ERROR : \(err.localizedDescription)")
                    AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
                } else if isUploaded {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            if let completionBlock = completion {
                                thumbPath = path!
                                self.uploadVideo(thumbUrl: thumbPath, completion: completionBlock)
                            }
                        }
                    }
                } else {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                }
            }
        } else {
            let image = activeUploads.count == 0 ? activeUploads[0].image : activeUploads[activeUploads.count - 1].image
            AWSHelper.setup()
            var thumbPath : String = ""
            AWSHelper.shared.upload(img: image!, imgPath: self.thumbURlUpload.path, imgName: self.thumbURlUpload.name) { [weak self] (isUploaded, path, error) in
                guard let `self` = self else {return}
                if let err = error {
                    print("ERROR : \(err.localizedDescription)")
                    AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
                } else if isUploaded {
                    DispatchQueue.main.async {
                        DispatchQueue.main.async {
                            if let completionBlock = completion {
                                thumbPath = path!
                                self.uploadGif(thumbUrl: thumbPath, completion: completionBlock) 
                            }
                        }
                    }
                } else {
                    AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                }
            }
        }
//        Backendless.shared.file.uploadFile(fileName: fileName, filePath: fileUrl.absoluteString, content: fileData!, responseHandler: { (file) in
//            print("File has been uploaded: \(file.fileUrl ?? "")")
//            DispatchQueue.main.async {
//                if let completionBlock = completion {
//                    completionBlock(file.fileUrl, nil)
//                }
////                AWSS3Manager.shared.sequenceUpload()
//            }
//        }) { (fault) in
//            print("Uploaded Error: \(fault.message ?? "")")
//            DispatchQueue.main.async {
//                if let completionBlock = completion {
//                    completionBlock(nil, fault)
//                }
//                AWSS3Manager.shared.sequenceUpload()
//            }
//        }
        
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
//            if let completionBlock = completion {
//                completionBlock(" completed === upload ", nil)
//            }
//            AWSS3Manager.shared.sequenceUpload()
//        }
//        guard let uploadProgress = progress else { return }
//        DispatchQueue.main.async {
//            uploadProgress(0.0)
//        }
        
        return
        
        
        
        // Upload progress block
        let expression = AWSS3TransferUtilityUploadExpression()
        expression.progressBlock = {(task, awsProgress) in
            guard let uploadProgress = progress else { return }
            DispatchQueue.main.async {
                uploadProgress(awsProgress.fractionCompleted)
            }
        }
        // Completion block
        var completionHandler: AWSS3TransferUtilityUploadCompletionHandlerBlock?
        completionHandler = { (task, error) -> Void in
            DispatchQueue.main.async(execute: {
                if error == nil {
                    let url = AWSS3.default().configuration.endpoint.url
                    let publicURL = url?.appendingPathComponent(self.bucketName).appendingPathComponent(fileName)
                    print("Uploaded to:\(String(describing: publicURL))")
                    if let completionBlock = completion {
                        completionBlock(publicURL?.absoluteString, nil, nil)
                    }
                } else {
                    if let completionBlock = completion {
                        completionBlock(nil, nil, error)
                    }
                }
                AWSS3Manager.shared.sequenceUpload()
            })
        }
        // Start uploading using AWSS3TransferUtility
        let awsTransferUtility = AWSS3TransferUtility.default()
        awsTransferUtility.uploadFile(fileUrl, bucket: bucketName, key: fileName, contentType: contenType, expression: expression, completionHandler: completionHandler).continueWith { (task) -> Any? in
            if let error = task.error {
                print("error is: \(error.localizedDescription)")
            }
            if let _ = task.result {
                // your uploadTask
            }
            return nil
        }
    }
    
    func uploadVideo(thumbUrl : String, completion : completionBlock?){
        let url = activeUploads.count == 0 ? activeUploads[0].localPath : activeUploads[activeUploads.count - 1].localPath
        AWSHelper.shared.uploadVideo(video: url, videoPath: videoURlUpload.path, videoName: videoURlUpload.name) { [weak self] (isUploaded, path, error) in
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
            guard let `self` = self else {return}
            if let err = error {
                print("ERROR : \(err.localizedDescription)")
                AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
            } else if isUploaded{
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        if let completionBlock = completion {
                            completionBlock(path, thumbUrl, nil)
                        }
                    }
                }
            } else {
                AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
            }
        }
    }
    
    func uploadGif(thumbUrl : String, completion : completionBlock?){
        let url = activeUploads.count == 0 ? activeUploads[0].localPath : activeUploads[activeUploads.count - 1].localPath
        AWSHelper.shared.uploadVideo(video: url, videoPath: gifURlUpload.path, videoName: gifURlUpload.name) { [weak self] (isUploaded, path, error) in
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
            guard let `self` = self else {return}
            if let err = error {
                print("ERROR : \(err.localizedDescription)")
                AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
            } else if isUploaded{
                DispatchQueue.main.async {
                    DispatchQueue.main.async {
                        if let completionBlock = completion {
                            completionBlock(path, thumbUrl, nil)
                        }
                    }
                }
            } else {
                AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
            }
        }
    }
}

