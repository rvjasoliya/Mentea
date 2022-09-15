//
//  UserModel.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

//"email" : "jon@gmail.com",
//"feild_of_study" : "breach",
//"firstname" : "Denial",
//"hobbies" : "ddd",
//"kindofMember" : "Considerate and kind",
//"lastName" : "Jon’s",
//"longterm" : "ddd",
//"memberdo" : "ddd",
//"name" : "Jon",
//"objective" : "dd",
//"password" : "123456",
//"school" : "dav",
//"shortterm" : "sss",
//"userType" : "Mentee"

class UserModel {

    let email : String!
    let firstname : String!
    let lastName : String!
    let fun : String!
    let gender : String!
    let islive : String!
    let key_accomplishment : String!
    let kindofMember : String!
    let name : String!
    let occupation : String!
    let password : String!
    let school : String!
    let userType : String!
    let no_of_mentee : String!
    
    let feild_of_study : String!
    let hobbies : String!
    let longterm : String!
    let memberdo : String!
    let objective : String!
    let shortterm : String!
    let image : String!
    let userId : String!
    let currentCity : String?
    let areaOfExpertise : String?
    let latitude : String?
    let longitude : String?
    let birthday : String?
    let userGender : String?
    
    init(  email : String!,
        firstname : String!,
        lastName : String!,
        fun : String!,
        gender : String!,
        islive : String!,
        key_accomplishment : String!,
        kindofMember : String!,
        name : String!,
        occupation : String!,
        password : String!,
        school : String!,
        userType : String!,
        no_of_mentee : String!,
        feild_of_study : String!,
        hobbies : String!,
        longterm : String!,
        memberdo : String!,
        objective : String!,
        shortterm : String!,
        image : String!,
        userId : String,
        currentCity : String?,
        areaOfExpertise : String?,
        latitude : String?,
        longitude : String?,
        birthday : String?,
        userGender : String?) {
        
        self.email = email
        self.firstname = firstname
        self.lastName = lastName
        self.fun = fun
        self.gender = gender
        self.islive = islive
        self.key_accomplishment = key_accomplishment
        self.kindofMember = kindofMember
        self.name = name
        self.occupation = occupation
        self.password = password
        self.school = school
        self.userType = userType
        self.no_of_mentee = no_of_mentee
        
        self.feild_of_study = feild_of_study
        self.hobbies = hobbies
        self.longterm = longterm
        self.memberdo = memberdo
        self.objective = objective
        self.shortterm = shortterm
        self.image = image
        self.userId = userId
        self.currentCity = currentCity
        self.areaOfExpertise = areaOfExpertise
        self.latitude = latitude
        self.longitude = longitude
        self.birthday = birthday
        self.userGender = userGender
    }

}


