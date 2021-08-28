//
//  ChatVC.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/29/21.
//

import UIKit

class ChatVC: UIViewController , UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{

    @IBOutlet weak var chatTbl: UITableView!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var menuBtn:UIButton!
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var isTypingLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindToKeyboard()
        
        chatTbl.dataSource = self
        chatTbl.delegate = self
        
        messageField.delegate = self
        
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.width - 65
        
        // Automatically setting the height
        chatTbl.estimatedRowHeight = 90
        chatTbl.rowHeight = UITableView.automaticDimension
        
        messageField.addTarget(self, action: #selector(messageFieldEditing(sender:)), for: .editingChanged)

        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected), name: NOTI_CHANNEL_SELECTED, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(typingUsersUpdated), name: NOTI_USER_TYPING_CHANGED, object: nil)
        
        if AuthService.instance.isLoggedIn{
            MessageService.instance.getChannels { (state) in
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.channelSelected()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell") as? ChatCell{
            let messaage = MessageService.instance.messages[indexPath.row]
            cell.setupChatCell(message: messaage)
            return cell
        }else{
            return ChatCell()
        }
    }
    
    @objc func messageFieldEditing(sender:UITextField){
        if AuthService.instance.isLoggedIn{
            if let text = messageField.text{
                guard let username = AuthService.instance.userData.username else { return}
                guard let channelId = MessageService.instance.selectedChannel?._id else { return}
                if text.count == 0{
                    SocketServices.instance.setIsNotTyping(username: username)
                }else{
                    SocketServices.instance.setIsTyping(username: username, channelId: channelId)
                }
            }
        }
    }
    
    @objc func typingUsersUpdated(){
            if AuthService.instance.isLoggedIn{
                guard let typingUsers = SocketServices.instance.typingUsers else { return}
                if typingUsers.count > 0{
                    let typingUsersString = typingUsers.count == 1 ? "\(typingUsers[0])" : typingUsers.joined(separator:", ")
                    isTypingLbl.text = "\(typingUsersString) \(typingUsers.count == 1 ? "is" : "are") typing ..."
                }else{
                    isTypingLbl.text = ""
                }
        }
    }
    
    @objc func  channelSelected(){
        if AuthService.instance.isLoggedIn{
            guard let channel = MessageService.instance.selectedChannel else { return }
            channelNameLbl.text = channel.name
            MessageService.instance.getMessages(channelId: channel._id) { (state) in
                if state == true{
                    self.chatTbl.reloadData()
                }
            }
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            guard let channel = MessageService.instance.selectedChannel else { return }
            guard let msgBody = messageField.text else { return}
            if msgBody == "" { return}
            SocketServices.instance.sendMessage(content: msgBody, user: AuthService.instance.userData, channelId: channel._id)
            messageField.text = ""
            messageField.resignFirstResponder()
        }
    }
}


