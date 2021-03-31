//
//  TaskUser.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import Foundation
class TaskUser {
   // "name":"","phoneNumber":"","email":_email,"profileImage":"","thumbImage":""]
    var name : String?
    var phoneNumber:String?
    var email : String?
    var profileImage : String?
    var thumbImage:String?
    var uid : String?
    
    init(with_uid uid: String , with_dic dic: [String : Any]) {
        self.uid = uid
        if let phoneNumber = dic["phoneNumber"] as? String{
            self.phoneNumber = phoneNumber
        }
        if let name = dic["name"] as? String{
            self.name = name
        }
        if let email = dic["email"] as? String{
            self.email = email
        }
        if let thumbImage = dic["thumbImage"] as? String{
            self.thumbImage = thumbImage
        }
        if let profileImage = dic["profileImage"] as? String{
            self.profileImage = profileImage
        }
       
    }
}
