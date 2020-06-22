//
//  ViewController.swift
//  Custom Camera
//
//  Created by Rudra Jikadra on 08/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

struct MediaData {
    var mediaType: MediaType = .image
    var uID: String = ""
    var img: UIImage?
    var thumbImg: UIImage?
    var videoURL: URL?
    var isUploaded: Bool = false
    var fileSize: Double = 0.0 //in MB
    
    
    var maximumVideoSize: Double = 10//inMB
    
    /// video data Path/Name
    var videoURlUpload: (path: String, name: String) {
        let folderName = story
        let timeStamp = Date().currentTimeMillis()
        let videoExtension = ".mp4"
        let path = "\(folderName)\(timeStamp)\(videoExtension)"
        return (path: path, name: "\(timeStamp)\(videoExtension)")
    }
    
    /// video-thumb image data Path/Name
    var thumbURlUpload: (path: String, name: String) {
        let folderName = story
        let timeStamp = Date().currentTimeMillis()
        let imgExtension = ".jpeg"
        let path = "\(folderName)\(timeStamp)\(imgExtension)"
        return (path: path, name: "\(timeStamp)\(imgExtension)")
    }
    
    /// image data Path/Name
    var mediaImgName: (path: String, name: String) {
        let folderName = story
        let timeStamp = Date().currentTimeMillis()
        let imgExtension = ".jpeg"
        let path = "\(folderName)\(timeStamp)\(imgExtension)"
        return (path: path, name: "\(timeStamp)\(imgExtension)")
    }
    
    /// dictionary with media data
    var dictForAPI: [String:Any] {
        if mediaType == .image {
            return ["type": mediaType.rawValue, "image": mediaImgName.path]
        } else {
            return ["type": mediaType.rawValue, "video": videoURlUpload.path, "thumb": thumbURlUpload.path]
        }
    }
}

struct PostData {
    
    var txStory: String = ""
    var tiStoryType: String = ""
    var vThumbnail : String = ""
    var arrMedia: [MediaData]!
    var postMediaType: MediaType = .image
    var maximumVideoSize: Double = 10//inMB
}

class ViewController: UIViewController {

    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var innerView: UIView!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var frontbackCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    var movieFileOutput = AVCaptureMovieFileOutput()
    
    var image:UIImage?
    var objPostData = PostData()
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.isNavigationBarHidden = true
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.innerView.cornerRadius = self.innerView.w/2
        self.innerView.backgroundColor = .white
        self.objPostData.arrMedia = []
        self.setupCaptureSession()
    }
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
//        self.innerView.cornerRadius = self.innerView.w/2
//        self.innerView.backgroundColor = .white
        captureSession.addOutput(movieFileOutput)
        movieFileOutput.maxRecordedDuration = CMTime(seconds: 30, preferredTimescale: 600)
        let longPressGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(handleLongPress))
        self.btnCamera.addGestureRecognizer(longPressGesture);
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices{
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }else if device.position == AVCaptureDevice.Position.front{
                frontCamera = device
            }
        }
        currentCamera = backCamera
    }
 
    func setupInputOutput() {
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
          if #available(iOS 11.0, *) {
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format:[AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
          } else {
            // Fallback on earlier versions
          }
            captureSession.addOutput(photoOutput!)
        } catch {
            print(error)
        }
    }
    
    func setupPreviewLayer() {
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    
    func startRunningCaptureSession() {
        captureSession.startRunning()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cameraButtonTouch(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
        //performSegue(withIdentifier: "showPhotos", sender: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhotos" {
            let previewVC = segue.destination as! PreviewViewController
            previewVC.image = self.image
            previewVC.objPostData = self.objPostData
        }
    }
  
    @IBAction func cancelButtonTouch(_ sender: Any) {
        self.popVC()
    }
    
  @IBAction func actionchangeCamrePosition(_ sender: Any) {
      //Change camera source
    if let session:AVCaptureSession = captureSession {
          //Remove existing input
          guard let currentCameraInput: AVCaptureInput = session.inputs.first else {
              return
          }

          //Indicate that some changes will be made to the session
          session.beginConfiguration()
          session.removeInput(currentCameraInput)

          //Get new input
          var newCamera: AVCaptureDevice! = nil
          if let input = currentCameraInput as? AVCaptureDeviceInput {
              if (input.device.position == .back) {
                  newCamera = cameraWithPosition(position: .front)
              } else {
                  newCamera = cameraWithPosition(position: .back)
              }
          }

          //Add input to session
          var err: NSError?
          var newVideoInput: AVCaptureDeviceInput!
          do {
              newVideoInput = try AVCaptureDeviceInput(device: newCamera)
          } catch let err1 as NSError {
              err = err1
              newVideoInput = nil
          }

          if newVideoInput == nil || err != nil {
              print("Error creating capture device input: \(err?.localizedDescription)")
          } else {
              session.addInput(newVideoInput)
          }

          //Commit all the configuration changes at once
          session.commitConfiguration()
      }
  }

     @IBAction func actionOpenGallary(_ sender: Any) {
        self.openMediaTypeActionSheet()
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {

        let maxDuration = CMTime(seconds: 30, preferredTimescale: 600)
        movieFileOutput.maxRecordedDuration = maxDuration
        self.innerView.backgroundColor = .red
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            debugPrint("long press started")
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
            let filePath = documentsURL.appendingPathComponent("tempMovie.mp4")
            if FileManager.default.fileExists(atPath: filePath.absoluteString) {
                do {
                    try FileManager.default.removeItem(at: filePath)
                }
                catch {
                }
            }
            movieFileOutput.startRecording(to: filePath, recordingDelegate: self)
        }
        else if gestureRecognizer.state == UIGestureRecognizer.State.ended {
            debugPrint("longpress ended")
            if movieFileOutput.recordedDuration <= movieFileOutput.maxRecordedDuration {
                movieFileOutput.stopRecording()
            }
        }
    }
    
  // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
  func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
      let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
      for device in discoverySession.devices {
          if device.position == position {
              return device
          }
      }
      return nil
  }
}
@available(iOS 11.0, *)
extension ViewController: AVCapturePhotoCaptureDelegate {
   
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
        
          let searchVC:PreviewViewController = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
            var objMedia = MediaData()
            objMedia.img = image
            if self.objPostData.arrMedia == nil {
                self.objPostData.arrMedia = []
            }
            objMedia.uID = "\(self.objPostData.arrMedia.count)"
            self.objPostData.tiStoryType = "0"
            self.objPostData.arrMedia.append(objMedia)
            searchVC.image = self.image
            searchVC.objPostData = self.objPostData
            self.pushVC(searchVC)
        }
    }
}
extension ViewController : AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        guard let videoURL = outputFileURL as? URL, let videoDataSize = videoURL.getVideoData(), Double(videoDataSize.count / 1048576) <= objPostData.maximumVideoSize else {
            return
        }
        let previewVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.PreviewViewScreen) as! PreviewViewController
        var objMedia = MediaData()
        objMedia.fileSize = Double(videoDataSize.count / 1048576)//in MB
        objMedia.mediaType = .video
        objMedia.thumbImg = generateThumb(from: videoURL)
        objMedia.videoURL = videoURL
        if self.objPostData.arrMedia == nil {
            self.objPostData.arrMedia = []
        }
        objMedia.uID = "\(self.objPostData.arrMedia.count)"
        self.objPostData.tiStoryType = "1"
        self.objPostData.arrMedia.append(objMedia)
        
        previewVC.objPostData = self.objPostData
        self.pushVC(previewVC)
    }
}
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openMediaTypeActionSheet() {
        let photo = "Photo"
        let video = "Video"
        let cancel = "Cancel"
        
            let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: photo, style: .default, handler: { _ in
               self.objPostData.postMediaType = .image
                self.openLibrary()
            }))
            
            alert.addAction(UIAlertAction(title: video, style: .default, handler: { _ in
                self.objPostData.postMediaType = .video
                self.openLibrary()
            }))
            
            alert.addAction(UIAlertAction.init(title: cancel, style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        photoLibraryAccess { [weak self] (status, isGrant) in
            guard let `self` = self else {return}
            if isGrant {
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                    self.imagePicker = UIImagePickerController()
                    self.imagePicker.delegate = self
                    if self.objPostData.postMediaType == .video {
                        self.imagePicker.mediaTypes = [kUTTypeMovie as String, kUTTypeVideo as String]
                        self.imagePicker.videoMaximumDuration = 30
                    }
                    self.imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if objPostData.postMediaType == .image {
            if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                var objMedia = MediaData()
                objMedia.img = image
                if self.objPostData.arrMedia == nil {
                    self.objPostData.arrMedia = []
                }
                objMedia.uID = "\(self.objPostData.arrMedia.count)"
                self.objPostData.tiStoryType = "0"
                self.objPostData.arrMedia.append(objMedia)
            }
        } else {
            
            guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL, let videoDataSize = videoURL.getVideoData(), Double(videoDataSize.count / 1048576) <= objPostData.maximumVideoSize else {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            var objMedia = MediaData()
            objMedia.fileSize = Double(videoDataSize.count / 1048576)//in MB
            objMedia.mediaType = objPostData.postMediaType
            objMedia.thumbImg = generateThumb(from: videoURL)
            objMedia.videoURL = videoURL
            if self.objPostData.arrMedia == nil {
                self.objPostData.arrMedia = []
            }
            objMedia.uID = "\(self.objPostData.arrMedia.count)"
            self.objPostData.tiStoryType = "1"
            self.objPostData.arrMedia.append(objMedia)
        }
        print(self.objPostData)
        let previewVC = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: GeekMeets_ViewController.PreviewViewScreen) as! PreviewViewController
        previewVC.image = self.image
        previewVC.objPostData = self.objPostData
        self.pushVC(previewVC)
    }
    
    func generateThumb(from videoURL: URL) -> UIImage? {
        return videoURL.getVideoThumbImage()
    }
}
