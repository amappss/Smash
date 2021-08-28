//
//  SocketServices.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/3/21.
//

import Foundation
import SocketIO
class SocketServices: NSObject {

    static let instance = SocketServices()
    let manager = SocketManager(socketURL: URL(string:baseUrl)!, config: [.log(false),.compress])
    var socket :SocketIOClient?
    var channelDelegate:ChannelManagerDelegate?
    var chatDelegate:ChatManagerDelegate?
    var typingUsers:[String]?
    
    override init() {
        super.init()
        socket = manager.defaultSocket
        
        socket?.on(clientEvent: .connect) { (data, ack) in
            print("connected to socket")
        }
        
        socket?.on("channelCreated") { (channelArray, ack) in
            guard let name = channelArray[0] as? String else { return }
            guard let description = channelArray[1] as? String else { return }
            guard let id = channelArray[2] as? String else { return }
        let channel = Channel(_id: id, description: description, name: name)
            MessageService.instance.channels.append(channel)
            self.channelDelegate?.didRecievedChannel()
        }
        
        socket?.on("userTypingUpdate", callback: {( dataArray, ack) in
            self.typingUsers = []

            if let typingUserDic = dataArray[0] as? [String:String] {
                for (typingUser,channelId) in typingUserDic{
                    if MessageService.instance.selectedChannel?._id == channelId{
                        if AuthService.instance.userData.username != typingUser{
                            self.typingUsers?.append(typingUser)
                        }
  
                    }
                }
            }
            NotificationCenter.default.post(name:NOTI_USER_TYPING_CHANGED, object: nil)
        })
        
        socket?.on("messageCreated", callback: {(dataArray,ack) in
//            guard let dataArray = dataArray as? Dictionary<Int,String> else { return}
//            let message = Message(id: dataArray[6]!, body: dataArray[0]!, channelId: dataArray[2]!, userId: dataArray[1]!, userName: dataArray[3]!, avatar: dataArray[4]!, avatarColor: dataArray[5]!)
//            MessageService.instance.addMessage(message: message)
            if let channelId = dataArray[2] as? String{
                if !MessageService.instance.unreadChannels.contains(channelId) && MessageService.instance.selectedChannel?._id != channelId{
                    MessageService.instance.unreadChannels.append(channelId)
                }
            }
            print(MessageService.instance.unreadChannels)
            NotificationCenter.default.post(name: NOTI_CHANNEL_SELECTED, object: nil)
        })
        
        
        socket?.connect()
    }
        
    func addChannel(channel:Channel){
        socket?.emit("newChannel", channel.name!,channel.description!)
    }
    
    func sendMessage(content:String,user:User,channelId:String){
        socket?.emit("newMessage", content,user.id!,channelId,user.username!,user.avatarName!,user.avatarColor!)
    }
    
    func setIsTyping(username:String,channelId:String){
        socket?.emit("startType", username,channelId)
    }
    
    func setIsNotTyping(username:String){
        socket?.emit("stopType", username)
    }
    
    
    func closeConnection(){
        socket?.removeAllHandlers()
        socket?.disconnect()
    }

}
