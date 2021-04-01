//
//  Enums.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
enum MenuOption  : Int ,CustomStringConvertible  {
    case setting
    case messages
    case logOut
    var description : String{
        switch self{
        case .setting:
            return "Setting"
        case .messages:
        return "Messages"
        case .logOut:
        return "Sign Out"
        }
    }
  
    var image : UIImage  {
        switch self{
        case .messages:
            return #imageLiteral(resourceName: "chat").withRenderingMode(.alwaysOriginal)
        case .setting:
            return #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal)
        case .logOut:
            return #imageLiteral(resourceName: "sing_out").withRenderingMode(.alwaysOriginal)
        }
    }
}
