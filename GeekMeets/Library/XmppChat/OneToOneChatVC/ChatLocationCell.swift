//
//  ChatDocumentCell.swift
//  xmppchat
//
//  Created by SOTSYS255 on 23/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//
import UIKit
import MapKit

class ChatLocationCell: UITableViewCell {

    static let reuserID_Outgoing: String = "OutgoingLocation"
    static let reuserID_Incoming: String = "IncomingLocation"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewUploadContainer: UIView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblMsgStatus: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var chatBubbleView: ChatBubbleView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var BtnView: UIStackView!
    @IBOutlet weak var resendView: UIView!
    @IBOutlet weak var stackViewHeightConstant: NSLayoutConstraint!
    
    var chatMsgObj: Model_ChatMessage?
    weak var delegate: ProtocolChatMessageRetry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
//        self.BtnView.customize(backgroundColor: #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.5), radiusSize: 5.0)
    }

    @IBAction func retryBtnAction(_ sender: UIButton) {
        self.BtnView.alpha = 0.0
        guard let chatMsg = self.chatMsgObj else { return }
        self.delegate?.RetryBtnPressed(for: chatMsg)
    }
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        if self.BtnView.alpha == 0.0 {
            self.BtnView.alpha = 1.0
        } else {
            self.BtnView.alpha = 0.0
        }
    }
    
    @IBAction func unsendBtnAction(_ sender: UIButton) {
        self.BtnView.alpha = 0.0
        guard let chatMsg = self.chatMsgObj else { return }
        self.delegate?.UnsendBtnPressed(for: chatMsg)
    }
    
    func ConfigureCell(with chatMsg: Model_ChatMessage) {
        self.chatMsgObj = chatMsg
        if chatMsg.isOutgoing {
//            if self.chatMsgObj!.msgStatus != 1 && self.chatMsgObj!.msgStatus != 2 && self.chatMsgObj!.msgStatus != 3 {
                self.BtnView.customize(backgroundColor: #colorLiteral(red: 0.7490196078, green: 0.75, blue: 0.75, alpha: 0.3), radiusSize: 5.0, isSend: false)
                self.stackViewHeightConstant.constant = 40
//            } else {
//                self.BtnView.removeArrangedSubview(resendView)
//                self.stackViewHeightConstant.constant = 20
//                self.resendView.alpha = 0.0
//                self.BtnView.customize(backgroundColor: #colorLiteral(red: 0.75, green: 0.75, blue: 0.75, alpha: 0.5), radiusSize: 5.0, isSend: true)
//            }
        }
        
        lblDateTime.text = ST_DateFormater.GetTime(from: chatMsg.timestamp)
        setLocationOnMap()
        if chatMsg.isOutgoing {
            self.setDeliverAndReadStatus()
            self.chatBubbleView.layer.roundCorners([.topLeft, .bottomRight, .bottomLeft], radius: 10)
        } else {
            self.chatBubbleView.layer.roundCorners([.topRight, .bottomRight, .bottomLeft], radius: 10)
        }
    }
    
    private func setDeliverAndReadStatus() {
        
        guard let chatMsg = self.chatMsgObj else { return }
        
//        switch chatMsg.msgStatus {
//        case 1:
//            lblMsgStatus.text = "✓"
//            lblMsgStatus.textColor = .black; break
//        case 2:
//            lblMsgStatus.text = "✓✓"
//            lblMsgStatus.textColor = .black; break
//        case 3:
//            lblMsgStatus.text = "✓✓"
//            lblMsgStatus.textColor = .green; break
//        default:
//            lblMsgStatus.text = "Sending..."
//            lblMsgStatus.textColor = .black
//        }
        
        if chatMsg.isError {
            viewUploadContainer.isHidden = false
            activityIndicator.stopAnimating()
            btnRetry.isHidden = false
            
        } else if chatMsg.isUploading {
            viewUploadContainer.isHidden = false
            activityIndicator.startAnimating()
            btnRetry.isHidden = true
        } else {
            viewUploadContainer.isHidden = true
            btnRetry.isHidden = true
        }
        
    }
    
    private func setLocationOnMap() {
        viewUploadContainer.isHidden = true
        activityIndicator.stopAnimating()
        let regionRadius: CLLocationDistance = 1000
        let latStr = self.chatMsgObj?.strMsg?.split(",").first
        let lonStr = self.chatMsgObj?.strMsg?.split(",").last
        print("\(latStr) \(lonStr)")
        
        if latStr != nil && lonStr != nil {
            let Location = CLLocationCoordinate2D(latitude: Double(latStr!)!, longitude:  Double(lonStr!)!)
            let viewRegion = MKCoordinateRegion(center: Location, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
