//
//  MessageUserList.swift
//  Mentea
//
//  Created by Apple on 30/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MessageUserList {
    let image : String!
    let assignUserId : String!
    let name : String!
    let currentCity : String!
    let chatStatus : String!
    let isQueue: String!
    
    init( image : String!,
          assignUserId : String!,
           name : String!,
           currentCity : String!,
           chatStatus : String!,
           isQueue: String!) {
        
        self.image = image
        self.assignUserId = assignUserId
        self.name = name
        self.currentCity = currentCity
        self.chatStatus = chatStatus
        self.isQueue = isQueue
        
    }
    
}
