//
//  ViewController.swift
//  Custom Camera
//
//  Created by Rudra Jikadra on 08/12/17.
//  Copyright © 2017 Rudra Jikadra. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var frontbackCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image:UIImage?
    
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
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
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
        }
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
extension ViewController: AVCapturePhotoCaptureDelegate{
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            image = UIImage(data: imageData)
        
          let searchVC:PreviewViewController = GeekMeets_StoryBoard.Dashboard.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
          searchVC.image = image
            
          self.pushVC(searchVC)
//            performSegue(withIdentifier: "showPhotos", sender: nil)
        }
    }
}

