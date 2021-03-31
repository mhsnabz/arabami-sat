//
//  UserService.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import FirebaseFirestore
class UserService{
   public static let shared = UserService()
    
    func getTaskUser(with uid : String , completion : @escaping(TaskUser?) ->Void){
        let db = Firestore.firestore().collection("task-user")
            .document(uid)
        db.getDocument { (docSnap, err) in
            if let err =  err {
               
                print("DEBUG:: \(err.localizedDescription)")
                completion(nil)
            }else{
                guard let snap = docSnap else{
                    completion(nil)
                    return
                }
                if let user = snap.data(){
                    completion(TaskUser.init(with_uid: uid, with_dic: user))
                }
                
            }
        }
    }
    
    func getCurrentUser(with uid : String , completion : @escaping(CurrentUser?) ->Void){
        let db = Firestore.firestore().collection("user")
            .document(uid)
        db.getDocument { (docSnap, err) in
            if let err =  err {
               
                print("DEBUG:: \(err.localizedDescription)")
                completion(nil)
            }else{
                guard let snap = docSnap else{
                    completion(nil)
                    return
                }
                if let user = snap.data(){
                    completion(CurrentUser.init( with_dic: user))
                }else{
                    print("DEBUG :: cant cast")
                }
                
            }
        }
    }
    
    func setGoogleSingUpTaskUser(dic : [String : AnyObject],uid : String , completion : @escaping(Bool) ->Void){
        let db = Firestore.firestore().collection("status").document(uid)
        db.setData(["status":false], merge: true) { (err) in
            if let err = err {
                print("DEBUG:: status setting error : \(err.localizedDescription)" )
                completion(false)
                return
            }else{
                let db = Firestore.firestore().collection("task-user").document(uid)
                db.setData(dic, merge: true) { (err) in
                    if let err = err {
                        print("DEBUG:: task user set eroor \(err.localizedDescription)")
                        completion(false)
                        return
                    }else{
                        completion(true)
                    }
                }
            }
        }
    }
    
}
