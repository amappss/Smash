//
//  MessageService.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/3/21.
//

import Foundation
import Alamofire
import SwiftyJSON
class MessageService{
    static let instance = MessageService()
    var channels = [Channel]()
    var selectedChannel:Channel?
    var messages = [Message]()
    var unreadChannels = [String]()
    func getChannels(completion:@escaping CompletionHandler){
        AF.request(channelsUrl,headers: authHeader).responseJSON { (response) in
            if response.error == nil{
                if let data = response.data{
                    do{
                        self.channels = try JSONDecoder().decode([Channel].self, from: data)
                        print(self.channels)
                    }catch let error{
                        print(error as Any)
                    }
                }
                completion(false)
            }else{
                print(response.error as Any)
                completion(false)
            }
        }
    }
    
    func addMessage(message:Message){
        messages.append(message)
    }
    
    func removeChannelFromUnreadChannels(channelId:String){
        if unreadChannels.contains(channelId){
            unreadChannels = unreadChannels.filter({ $0 != channelId})
        }
    }
    
    func getMessages(channelId:String,completion:@escaping CompletionHandler){
        messages = []
        AF.request(messagesUrl(channelId: channelId),headers: authHeader).responseJSON { (response) in
            if response.error == nil{
                if let data = response.data{
                    do{
                        guard let jsonArray = try JSON(data:data).array else { return}
                        for json in jsonArray{
                            let id = json["_id"].stringValue
                            let msgBody = json["messageBody"].stringValue
                            let userID = json["userId"].stringValue
                            let channelId = json["channelId"].stringValue
                            let userName = json["userName"].stringValue
                            let avatar = json["userAvatar"].stringValue
                            let avatarColor = json["userAvatarColor"].stringValue
                            let timestamp = json["timeStamp"].stringValue
                            self.messages.append(Message(id: id, body: msgBody, channelId: channelId, userId: userID, userName: userName, avatar: avatar, avatarColor: avatarColor, isoTimestamp: timestamp))
                        }
                        completion(true)
                    }catch let error{
                        debugPrint(error as Any)
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }
    }
}
