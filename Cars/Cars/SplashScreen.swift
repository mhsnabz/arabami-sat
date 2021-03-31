//
//  SplashScreen.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//

import UIKit
import FirebaseAuth
class SplashScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
      
    }
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser?.uid != nil {
            
        }else{
            let rootViewController = UINavigationController(rootViewController: LoginController())
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
           
        }
            
       
    }

 

}
