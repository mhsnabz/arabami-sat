//
//  AddKmController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 4.04.2021.
//

import UIKit
import TweeTextField
class AddKmController: UIViewController {
    //MARK:-variables
    weak var delegate : PopUpYearDelegate?
    //MARK:-properties
    
    let addKmVal : TweeAttributedTextField = {
         let txt = TweeAttributedTextField()
         txt.placeholder = "Add Km"
         txt.font = UIFont(name: Utils.font, size: 14)!
         txt.activeLineColor =   UIColor.mainColor()
         txt.lineColor = .lightGray
         txt.textAlignment = .left
         txt.activeLineWidth = 1.5
         txt.animationDuration = 0.7
         txt.infoFontSize = UIFont.smallSystemFontSize
         txt.infoTextColor = .red
         txt.infoAnimationDuration = 0.4
         txt.textContentType = .telephoneNumber
         txt.autocorrectionType = .no
         txt.autocapitalizationType = .none
         txt.returnKeyType = .continue
         txt.textAlignment = .center
         
         return txt
     }()
    let   btnAdd : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 14)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .mainColor()
        btn.setTitleColor(.white, for: .normal)
     
        return btn
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(addKmVal)
        addKmVal.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 40, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        view.addSubview(btnAdd)
        btnAdd.anchor(top: addKmVal.bottomAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 20, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 200, heigth: 40)
        btnAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnAdd.addTarget(self, action: #selector(add_km), for: .touchUpInside)
    }
    //MARK:-selectors
    @objc func add_km(){
        
        delegate?.addKm(_target: addKmVal.text!)
        addKmVal.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:-handlers
}
