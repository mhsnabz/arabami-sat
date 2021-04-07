//
//  MessageGalleryModel.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import Foundation
class MessageGalleryModel{
 
    var type : String!
    var data : Data!
    
    init(data : Data ,  type : String){
    
        self.type = type
        self.data = data
    }
}
