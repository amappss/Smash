//
//  DrawerVC.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/29/21.
//

import UIKit

class DrawerVC: UIViewController ,UITableViewDataSource,UITableViewDelegate,ChannelManagerDelegate{
    
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
        
    }

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var channelTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelTbl.delegate = self
        channelTbl.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidChangedObserver), name: NOTI_USER_CHANGED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateChannels), name: NOTI_CHANNEL_SELECTED, object: nil)
        setupUser()
        
        SocketServices.instance.channelDelegate = self
        
        
        channelTbl.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .none)
    }
    
    func didRecievedChannel() {
        channelTbl.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let channel = MessageService.instance.selectedChannel{
            guard let index = MessageService.instance.channels.firstIndex(where: {$0._id == channel._id}) else {return}
            channelTbl.selectRow(at: IndexPath(row:index , section: 0), animated: false, scrollPosition: .none)
        }
    }
    
    @objc func userDidChangedObserver(){
        setupUser()
    }
    
    @objc func updateChannels(){
        channelTbl.reloadData()
    }
    
    func setupUser(){
        if AuthService.instance.isLoggedIn{
            let userData = AuthService.instance.userData
            loginBtn.setTitle(userData.email, for: .normal)
            if let avColor = userData.avatarColor{
                profileImg.backgroundColor = ColorHelper.convertStringToColor(stringColor: avColor)
            }
            if let avName = userData.avatarName{
                profileImg.image = UIImage(named: avName)
            }
            MessageService.instance.getChannels { (state) in
                if MessageService.instance.channels.count > 0{
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    NotificationCenter.default.post(name: NOTI_CHANNEL_SELECTED, object: nil)
                    self.channelTbl.reloadData()
                }
            }
        }else{
            loginBtn.setTitle("LOGIN", for: .normal)
            profileImg.backgroundColor = .darkGray
            profileImg.image = UIImage(named: "profileDefault") 
        }
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        let channelModal = ChannelModal()
        channelModal.modalPresentationStyle = .custom
        present(channelModal, animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn{
            let profileModal = ProfileModal()
            profileModal.modalPresentationStyle = .custom
            present(profileModal, animated: true, completion: nil)
        }else{
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell") as? ChannelCell{
            cell.configureCel(channels: MessageService.instance.channels, indexFor: indexPath)
            return cell
        }else{
            return ChannelCell()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MessageService.instance.selectedChannel = MessageService.instance.channels[indexPath.row]
        unreadChannel(indexPath: indexPath)
        NotificationCenter.default.post(name: NOTI_CHANNEL_SELECTED, object: nil)
        self.revealViewController()?.revealToggle(animated: true)
    }
    
    func unreadChannel(indexPath:IndexPath){
        guard let channelId = MessageService.instance.channels[indexPath.row]._id else { return}
        MessageService.instance.removeChannelFromUnreadChannels(channelId: channelId)
        channelTbl.reloadRows(at: [indexPath], with: .automatic)
        
    }
}
