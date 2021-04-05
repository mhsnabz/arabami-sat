//
//  Car.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 3.04.2021.
//

import UIKit
import FirebaseFirestore
class Car{
    var brand : String?
    var carModel : String?
    var price : String?
    var year : String?
    var km : String?
    var locaiton : GeoPoint?
    var senderName : String?
    var senderUid : String?
    var senderImage : String?
    var decription : String?
    var postTime : Timestamp?
    var postTimeLong  : Int64?
    var locationName : String?
    var imageList : [String]?
    init(dic: [String : AnyObject]){
        if let brand = dic["brand"] as? String {
            self.brand = brand
        }
        if let imageList = dic["imageList"] as? [String] {
            self.imageList = imageList
        }
        if let locationName = dic["locationName"] as? String {
            self.locationName = locationName
        }
        if let carModel = dic["carModel"] as? String {
            self.carModel = carModel
        }
        if let km = dic["km"] as? String {
            self.km = km
        }
        if let price = dic["price"] as? String {
            self.price = price
        }
        if let year = dic["year"] as? String {
            self.year = year
        }
        if let locaiton = dic["locaiton"] as? GeoPoint {
            self.locaiton = locaiton
        }
        if let senderName = dic["senderName"] as? String {
            self.senderName = senderName
        }
        if let senderUid = dic["senderUid"] as? String {
            self.senderUid = senderUid
        }
        if let senderImage = dic["senderImage"] as? String {
            self.senderImage = senderImage
        }
        if let decription = dic["decription"] as? String {
            self.decription = decription
        }
        if let postTime = dic["postTime"] as? Timestamp {
            self.postTime = postTime
        }
        if let postTimeLong = dic["postTimeLong"] as? Int64 {
            self.postTimeLong = postTimeLong
        }
    }
}
