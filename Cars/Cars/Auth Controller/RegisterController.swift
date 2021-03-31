//
//  RegisterController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
import GoogleSignIn
import Firebase
import TweeTextField
import FirebaseFirestore
class RegisterController: UIViewController {

    //MARK:-properties
    let logoView : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "cars_logo").withRenderingMode(.alwaysOriginal)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let email : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "Enter a Valid E-Mail Adress"
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
        txt.placeholder = "Create Password"
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
    
    let btnReg : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.fontBold, size: 16)!
        btn.addTarget(self, action: #selector(registerClick), for: .touchUpInside)
        
        return btn
    }()
    
    
    let forgetPassWrodBtn : UIButton = {
        let btn = UIButton(type: .system)
        let text1 = NSMutableAttributedString(string: "Already Have An Account ", attributes :[NSAttributedString.Key.font : UIFont(name: Utils.font, size: Utils.normalSize)!
            , NSAttributedString.Key.foregroundColor: UIColor.lightGray ])
        text1.append(NSAttributedString(string: "Sign In", attributes :[NSAttributedString.Key.font : UIFont(name:Utils.font, size: Utils.normalSize)!
            , NSAttributedString.Key.foregroundColor:UIColor.mainColor() ]))
        btn.setAttributedTitle(text1, for: .normal)
        btn.addTarget(self, action: #selector(signInPage), for: .touchUpInside)
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
        btn.setTitle("Sign Up With Google Account", for: .normal)
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
    
    //MARK:-handlers
    fileprivate func configureUI(){
        
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        view.addSubview(logoView)
        hideKeyboardWhenTappedAround()
        
        logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoView.anchor(top: view.topAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 40, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 100, heigth: 100)
        let stackViewLogin = UIStackView(arrangedSubviews: [email,password,btnReg])
        stackViewLogin.distribution = .fillEqually
        stackViewLogin.spacing = 14
        stackViewLogin.axis = .vertical
        Utils.shared.enabledButton(btnReg)
        view.addSubview(stackViewLogin)
        stackViewLogin.anchor(top: logoView.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 10, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 178)
        
        view.addSubview(dividerView)
        dividerView.anchor(top: stackViewLogin.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 12, marginLeft: 32, marginBottom: 0, marginRigth: 32, width: 0, heigth: 30)
        
        
        view.addSubview(googleSignInButton)
       // Utils.shared.styleFilledButton(googleSignInButton)
        googleSignInButton.anchor(top: dividerView.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 16, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        googleSignInButton.addTarget(self, action: #selector(signWithGoogle), for: .touchUpInside)
        view.addSubview(forgetPassWrodBtn)
        forgetPassWrodBtn.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 16, marginBottom: 32, marginRigth: 16, width: 0, heigth: 0)
 
    }
    //MARK:-selectors
    @objc func formValidations(){
        guard email.hasText , password.hasText else{
            btnReg.isEnabled = false
            Utils.shared.enabledButton(btnReg)
            return
        }
        self.btnReg.isEnabled = true
        Utils.shared.styleFilledButton(btnReg)
    }
    @objc func signInPage(){
        let vc = LoginController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    @objc func registerClick(){
        Utils.waitProgress(msg: "Please Wait")
        email.infoLabel.text = ""
        password.infoLabel.text = ""
        guard  let _email = email.text?.trimmingCharacters(in: .whitespacesAndNewlines) else{
            self.email.infoLabel.text = "Please Enter A Valid E-Mail"
            btnReg.isEnabled = false
            Utils.shared.enabledButton(btnReg)
            Utils.dismissProgress()
            return
        }
        guard  let _pass = password.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            self.password.infoLabel.text = "Please Create A Password"
            btnReg.isEnabled = false
            Utils.shared.enabledButton(btnReg)
            Utils.dismissProgress()
            return
        }
        
        Auth.auth().createUser(withEmail: _email, password: _pass) {[weak self] (result, err) in
            guard let sself = self else { return }
            if let err = err {
                if err.localizedDescription == "The email address is already in use by another account."{
                    Utils.errorProgress(msg: "Error")
    
                    sself.email.infoLabel.text = "The email address is already in use by another account"
                    sself.btnReg.isEnabled = false
                    return
                }
                if err.localizedDescription == "Network error (such as timeout, interrupted connection or unreachable host) has occurred."{
                    
                    sself.password.infoLabel.text = ""
                    sself.email.infoLabel.text = "Please Check Internet Connection"
                    sself.password.infoLabel.text = ""
                    sself.email.infoLabel.text = "Please Check Internet Connection"
                    sself.btnReg.isEnabled = false
                    Utils.errorProgress(msg: nil)
                    return
                }
                
            
            }else if let result = result {
              
                Utils.waitProgress(msg: "Creating New Account")
                let dic = ["name":"","phoneNumber":"","email":_email,"profileImage":"","thumbImage":""] as [String : AnyObject]
                let db = Firestore.firestore().collection("task-user")
                    .document(result.user.uid)
                db.setData(dic,merge: true) { (err) in
                    if let err = err {
                        Utils.errorProgress(msg: err.localizedDescription)
                    }else{
                        let statusRef = Firestore.firestore().collection("status")
                            .document(result.user.uid)
                        statusRef.setData(["status":false] as [String : Any], merge: true){ (err) in 
                            if let err = err {
                                Utils.errorProgress(msg: err.localizedDescription)

                            }else{
                                //navigate
                            }
                        }
                    }
                }
            }else{
                Utils.dismissProgress()
                Utils.errorProgress(msg: "Error")
            }
        }
        
       
            
        
    }
    @objc func signWithGoogle(){
        
    }
 

}
