//
//  MessageModal.swift
//  Mentea
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit


class MessageModel {
    let senderId : String!
    let receiverId : String!
    let message : String!
    let attachFile : String!
    let date : String!
    let fileName : String!
    
    
    init(  senderId : String!,
     receiverId : String!,
     message : String!,
     attachFile : String!,
     date : String!,
     fileName : String!) {
        
        self.senderId = senderId
        self.receiverId = receiverId
        self.message = message
        self.attachFile = attachFile
        self.date = date
        self.fileName = fileName
        
    }
    
}
