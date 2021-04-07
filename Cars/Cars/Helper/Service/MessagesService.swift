//
//  MessagesService.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SVProgressHUD
import MessageKit
class MessagesService {
    var totalCompletedData : Float = 0
    var uploadTask : StorageUploadTask?
    static public var shared = MessagesService()
    func sendMessage(newMessage : Message,fileName : String?, currentUser : CurrentUser , otherUser : OtherUser , time : Int64 ){
        var msg = ""
        var loc : GeoPoint?
        var width : CGFloat = 0.0
        var heigth : CGFloat = 0.0
        var duration : Float = 0
        var lastMsg = ""
        switch newMessage.kind{
        
        case .text(let messageText):
            msg = messageText
            lastMsg = messageText
            break
        case .attributedText(_):
            break
        case .photo(let mediaItem):
            if let targetUrlString = mediaItem.url?.absoluteString{
                msg = targetUrlString
                heigth = mediaItem.size.height
                width = mediaItem.size.width
                lastMsg = "Image"
                
            }
            break
        case .video(_):
            break
        case .location(let item):
            let item = item.location
            loc = GeoPoint(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
            width = 200
            heigth = 200
            lastMsg = "Locaiton"
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        var dic = Dictionary<String,Any>()
        if let locaiton = loc{
            dic = ["id": newMessage.messageId,
                   "type": newMessage.kind.messageKindString,
                   "content": "",
                   "geoPoint":locaiton as GeoPoint,
                   "date": FieldValue.serverTimestamp(),
                   "time":time,
                   "senderUid" : currentUser.uid as Any,
                   "is_read": false,
                   "fileName":fileName ?? "",
                   "width" :width ,
                   "heigth" : heigth,
                   
                   "name": currentUser.name as Any] as [String : Any]
        }else{
            dic = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": msg,
                "geoPoint":loc  as Any,
                "date": FieldValue.serverTimestamp(),
                "time":time,
                "fileName":fileName ?? "",
                "senderUid" : currentUser.uid as Any,
                "is_read": false,
                "width" :width ,
               
                "heigth" : heigth,
                "name": currentUser.name as Any
            ] as [String : Any]
        }
        
        var dicSenderLastMessage = Dictionary<String,Any>()
        dicSenderLastMessage = ["lastMsg":lastMsg,
                                "time":FieldValue.serverTimestamp() ,
                                "thumbImage":otherUser.thumbImage ?? "",
                                "name":otherUser.name!,
                                "uid":otherUser.uid! ,
                                "type": newMessage.kind.messageKindString]
        var dicGetterLastMessage = Dictionary<String,Any>()
        dicGetterLastMessage = ["lastMsg":lastMsg,
                                "time":FieldValue.serverTimestamp() ,
                                "thumbImage":currentUser.thumbImage ?? "",
                                "uid":currentUser.uid!,
                                "name":currentUser.name!,
                                "type": newMessage.kind.messageKindString]
        let dbSender = Firestore.firestore().collection("messages")
            .document(currentUser.uid!)
            .collection(otherUser.uid!)
            .document(newMessage.messageId)
        dbSender.setData(dic, merge: true) { (err) in
            if err == nil {
                let db = Firestore.firestore().collection("user")
                    .document(currentUser.uid!)
                    .collection("msg-list")
                    .document(otherUser.uid!)
                db.setData(dicSenderLastMessage, merge: true)
            }
        }
        let dbGetter = Firestore.firestore().collection("messages")
            .document(otherUser.uid!)
            .collection(currentUser.uid!)
            .document(newMessage.messageId)
        dbGetter.setData(dic, merge: true){ (err) in
            if err == nil {
                let db = Firestore.firestore().collection("user")
                    .document(otherUser.uid!)
                    .collection("msg-list")
                    .document(currentUser.uid!)
                db.setData(dicGetterLastMessage, merge: true)
            }
        }
        getBadgeCount(currentUser: currentUser, target: "msg-list",  otherUser: otherUser)
        setBadgeCount(currentUser: currentUser, otherUser: otherUser, target:  "msg-list")
    }
    func getBadgeCount(currentUser : CurrentUser , target : String , otherUser : OtherUser ){
        

            let db = Firestore.firestore().collection("user")
                .document(otherUser.uid!)
                .collection(target).document(currentUser.uid!)
                .collection("badgeCount").whereField("badge", isEqualTo:"badge")
            db.getDocuments { (querySnap, err) in
                if err == nil {
                    guard let snap = querySnap else{ return }
                    if snap.count > 0 {
                        let db = Firestore.firestore().collection("user")
                            .document(otherUser.uid!)
                            .collection(target).document(currentUser.uid!)
                        db.setData(["badgeCount":snap.count as Int], merge: true, completion: nil)
                    
                    }
                }
            }
        
    }
    func setBadgeCount(currentUser : CurrentUser , otherUser : OtherUser, target : String){

            let db = Firestore.firestore().collection("user")
                .document(otherUser.uid!)
                .collection(target).document(currentUser.uid!) .collection("badgeCount")
            db.addDocument(data: ["badge":"badge"])
    }
}
