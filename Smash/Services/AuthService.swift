//
//  AuthService.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/31/21.
//

import Foundation
import Alamofire
import SwiftyJSON
class AuthService {
    
    static let instance = AuthService()
    
    init() {
        if isLoggedIn{
            userData.id = id
            userData.email = email
            userData.username = username
            userData.avatarColor = avatarColor
            userData.avatarName = avatarName
        }
    }
    
    let userDefaults = UserDefaults.standard
    
    var userData :User = User()
    
    var isLoggedIn :Bool {
        get {
            return userDefaults.bool(forKey: LOGGED_KEY)
        }
        set{
            userDefaults.set(newValue, forKey: LOGGED_KEY)
        }
    }
    
    private var id :String{
        get{
            return userDefaults.string(forKey: ID_KEY) ?? ""
        }
        set{
            userDefaults.set(newValue, forKey: ID_KEY)
        }
    }
    
    private var email :String{
        get{
            return userDefaults.string(forKey: EMAIL_KEY)!
        }
        set{
            userDefaults.set(newValue, forKey: EMAIL_KEY)
        }
    }
    
    private var username :String{
        get{
            return userDefaults.string(forKey: USER_KEY)!
        }
        set{
            userDefaults.set(newValue, forKey: USER_KEY)
        }
    }
    
    private var avatarColor :String{
        get{
            return userDefaults.string(forKey: AVCOLOR_KEY)!
        }
        set{
            userDefaults.set(newValue, forKey: AVCOLOR_KEY)
        }
    }
    
    private var avatarName :String{
        get{
            return userDefaults.string(forKey: AVIMG_KEY)!
        }
        set{
            userDefaults.set(newValue, forKey: AVIMG_KEY)
        }
    }
    var auth :String{
        get{
            return userDefaults.string(forKey: AUTH_KEY) ?? ""
        }
        set{
            userDefaults.set(newValue, forKey: AUTH_KEY)
        }
    }
    
    func registerUser(user:User,completion: @escaping CompletionHandler){
        
       
        let body = [
            "email":user.email,
            "password":user.password
        ]
        
        AF.request(registerUrl, method: .post, parameters: body as Parameters, encoding:JSONEncoding.default, headers: header).responseString { response in
            if(response.error == nil){
                completion(true)
            }else{
                debugPrint(response.error as Any)
                completion(false)
            }
        }
    }
    
    func loginUser(user:User,completion: @escaping CompletionHandler){
        let body = [
            "email":user.email,
            "password":user.password
        ]
        
        AF.request(loginUrl, method: .post, parameters: body as Parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if(response.error == nil){
                if let data = response.data{
                    do{
                        print(data)
                        let json = try JSON(data:data)
                        self.email = json["user"].stringValue
                        self.auth = json["token"].stringValue
                        self.isLoggedIn = true
                    }catch  {
                        
                    }
                    
                    completion(true)

                }
                completion(false)
            }else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func findUser(completion: @escaping CompletionHandler){

        AF.request(Smash.findUserUrl(email: email), method: .get, headers: authHeader).responseJSON { (response) in
            if response.error == nil{
                do{
                    if let data = response.data{
                    let json = try JSON(data: data)
                        let id = json["_id"].stringValue
                        let username = json["name"].stringValue
                        let avColor = json["avatarColor"].stringValue
                        let avName = json["avatarName"].stringValue
                        self.id = id
                        self.username = username
                        self.avatarColor = avColor
                        self.avatarName = avName
                        self.setCurrentUser()
                }
                completion(true)
                }catch{
                completion(false)
                }
            }else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
    }
    
    func setCurrentUser(){
        let user = User()
        user.id = id
        user.email = email
        user.username = username
        user.avatarColor = avatarColor
        user.avatarName = avatarName
        userData = user
    }
    
    func logout(){
        isLoggedIn = false
        email = ""
        auth = ""
        username = ""
        id = ""
        userData = User()
        NotificationCenter.default.post(name: NOTI_USER_CHANGED,object:nil)
    }
    
    func createAccount(userData:User,completion: @escaping CompletionHandler){
        

        let body = [
            "name":userData.username,
            "email":userData.email,
            "avatarName":userData.avatarName,
            "avatarColor":userData.avatarColor
        ]
        
        AF.request(createUserUrl, method: .post, parameters: body as Parameters, encoding: JSONEncoding.default, headers: authHeader).responseJSON { (response) in
            if(response.error == nil){
                completion(true)
            }else{
                completion(false)
                debugPrint(response.error as Any)
            }
        }
        
    }

}
