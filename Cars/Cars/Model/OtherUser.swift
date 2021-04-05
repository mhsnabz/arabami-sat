//
//  OtherUser.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import Foundation
class OtherUser  {
    var name : String?
    var phoneNumber:String?
    var email : String?
    var profileImage : String?
    var thumbImage:String?
    var uid : String?
    
    init( with_dic dic: [String : Any]) {
        if let uid = dic["uid"] as? String {
            self.uid = uid
        }
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
