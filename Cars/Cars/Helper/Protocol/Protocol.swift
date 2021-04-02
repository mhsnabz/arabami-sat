//
//  Protocol.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import FirebaseFirestore
protocol QueriesDelegate : class {
    func didSelect(option : QueriesOptions)
}
protocol HomeControllerDelegate : class {
    func handleMenuToggle(forMenuOption menuOption : MenuOption?)
}
protocol PostTopBarSelectedIndex : class {
    func getIndex ( indexItem : Int)
}
protocol DeleteImage : class  {
    func deleteImage( for cell : PostImageCell)
}
protocol GetCoordiant : class {
    func getCoordinat(locaiton : GeoPoint)
}
