//
//  PreviewInteractor.swift
//  GeekMeets
//
//  Created by SOTSYS124 on 04/06/20.
//  Copyright (c) 2020 SOTSYS203. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

typealias uploadCompletion = (_ isUploaded: Bool) -> ()

struct CreatePostData {
    
    /// dictionary with media data
    var dictForAPI = [[String:Any]]()
    
    var jsonString: String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: dictForAPI, options: [])
            return String(data: data, encoding: .utf8)!
        } catch {
            return nil
        }
    }
    
    /// convert array of dictionary to string for API
    ///
    /// - Parameter array: array to dictionary
    /// - Returns: string of dictionary array
    func toJSON(array: [[String: Any]]) -> String? {
        do {
            let data = try JSONSerialization.data(withJSONObject: array, options: [])
            return String(data: data, encoding: .utf8)!
        } catch {
            return nil
        }
    }
}

protocol PreviewInteractorProtocol {
    
   func addPostAPICall(with obj: PostData)
}

protocol PreviewDataStore {
    //var name: String { get set }
}

class PreviewInteractor: PreviewInteractorProtocol, PreviewDataStore {
    var presenter: PreviewPresentationProtocol?
    var objPost: PostData!
    var objCreatePostData = CreatePostData()
    
    
    func addPostAPICall(with obj: PostData) {
           objPost = obj
           if obj.arrMedia == nil || obj.arrMedia.isEmpty {
               callPostStoryAPI(obj: objPost)
           } else {
               uploadPostData(from: 0)
           }
       }
    
      func uploadPostData(from index: Int) {
          if index == 0 || index <= objPost.arrMedia.count - 1 { // if uploading index contains element in array media
              let objMedia = objPost.arrMedia[index]
              if objMedia.mediaType == .image {
                  //upload image to AWS
                  uploadImgOrVideoThumbToS3(with: objMedia, videoPath: nil) { [weak self] (isUploaded) in
                      guard let `self` = self else {return}
                      if isUploaded {
                          self.objPost.arrMedia[index].isUploaded = isUploaded
                          self.uploadPostData(from: index + 1)
                      } else {
                          print("ERROR  : error while uploading \(objMedia.mediaImgName.name)")
                        AppSingleton.sharedInstance().showAlert("Uploading failed", okTitle: "OK")
                      }
                  }
              } else {
                  //upload video & video-thumb to AWS
                  compressVideoToUpload(with: objMedia) { [weak self] (isUploaded) in
                      guard let `self` = self else {return}
                      if isUploaded {
                          self.uploadPostData(from: index + 1)
                      } else {
                          print("ERROR  : error while uploading \(objMedia.videoURlUpload.name)")
                        AppSingleton.sharedInstance().showAlert("Uploading failed", okTitle: "OK")
                      }
                  }
              }
              print("---------- uploaded object ----------- \n \(objMedia)")
          } else { //all media has been uploaded -- it's time to call api to create post
            callPostStoryAPI(obj: objPost)
          }
      }
      
    
      
      func compressVideoToUpload(with obj: MediaData, uploaded: @escaping uploadCompletion) {
          guard let url = obj.videoURL else {
            AppSingleton.sharedInstance().showAlert("currupted media", okTitle: "OK")
              return
          }
          compressAndConvertVideo(from: url, by: obj.maximumVideoSize) { [weak self] (url) in
              guard let `self` = self else {return}
              if let compresedAndConvertedURL = url {
                  self.uploadVideoToAWS(with: compresedAndConvertedURL, objMedia: obj, uploaded: uploaded)
              } else {
                AppSingleton.sharedInstance().showAlert("video compression error", okTitle: "OK")
              }
          }
      }
      
      func uploadVideoToAWS(with compresedVideoURL: URL, objMedia: MediaData, uploaded: @escaping uploadCompletion) {
          AWSHelper.setup()
          DispatchQueue.main.async {
              LoaderView.sharedInstance.showLoader()
          }
          AWSHelper.shared.uploadVideo(video: compresedVideoURL, videoPath: objMedia.videoURlUpload.path, videoName:  objMedia.videoURlUpload.name) { [weak self] (isUploaded, path, error) in
              DispatchQueue.main.async {
                  LoaderView.sharedInstance.hideLoader()
              }
              guard let `self` = self else {return}
              if let err = error {
                  print("ERROR : \(err.localizedDescription)")
                AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
              } else if isUploaded{
                  self.objPost.txStory = path!.split("/").last!
                  self.uploadImgOrVideoThumbToS3(with: objMedia, videoPath: path, uploaded: uploaded)
              } else {
                  AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
              }
          }
      }
      
      func uploadImgOrVideoThumbToS3(with obj: MediaData, videoPath: String?, uploaded: @escaping uploadCompletion) {
          let imageToUpload: UIImage? = obj.mediaType == .image ? obj.img : obj.thumbImg
          guard let img = imageToUpload else {
              AppSingleton.sharedInstance().showAlert("currupted media", okTitle: "OK")
              return
          }
          let compressedImage = img.scaleAndManageAspectRatio(_maxImageSize.width)
          DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
          }
          AWSHelper.setup()
          let imgPath = obj.mediaType == .image ? obj.mediaImgName.path : obj.thumbURlUpload.path
          let imgName = obj.mediaType == .image ? obj.mediaImgName.name : obj.thumbURlUpload.name
          AWSHelper.shared.upload(img: compressedImage, imgPath: imgPath, imgName: imgName) { (isUploaded, path, error) in
              DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
              }
              if let err = error {
                  print("ERROR : \(err.localizedDescription)")
                AppSingleton.sharedInstance().showAlert(err.localizedDescription, okTitle: "OK")
              } else if isUploaded , let imgPath = path {
                  var dict: [String:Any] = [:]
                  if obj.mediaType == .image {

                    self.objPost.txStory = imgPath.split("/").last!
                      dict = ["type": obj.mediaType.rawValue, "image": imgPath]
                  } else {
                      let videoPath = videoPath ?? ""
                     dict = ["type": obj.mediaType.rawValue, "video": videoPath, "thumb": imgPath]
//                    self.objPost.txStory = videoPath.split("/").last!
                    self.objPost.vThumbnail = imgPath.split("/").last!
                  }
                  self.objCreatePostData.dictForAPI.append(dict)
                  uploaded(isUploaded)
              } else {
                 AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
              }
          }
      }
    
    // MARK: Do something
    func callPostStoryAPI(obj : PostData){
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        if obj.tiStoryType == "1" {
            MediaAPI.createStory(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, txStory: self.objPost.txStory, tiStoryType: obj.tiStoryType, vThumbnail: self.objPost.vThumbnail) { (response, error) in
                
                delay(0.2) {
                    LoaderView.sharedInstance.hideLoader()
                }
                if response?.responseCode == 200 {
                    self.presenter?.getPostStoryResponse(response: response!)
                } else if response?.responseCode == 203 {
                    AppSingleton.sharedInstance().logout()
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                } else if response?.responseCode == 400 {
                    self.presenter?.getPostStoryResponse(response: response!)
                }  else {
                    if error != nil {
                        AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                    } else {
                        self.presenter?.getPostStoryResponse(response: response!)
                    }
                }
            }
        } else {
            MediaAPI.createStory(nonce: authToken.nonce, timestamp: authToken.timeStamp, token: authToken.token, authorization: UserDataModel.authorization, txStory: self.objPost.txStory, tiStoryType: obj.tiStoryType) { (response, error) in
                
                delay(0.2) {
                    LoaderView.sharedInstance.hideLoader()
                }
                if response?.responseCode == 200 {
                    self.presenter?.getPostStoryResponse(response: response!)
                } else if response?.responseCode == 203 {
                    AppSingleton.sharedInstance().logout()
                    AppSingleton.sharedInstance().showAlert((response?.responseMessage!)!, okTitle: "OK")
                } else if response?.responseCode == 400 {
                    self.presenter?.getPostStoryResponse(response: response!)
                }  else {
                    if error != nil {
                        AppSingleton.sharedInstance().showAlert(kSomethingWentWrong, okTitle: "OK")
                    } else {
                        self.presenter?.getPostStoryResponse(response: response!)
                    }
                }
            }
        }
    }
}

// MARK: - video compression
extension PreviewInteractor {
    
    func compressAndConvertVideo(from videoURL: URL, by maxSize: Double, compressURL: @escaping ((_ videoURL: URL?)->())){
        self.compressVideoForUpload(videoURL: videoURL, compltion: { (videoURL,videoSize) in
            print("compressed \(String(describing: videoURL))")
            if let vURL = videoURL, videoSize <= maxSize {
                compressURL(vURL)
            } else {
                AppSingleton.sharedInstance().showAlert("Selected video is larger then expected please upload video with size upto \(maxSize)", okTitle: "OK")
            }
        })
    }
    
    /// compress video and convert video into .mp4 to upload it to server
    ///
    /// - Parameter videoURL: selected / recorded video URL
    func compressVideoForUpload(videoURL : URL, compltion: @escaping ((_ videoURL: URL?,_ videoSize: Double)->())) {
        let videoCompressedURL = URL(fileURLWithPath: NSTemporaryDirectory() + "compressedSocialPost.mp4")
        videoCompressedURL.checkAndDeleteVideoFile()
        DispatchQueue.main.async {
            LoaderView.sharedInstance.showLoader()
        }
        videoURL.compressVideo(videoCompressedURL) { (exportSession, compressedURL) in
            DispatchQueue.main.async {
                LoaderView.sharedInstance.hideLoader()
            }
            guard let session = exportSession else {
                return
            }
            switch session.status {
            case .unknown:
                break
            case .waiting:
                break
            case .exporting:
                break
            case .completed:
                guard let compressedData = compressedURL!.getVideoData() else {
                    return
                }
                let fileSize = Double(compressedData.count / 1048576)
                print("File size after compression: \(fileSize) mb")
                //API call to upload video to server
                return compltion(compressedURL, fileSize)
            case .failed:
                AppSingleton.sharedInstance().showAlert(session.error?.localizedDescription ?? "Error while upload video", okTitle: "OK")
                print(session.error?.localizedDescription ?? "Error while upload video")
                videoCompressedURL.checkAndDeleteVideoFile()
                break
            case .cancelled:
                AppSingleton.sharedInstance().showAlert(session.error?.localizedDescription ?? "Error while upload video", okTitle: "OK")
                print(session.error?.localizedDescription ?? "Error while upload video")
                videoCompressedURL.checkAndDeleteVideoFile()
                break
            }
        }
    }
    
}
