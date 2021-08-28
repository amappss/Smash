//
//  ChatCell.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/30/21.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var logoBkg: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!

    func setupChatCell(message:Message){
        logoImg.image = UIImage(named: message.avatar)
        logoImg.backgroundColor = ColorHelper.convertStringToColor(stringColor: message.avatarColor)
        nameLbl.text = message.userName
        messageLbl.text = message.body
        
        guard let index = message.isoTimestamp.firstIndex(of:".") else { return}
        let subTiming = String(message.isoTimestamp[..<index])
        
        let isoFormatter = ISO8601DateFormatter()
        guard let isoFormatted = isoFormatter.date(from: subTiming.appending("Z")) else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d,h:mm a"
        
        let formattedDate = dateFormatter.string(from: isoFormatted)
        
        dateLbl.text = formattedDate
    }

}
