//
//  ChannelCell.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/30/21.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCel(channels:[Channel],indexFor index:IndexPath){
        let channel = channels[index.row]
        channelLbl.text = "#\(channel.name!)"
        if MessageService.instance.unreadChannels.contains(channel._id){
            channelLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 23)
        }else{
            channelLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 21)
        }
        if MessageService.instance.selectedChannel?._id == channel._id{
            self.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.layer.backgroundColor = UIColor.white.withAlphaComponent(0.2).cgColor
        }else{
            self.layer.backgroundColor = UIColor.clear.cgColor
        }

    }
}
