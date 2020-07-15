//
//  ChatTextCell.swift
//  xmppchat
//
//  Created by SOTSYS255 on 29/01/20.
//  Copyright © 2020 SOTSYS255. All rights reserved.
//

import UIKit

class ChatTextCell: UITableViewCell {

    static let reuseID_Incoming: String = "ChatText_Incoming"
    static let reuseID_Outgoing: String = "ChatText_Outgoing"
    
    @IBOutlet weak var lblMsg: UILabel!
    @IBOutlet weak var lblMsgStatus: UILabel!
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgAvatarView: UIImageView!
    @IBOutlet weak var chatBubbleView: ChatBubbleView!
    @IBOutlet weak var BtnView: UIStackView!
    
    var chatMsgObj: Model_ChatMessage?
    weak var delegate: ProtocolChatMessageRetry?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.BtnView.customize(backgroundColor: #colorLiteral(red: 0.7490196078, green: 0.75, blue: 0.75, alpha: 0.5), radiusSize: 5.0)
    }

    func ConfigureCell(with chatMsg: Model_ChatMessage) {
        self.chatMsgObj = chatMsg
        
        lblMsg.text = chatMsg.strMsg
        lblDateTime.text = ST_DateFormater.GetTime(from: chatMsg.timestamp)
        
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
////            lblMsgStatus.text = "✓"
////            lblMsgStatus.textColor = .white; break
//        case 2:
////            lblMsgStatus.text = "✓✓"
////            lblMsgStatus.textColor = .white; break
//        case 3:
////            lblMsgStatus.text = "✓✓"
////            lblMsgStatus.textColor = .green; break
//        default:
////            lblMsgStatus.text = "Sending..."
////            lblMsgStatus.textColor = .white
//        }
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
