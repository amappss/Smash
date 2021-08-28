//
//  Consts.swift
//  Smash
//
//  Created by Arsalan majlesi on 5/30/21.
//

import Foundation
import Alamofire
typealias CompletionHandler = (_ status:Bool) -> ()

// Segues
let TO_SIGNUP = "SIGNUP_SEGUE"
let TO_LOGIN = "LOGIN_SEGUE"
let UNWIND_TO_CHANNEL = "UNWIND_CHANNEL_SEGUE"
let TO_AVATAR = "AVATAR_SEGUE"

//Notifications
let NOTI_USER_CHANGED = Notification.Name("NOTI_USER_CHANGED")
let NOTI_CHANNEL_SELECTED = Notification.Name("NOTI_CHANNEL_SELECTED")
let NOTI_USER_TYPING_CHANGED = Notification.Name("NOTI_USER_TYPING_CHANGED")
//User Default Keys
let AUTH_KEY = "AUTH"
let ID_KEY = "ID"
let EMAIL_KEY = "EMAIL"
let USER_KEY = "USER"
let AVIMG_KEY = "AVIMG"
let AVCOLOR_KEY = "AVCOLOR"

let LOGGED_KEY = "IS_LOGGED_IN"

//Services User
let baseUrl = "https://smashmashian.herokuapp.com/v1/"
let registerUrl = "\(baseUrl)account/register"
let loginUrl = "\(baseUrl)account/login"
let createUserUrl = "\(baseUrl)user/add"
func findUserUrl(email:String) -> String { return "\(baseUrl)user/byEmail/\(email)"}
let channelsUrl = "\(baseUrl)channel"
func messagesUrl(channelId:String) ->String { return "\(baseUrl)message/byChannel/\(channelId)"}

let header:HTTPHeaders = [
    "Content-Type": "application/json; charset=utf-8"
]
let authHeader:HTTPHeaders =        [
    "Authorization":"Bearer \(AuthService.instance.auth)",
    "Content-Type": "application/json; charset=utf-8"
]
