//
//  SplashScreen.swift
//  Arabamı Sat
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//

import UIKit

class SplashScreen: UIViewController {

    let text : UILabel = {
       let lbl = UILabel()
        lbl.text = "hello world"
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(text)
        text.anchor(top: nil, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 30)
        text.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        text.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    



}
