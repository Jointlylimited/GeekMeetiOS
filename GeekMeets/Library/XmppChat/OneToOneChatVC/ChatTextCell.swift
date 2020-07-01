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
    
    var chatMsgObj: Model_ChatMessage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func ConfigureCell(with chatMsg: Model_ChatMessage) {
        
        self.chatMsgObj = chatMsg
        
        lblMsg.text = chatMsg.strMsg
        lblDateTime.text = ST_DateFormater.GetTime(from: chatMsg.timestamp)
        
        if chatMsg.isOutgoing {
            self.setDeliverAndReadStatus()
        }
        
    }
    
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
