//
//  ChatDocumentCell.swift
//  xmppchat
//
//  Created by SOTSYS255 on 23/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//
import UIKit

class ChatDocumentCell: UITableViewCell {

    static let reuserID_Outgoing: String = "OutgoingDocument"
    static let reuserID_Incoming: String = "OutgoingIncoming"
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewUploadContainer: UIView!
    @IBOutlet weak var activityIndicator : UIActivityIndicatorView!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblMsgStatus: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var chatBubbleView: ChatBubbleView!
    
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
        
        if chatMsg.isOutgoing {
            self.setDeliverAndReadStatus()
            self.chatBubbleView.layer.roundCorners([.topLeft, .bottomLeft, .bottomRight], radius: 10)
        } else {
            self.chatBubbleView.layer.roundCorners([.topRight, .bottomLeft, .bottomRight], radius: 10)
        }
    }
    
    private func setDeliverAndReadStatus() {
        
        guard let chatMsg = self.chatMsgObj else { return }
        
        switch chatMsg.msgStatus {
        case 1:
            lblMsgStatus.text = "✓"
            lblMsgStatus.textColor = .black; break
        case 2:
            lblMsgStatus.text = "✓✓"
            lblMsgStatus.textColor = .black; break
        case 3:
            lblMsgStatus.text = "✓✓"
            lblMsgStatus.textColor = .green; break
        default:
            lblMsgStatus.text = "Sending..."
            lblMsgStatus.textColor = .black
        }
        
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
