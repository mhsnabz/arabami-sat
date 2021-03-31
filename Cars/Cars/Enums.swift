//
//  Enums.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import Foundation
enum ImagesType {
    case image
    var  contentType : String{
        switch self{
        
        case .image:
            return "image/jpeg"
        }
    }
    var  mimeType : String{
        switch self{
        
        case .image:
            return ".jpeg"
        }
    }
    
}
