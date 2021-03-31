//
//  FeedVC.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
import FirebaseAuth
class FeedVC: UIViewController {
    //MARK:-variables
    var currentUser : CurrentUser
    let button : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("çıkış", for: .normal)
        return btn
    }()
    //MARK:-properties
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Feed"
        view.addSubview(button)
        button.anchor(top: nil, left: nil, bottom: view.bottomAnchor, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 30, marginRigth: 0, width: 200, heigth: 40)
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.addTarget(self, action: #selector(logOut), for: .touchUpInside)

    }
    

    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func logOut(){
        do{
           try! Auth.auth().signOut()
            let vc = SplashScreen()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
