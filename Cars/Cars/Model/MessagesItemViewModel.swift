//
//  MessagesItemViewModel.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
struct MessagesItemViewModel {
    private let currentUser : CurrentUser
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
    }
    var imageOptions: [MesagesItemOption]{
        var result = [MesagesItemOption]()
        result.append(.addImage(currentUser))
        result.append(.addLocation(currentUser))
      
       
        return result
    }
}
enum MesagesItemOption{
    case addImage(CurrentUser)
    case addLocation(CurrentUser)

    var description : String {
        switch self{
        
        case .addImage(_):
            return "Send Image"
        case .addLocation(_):
            return "Share Location"
      
        }
    }
    var image : UIImage {
        switch self{
        
        case .addImage(_):
            return #imageLiteral(resourceName: "gallery").withRenderingMode(.alwaysOriginal)
        case .addLocation(_):
            return #imageLiteral(resourceName: "location-orange").withRenderingMode(.alwaysOriginal)
        
        }
    }
    
}
