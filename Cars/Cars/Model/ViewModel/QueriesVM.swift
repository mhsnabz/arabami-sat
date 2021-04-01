//
//  QueriesVM.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
class QueriesVM {
    private let currentUser : CurrentUser
    
    var options : [QueriesOptions]{
     var result = [QueriesOptions]()
        result.append(.sortByDate)
        result.append(.sortByPrice)
        result.append(.sortByYear)
        return result
    }
    
    init(currentUser : CurrentUser ) {
        self.currentUser = currentUser

    }
}
enum QueriesOptions{
    case sortByPrice
    case sortByDate
    case sortByYear
   
    var description : String {
        switch self{
        
        case .sortByPrice:
            return "Sort By Price"
        case .sortByDate:
            return "Sort By Date"
        case .sortByYear:
            return "Sort By Year"
       
        }
    }
}
