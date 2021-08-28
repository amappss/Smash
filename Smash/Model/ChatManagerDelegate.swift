//
//  ChatManagerDelegate.swift
//  Smash
//
//  Created by Arsalan majlesi on 6/17/21.
//

import Foundation

protocol ChatManagerDelegate : class {
    func didRecievedMessage()
    func didRecievedIsTyping()
    
}
