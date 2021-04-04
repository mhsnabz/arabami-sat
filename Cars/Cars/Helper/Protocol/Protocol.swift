//
//  Protocol.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import FirebaseFirestore
import MapKit
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
protocol AutoCompleteDelegate : class {
   
    func ZoomInPlace(placemark:MKPlacemark)
    func dismisSearchBar(isSearching : Bool)
    
   
}
protocol PickLocationDelegate : class {
    func didSelect(placeMark : MKPlacemark , placeName : String)
    func dismissDialog()
}
protocol SendLocationDelegate : class{
    func getLocation(geoPoint : GeoPoint , locaitonName : String)
}
protocol FuturesItemDelegate : class {
    func addBrand()
    func addKm()
    func addModel()
    func addYear()
    
    func removeYear()
    func removeKm()
    func removeBrand()
    func removeModel()
}

protocol PopUpYearDelegate : class {
    func handleDismissal(_ target : String?)
    func addYear(_ target : String?)
    func addKm(_target : String)
}

protocol PopUpNumberDelegate : class {
    func handleDismissal( _ target : String)
    func addPrice(_ target : String?)
}
