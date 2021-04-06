//
//  OffOnlineObj.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 6.04.2021.
//

import RealmSwift
class OffOnlineObj : Object{

    @objc dynamic var postID : String? = nil
    @objc dynamic var brand : String? = nil
    @objc dynamic var carModel : String? = nil
    @objc dynamic var senderName : String? = nil
    @objc dynamic var senderUid : String? = nil
    @objc dynamic var senderImage : String? = nil
    @objc dynamic var decription : String? = nil
    @objc dynamic var locationName : String? = nil
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var longLat: Double = 0.0
    @objc dynamic var postTime = NSDate()
    @objc dynamic var price : Int = 0
    @objc dynamic var year : Int = 0
    var postTimeLong = RealmOptional<Int64>()
    var imageList = List<String>()
    override static func primaryKey() -> String{
        return "postID"
    }
}
extension OffOnlineObj{
    func writeToRealm(){
        try! uiRealm.write{
            uiRealm.add(self, update: .all)
        }
    }
}
