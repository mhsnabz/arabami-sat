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
    func animateCenterMapButton()
    func ZoomInPlace(placemark:MKPlacemark)
    func dismisSearchBar(isSearching : Bool)
    func handleSearch(with SearchText : String)
    func addPolyLine(destinationMapItem : MKMapItem)
    func selectAnnotation(selectAnnotation mapItem : MKMapItem)
}
protocol PickLocationDelegate : class {
    func didSelect(placeMark : MKPlacemark)
    func dismissDialog()
}
