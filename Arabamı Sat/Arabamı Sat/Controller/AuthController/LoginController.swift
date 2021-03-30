//
//  LoginController.swift
//  Arabamı Sat
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import GoogleSignIn
class LoginController: UIViewController {

    //MARK:-variables
    let googleSignButton : GIDSignInButton = {
       let btn = GIDSignInButton()
        return btn
    }()
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    //MARK:-handlers
    
    fileprivate func configureGoogleSingIn(){
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    //MARK:-selectors
    
}
