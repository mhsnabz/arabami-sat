//
//  Protocol.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import Foundation
protocol QueriesDelegate : class {
    func didSelect(option : QueriesOptions)
}
protocol HomeControllerDelegate : class {
    func handleMenuToggle(forMenuOption menuOption : MenuOption?)
}