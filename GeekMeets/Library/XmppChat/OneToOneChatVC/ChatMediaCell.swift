//
//  ChatMediaCell.swift
//  xmppchat
//
//  Created by SOTSYS255 on 29/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProtocolChatMessageRetry: class {
    func RetryBtnPressed(for objChat: Model_ChatMessage)
}

class ChatMediaCell: UITableViewCell {

    static let reuseID_Incoming: String = "ChatMedia_Incoming"
    static let reuseID_Outgoing: String = "ChatMedia_Outgoing"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewUploadContainer: UIView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var imgVideoPreview: UIImageView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblMsgStatus: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
   
    @IBOutlet weak var imgAvatarView: UIImageView!
    
    var chatMsgObj: Model_ChatMessage?
    weak var delegate: ProtocolChatMessageRetry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    
    @IBAction func retryBtnAction(_ sender: UIButton) {
        guard let chatMsg = self.chatMsgObj else { return }
        self.delegate?.RetryBtnPressed(for: chatMsg)
    }
    
    func ConfigureCell(with chatMsg: Model_ChatMessage) {
        
        self.chatMsgObj = chatMsg
        
        lblDateTime.text = ST_DateFormater.GetTime(from: chatMsg.timestamp)
        imgView.image = nil
        
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
        
        if chatMsg.isOutgoing {
            self.setDeliverAndReadStatus()
        }
        
        if chatMsg.msgType! == XMPP_Message_Type.video.rawValue {
            imgVideoPreview.isHidden = false
            self.setMediaVideoThumnail()
        } else {
            imgVideoPreview.isHidden = true
            self.setMediaImage()
        }
        
    }
    
    
    private func setMediaImage() {
       
        guard let chatMsg = self.chatMsgObj else { return }
        
        if let _url = chatMsg.getLocalPath() {
            imgView.sd_setImage(with: _url, placeholderImage: nil, options: [.scaleDownLargeImages], context: nil)
        } else {
            
            if chatMsg.isError {
                return
            }
            viewUploadContainer.isHidden = false
            activityIndicator.startAnimating()
            let url =  URL.init(string:"\(fileUploadURL)\(chatMsg.url)")
            imgView.sd_setImage(with: url, placeholderImage: nil, options: [.scaleDownLargeImages], context: nil, progress: { (value1, value2, _url) in
            }) { (img, error, catchTyp, _url) in
                self.viewUploadContainer.isHidden = true
            }
        }
        
    }//
    
    private func setMediaVideoThumnail() {
        
        guard let chatMsg = self.chatMsgObj else { return }
        
        if chatMsg.isError {
            return
        }
        
        viewUploadContainer.isHidden = false
        activityIndicator.startAnimating()
        
        if let _url = chatMsg.getThumbLocalPath() {
            
            imgView.sd_setImage(with: _url, placeholderImage: nil, options: [.scaleDownLargeImages], context: nil)
            
            if chatMsg.url.count > 0 {
                 self.viewUploadContainer.isHidden = true
            }
        }
        
        
    }//
    
    private func setDeliverAndReadStatus() {
        
        guard let chatMsg = self.chatMsgObj else { return }
        
        switch chatMsg.msgStatus {
        case 1:
            lblMsgStatus.text = "✓"
            lblMsgStatus.textColor = .white; break
        case 2:
            lblMsgStatus.text = "✓✓"
            lblMsgStatus.textColor = .white; break
        case 3:
            lblMsgStatus.text = "✓✓"
            lblMsgStatus.textColor = .green; break
        default:
            lblMsgStatus.text = "Sending..."
            lblMsgStatus.textColor = .white
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

