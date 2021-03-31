//
//  LoginController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//

import UIKit
import GoogleSignIn
import Firebase
import TweeTextField
import FirebaseFirestore
class LoginController: UIViewController {
    
    //MARK:-variables
    
    //MARK:-properties
    
    
    
    let logoView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "cars_logo").withRenderingMode(.alwaysOriginal)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let email : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "E-Mail Adress"
        txt.font = UIFont(name: Utils.font, size: 14)!
        txt.activeLineColor =   UIColor.mainColor()
        txt.lineColor = .darkGray
        txt.textAlignment = .center
        txt.activeLineWidth = 1.5
        txt.animationDuration = 0.7
        txt.infoFontSize = UIFont.smallSystemFontSize
        txt.infoTextColor = .red
        txt.infoAnimationDuration = 0.4
        txt.keyboardType = UIKeyboardType.emailAddress
            txt.addTarget(self, action: #selector(formValidations), for: .editingChanged)
        
        return txt
    }()
    
    
    let password : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "Password"
        txt.font = UIFont(name: Utils.fontBold, size: 14)!
        txt.activeLineColor =   UIColor.mainColor()
        txt.lineColor = .darkGray
        txt.textAlignment = .center
        txt.activeLineWidth = 1.5
        txt.animationDuration = 0.7
        txt.infoFontSize = 10
        txt.infoTextColor = .red
        txt.isSecureTextEntry = true
         txt.addTarget(self, action: #selector(formValidations), for: .editingChanged)
        return txt
    }()
    let btnLogin : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.fontBold, size: 16)!
      btn.addTarget(self, action: #selector(loginClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.mainColorTransparent()
        return btn
    }()
    
    let btnReg : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.fontBold, size: 16)!
        btn.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        
        return btn
    }()
    
    
    
    
    lazy var dividerView : UIView = {
       let dividerView = UIView()
       let label  = UILabel()
        label.textColor = .darkGray
        label.text = "OR"
        label.font = UIFont(name: Utils.font, size: Utils.boldSize)
        dividerView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: dividerView.centerXAnchor).isActive = true

        let line1 = UIView()
        line1.backgroundColor = .darkGray
        line1.translatesAutoresizingMaskIntoConstraints = false
        dividerView.addSubview(line1)
        line1.anchor(top: nil, left: dividerView.leftAnchor, bottom: nil, rigth: label.leftAnchor, marginTop: 0, marginLeft: 16, marginBottom: 0, marginRigth: 8, width: 0, heigth: 1)
        line1.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        
        let line2 = UIView()
        line2.backgroundColor = .darkGray
        line2.translatesAutoresizingMaskIntoConstraints = false
        dividerView.addSubview(line2)
        line2.anchor(top: nil, left: label.rightAnchor, bottom: nil, rigth: dividerView.rightAnchor, marginTop: 0, marginLeft: 8, marginBottom: 0, marginRigth: 16, width: 0, heigth: 1)
        line2.centerYAnchor.constraint(equalTo: dividerView.centerYAnchor).isActive = true
        
        
        return dividerView
    }()
    
    
    
    let googleSignInButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.setTitle("Sign In With Google Account", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.black, for: .selected)
        btn.layer.cornerRadius = 10
        btn.backgroundColor = .googleButton()
        return btn
        
    }()
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    //MARK:-handlers
    fileprivate func configureUI(){
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(logoView)
        hideKeyboardWhenTappedAround()
        
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.anchor(top: view.topAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 40, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 100, heigth: 100)
        let stackViewLogin = UIStackView(arrangedSubviews: [email,password,btnLogin])
        stackViewLogin.distribution = .fillEqually
        stackViewLogin.spacing = 14
        stackViewLogin.axis = .vertical
        Utils.shared.enabledButton(btnLogin)
        view.addSubview(stackViewLogin)
        stackViewLogin.anchor(top: logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 10, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 178)
        view.addSubview(btnReg)
        btnReg.anchor(top: stackViewLogin.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 14, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        Utils.shared.styleHollowButton(btnReg)
        
        view.addSubview(dividerView)
        dividerView.anchor(top: btnReg.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 12, marginLeft: 32, marginBottom: 0, marginRigth: 32, width: 0, heigth: 30)
        
        
        view.addSubview(googleSignInButton)
       // Utils.shared.styleFilledButton(googleSignInButton)
        googleSignInButton.anchor(top: dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 16, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        googleSignInButton.addTarget(self, action: #selector(signWithGoogle), for: .touchUpInside)
       
 
    }
    //MARK:-selectors
    @objc func signWithGoogle(){
        print("DEBUG:: signWithGoogle click")
        GIDSignIn.sharedInstance()?.signIn()
    }
    @objc func resetPassword(){
        
    }
    @objc func formValidations(){
        
    }
    @objc func loginClick(){
        
    }
    @objc func signUp(){
        let vc = RegisterController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
}


extension LoginController : GIDSignInDelegate  {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        print("DEBUG:: did sign in with google")
        if let err = error {
            print("DEBUG:: erorr \(err.localizedDescription)")
        }
        guard let authentication = user.authentication else { return }
        let cridenatial = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        Auth.auth().signIn(with: cridenatial) {[weak self] (result, err) in
            guard let sself = self else { return }
            if let err = err {
                print("DEBUG:: auth  error \(err.localizedDescription)")
                return
            }
            else {
                guard let result = result else { return }
                 let uid = result.user.uid
                let user = result.user
                Utils.waitProgress(msg: "Please Wait")
                sself.checkUserAlreadyHaveAnAccount(uid: uid) { (val) in
                    if val{
                        let vc = SplashScreen()
                        vc.modalPresentationStyle = .fullScreen
                        sself.present(vc, animated: true){
                            Utils.dismissProgress()
                        }
                    }else{
                        sself.checkTaskUser(uid: uid) { (_val) in
                            if _val
                            {
                                let vc = SplashScreen()
                                vc.modalPresentationStyle = .fullScreen
                                sself.present(vc, animated: true) {
                                    Utils.dismissProgress()
                                }
                            }else{
                              
                                    
                                let dic = ["name":user.displayName as Any,"profileImage":user.photoURL?.absoluteString as Any,"thumbImage":user.photoURL?.absoluteString as Any,"phoneNumber":user.phoneNumber as Any,"email":user.email as Any] as [String : AnyObject]
                                UserService.shared.setGoogleSingUpTaskUser(dic: dic, uid: user.uid) { (_val) in
                                    if _val{
                                        let vc = SplashScreen()
                                        vc.modalPresentationStyle = .fullScreen
                                        sself.present(vc, animated: true) {
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
    }
    
    
    private func checkUserAlreadyHaveAnAccount(uid : String , completion : @escaping(Bool) ->Void){
        let db = Firestore.firestore().collection("user").document(uid)
        db.getDocument { (docSnap, err) in
            if let err = err {
                completion(false)
                print("DEBUG:: erorr \(err.localizedDescription)")
                return
            }else{
                guard let snap = docSnap else {
                    completion(false)
                    return}
                if snap.exists {
                    completion(true)
                    return
                }else{
                    completion(false)
                }
            }
        }
    }
    private func checkTaskUser(uid : String , completion : @escaping(Bool) ->Void){
        let db = Firestore.firestore().collection("task-user").document(uid)
        db.getDocument { (docSnap, err) in
            if let err = err {
                completion(false)
                print("DEBUG:: erorr \(err.localizedDescription)")
                return
            }else{
                guard let snap = docSnap else {
                    completion(false)
                    return}
                if snap.exists {
                    completion(true)
                    return
                }else{
                    completion(false)
                }
            }
        }
    }
    
}
