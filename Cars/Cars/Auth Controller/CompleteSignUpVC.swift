//
//  CompleteSignUpVC.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import TweeTextField
import FirebaseAuth
import SDWebImage
class CompleteSignUpVC: UIViewController {
    //MARK:-varibales
    var taskUser : TaskUser
    var imagePicker : UIImagePickerController!
    //MARK:-properties
    
    let profileImage : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.image = #imageLiteral(resourceName: "add").withRenderingMode(.alwaysOriginal)
        image.contentMode = .center
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.darkGray.cgColor
        return image
    }()
    let fullName : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "Enter Your Name"
        txt.font = UIFont(name: Utils.font, size: Utils.normalSize)!
        txt.activeLineColor =   UIColor.mainColor()
        txt.lineColor = .darkGray
        txt.textAlignment = .center
        txt.activeLineWidth = 1.5
        txt.animationDuration = 0.7
        txt.infoFontSize = UIFont.smallSystemFontSize
        txt.infoTextColor = .red
        txt.infoAnimationDuration = 0.4
        txt.keyboardType = UIKeyboardType.default
        txt.addTarget(self, action: #selector(formValidations), for: .editingChanged)
        
        return txt
    }()
    let phoneNumber : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "Enter Your Phone Number (Optinal)"
        txt.font = UIFont(name: Utils.font, size: Utils.normalSize)!
        txt.activeLineColor =   UIColor.mainColor()
        txt.lineColor = .darkGray
        txt.textAlignment = .center
        txt.activeLineWidth = 1.5
        txt.animationDuration = 0.7
        txt.infoFontSize = UIFont.smallSystemFontSize
        txt.infoTextColor = .red
        txt.infoAnimationDuration = 0.4
        txt.keyboardType = UIKeyboardType.phonePad
       
        return txt
    }()
    let btnReg : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Complete Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.fontBold, size: 16)!
        btn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        
        return btn
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        setNavigationBar()
        navigationItem.title = "Complete Sign Up"
        configureUI(taskUser: taskUser)

    }
    init(taskUser : TaskUser) {
        self.taskUser = taskUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    
   
    fileprivate func configureUI(taskUser  : TaskUser){
        view.addSubview(profileImage)
        profileImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 20, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 100, heigth: 100)
        profileImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImage.layer.cornerRadius = 100 / 2
        
        view.addSubview(fullName)
        fullName.anchor(top: profileImage.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        
        view.addSubview(phoneNumber)
        phoneNumber.anchor(top: fullName.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        
        view.addSubview(btnReg)
        btnReg.anchor(top: phoneNumber.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        Utils.shared.enabledButton(btnReg)
        btnReg.isEnabled = false
        getFirebaseUser()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        profileImage.addGestureRecognizer(tapGesture)
        profileImage.isUserInteractionEnabled = true
        
        
        configureImagePickerController()
        
    }
    
    private func getFirebaseUser(){
        guard let user = Auth.auth().currentUser else { return }
        if let name = user.displayName {
            fullName.text = name
        }
        if let phoneNumber = user.phoneNumber {
            self.phoneNumber.text = phoneNumber
        }
        if let image = user.photoURL {
            profileImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            profileImage.sd_setImage(with: image)
        }
    }
    fileprivate func configureImagePickerController() {
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
  
    private func completeSignUp( completion : @escaping(Bool) ->Void){
      
        Utils.waitProgress(msg: "Please Wait")
        fullName.infoLabel.text = ""
        guard let uid = taskUser.uid else { return }

        guard  let _name = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            self.fullName.infoLabel.text = "Please Enter Your Name"
            btnReg.isEnabled = false
            Utils.shared.enabledButton(btnReg)
            Utils.dismissProgress()
            return
        }
      
        if let phoneNumber = self.phoneNumber.text {
            let  dic = ["name":_name as Any, "phoneNumber":phoneNumber as Any ] as [String : Any]
            let db = Firestore.firestore().collection("task-user").document(uid)
            db.setData(dic, merge: true) { (_) in
                completion(true)
            }
        }else{
            let  dic = ["name":_name as Any, "phoneNumber":"" ] as [String : Any]
            let db = Firestore.firestore().collection("task-user").document(uid)
            db.setData(dic, merge: true) { (_) in
                completion(true)
            }
        }
        
    }
    private func changeStatus(uid : String , completion : @escaping(Bool) ->Void){
        let db = Firestore.firestore().collection("status").document(uid)
        db.setData(["status":true], merge: true) { (_) in
            completion(true)
        }
    }
    //MARK:-selectors
    @objc func formValidations(){
        Utils.dismissProgress()
        guard fullName.hasText  else{
            btnReg.isEnabled = false
            Utils.shared.enabledButton(btnReg)
            return
        }
        self.btnReg.isEnabled = true
        Utils.shared.styleFilledButton(btnReg)
    }
    
    @objc func registerClick(){
        guard let uid = taskUser.uid else { return }
        if profileImage.image == UIImage(named: "add") {
            completeSignUp() {[weak self] (_) in
                guard let sself = self else { return }
                sself.changeStatus(uid: uid) { (_) in
                    UserService.shared.getTaskUser(with: uid) { (taskUser) in
                        guard let taskUser = taskUser else { return }
                        let dic = ["name":taskUser.name,"phoneNumber":taskUser.phoneNumber,"email":taskUser.email,"profileImage":taskUser.profileImage,"thumbImage":taskUser.thumbImage] as [String : AnyObject]
                        let db = Firestore.firestore().collection("task-user").document(uid)
                        db.delete { (err) in
                            let db = Firestore.firestore().collection("user").document(uid)
                            db.setData(dic, merge: true) { (_) in
                                let vc = SplashScreen()
                                vc.modalPresentationStyle = .fullScreen
                                sself.present(vc, animated: true, completion: nil)
                                Utils.dismissProgress()
                            }
                        }
                    }
                }
            }
        }else{
            Utils.waitProgress(msg: "Please Wait")
            guard let selectedImage = profileImage.image else { return }
            guard let uid = taskUser.uid else { return }
            UploadSerivce.shared.uploadTaskUserProfileImage(selectedImage: selectedImage, uid: uid, contentType: ImagesType.image.contentType, mimeType: ImagesType.image.mimeType) {[weak self] (_val) in
                guard let sself = self else { return }
                if _val{
                    Utils.waitProgress(msg: "Please Wait")
                    sself.completeSignUp { (_) in
                        sself.changeStatus(uid: uid) { (_) in
                            UserService.shared.getTaskUser(with: uid) { (taskUser) in
                                guard let taskUser = taskUser else { return }
                                let dic = ["name":taskUser.name,"phoneNumber":taskUser.phoneNumber,"email":taskUser.email,"profileImage":taskUser.profileImage,"thumbImage":taskUser.thumbImage] as [String : AnyObject]
                                let db = Firestore.firestore().collection("task-user").document(uid)
                                db.delete { (err) in
                                    let db = Firestore.firestore().collection("user").document(uid)
                                    db.setData(dic, merge: true) { (_) in
                                        let vc = SplashScreen()
                                        vc.modalPresentationStyle = .fullScreen
                                        sself.present(vc, animated: true, completion: nil)
                                        Utils.dismissProgress()
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    @objc func pickImage(){
        print("DEBUG:: pick image")
        self.present(imagePicker, animated: true, completion: nil)
    }

}
extension CompleteSignUpVC : UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            self.profileImage.image = selectedImage
            self.profileImage.contentMode = .scaleAspectFit
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
