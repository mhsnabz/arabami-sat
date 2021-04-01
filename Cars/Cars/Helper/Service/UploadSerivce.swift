//
//  UploadSerivcwe.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import FirebaseStorage
import FirebaseFirestore
import SVProgressHUD
class UploadSerivce {
    var uploadTask : StorageUploadTask?
    static let shared = UploadSerivce()
    func uploadTaskUserProfileImage(selectedImage : UIImage ,uid : String , contentType : String,mimeType : String , completion : @escaping(Bool) ->Void){
        let metaDataForImage = StorageMetadata()
        metaDataForImage.contentType = contentType
        guard let uploadData = selectedImage.jpegData(compressionQuality: 0.8) else {
            completion(false)
            return}
        
        let fileName = "profileImage\(uid)\(mimeType)"
        let thumb_file_name = "thumbImage\(uid)\(mimeType)"
        let storageRef = Storage.storage().reference().child("profileImage").child(fileName)
        uploadTask = storageRef.putData(uploadData, metadata: metaDataForImage, completion: { (metaData, err) in
            if let err = err {
                Utils.dismissProgress()
                Utils.errorProgress(msg: err.localizedDescription)
                completion(false)
                return
                
            }else{
                storageRef.downloadURL { (url, err) in
                    guard let profileImageUrl = url?.absoluteString else{
                        completion(false)
                        return
                    }
                    let db = Firestore.firestore().collection("task-user").document(uid)
                    db.setData(["profileImage":profileImageUrl] as [String : String], merge: true) {[weak self] (err) in
                        guard let sself = self else { return }
                        if let err = err {
                            print("DEBUG:: \(err.localizedDescription)")
                        }else{
                            sself.getTaskUserThumbUrl(thumbImage: selectedImage, contentType: contentType, fileName: thumb_file_name, uid: uid) { (thumbUrl) in
                                guard let thumbUrl = thumbUrl else { return}
                                db.setData(["thumbImage":thumbUrl], merge: true) { (_) in
                                    completion(true)
                                }
                            }
                        }
                    }
                }
            }
        })
        if uploadTask != nil {
            _ = uploadTask!.observe(.progress) { snapshot in
                
                
                let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount)
                    / Float(snapshot.progress!.totalUnitCount)
                
                SVProgressHUD.showProgress(percentComplete, status: "Image Uploding\n \(Float(snapshot.progress!.totalUnitCount / 1_24) / 1000) MB % \(Int(percentComplete))")
                
                print(percentComplete) // NSProgress object
            }
        }
    }
    
    func getTaskUserThumbUrl( thumbImage : UIImage ,contentType : String, fileName : String ,uid : String , completion : @escaping(String?) ->Void){
        guard let thumbData = thumbImage.jpegData(compressionQuality: 0.2) else { return }
        let storageRef = Storage.storage().reference().child("thumbImage").child(fileName)
        let storageMetaData = StorageMetadata()
        storageMetaData.contentType = contentType
        storageRef.putData(thumbData, metadata: storageMetaData) { (metaData, err) in
            if let err = err {
                completion(nil)
                print("DEBUG:: \(err.localizedDescription)")
            }
            storageRef.downloadURL { (url, err) in
                if let err = err {
                    completion(nil)
                    print("DEBUG:: \(err.localizedDescription)")
                }
                guard let thumb_url = url?.absoluteString else {
                    completion(nil)
                    return
                }
                completion(thumb_url)
            }
        }
     }
}
