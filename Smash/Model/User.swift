//
//  UserData.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/1/21.
//

import Foundation

class User {
    var id:String?
    var username:String?{
        didSet{
            username = username?.lowercased()
        }
    }
    var email:String?{
        didSet{
            email = email?.lowercased()
        }
    }
    var password:String?
    var avatarName:String?
    var avatarColor:String?

}
