//
//  PopUpViewController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 3.04.2021.
//

import UIKit
import TweeTextField
class PopUpViewController : UIView{
    //MARK:-properties
    weak var delegate : PopUpNumberDelegate?
    var price : String?

    var yearsTillNow : [String] {
        var years = [String]()
        for i in (1990..<2021).reversed() {
            years.append("\(i)")
        }
        return years
    }
    var target : String?{
        didSet{
            
            configure(target: target)
        }
    }
    
    let priceVal : TweeAttributedTextField = {
        let txt = TweeAttributedTextField()
        txt.placeholder = "Add Price"
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
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
     
        return btn
    }()
    let btnCancel : UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("Cancel", for: .normal)
         btn.titleLabel?.font = UIFont(name: Utils.font, size: 14)
         btn.clipsToBounds = true
         btn.layer.cornerRadius = 5
         btn.backgroundColor = .mainColor()
         btn.setTitleColor(.white, for: .normal)
      
         return btn
     }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    private func configure(target : String?){
        guard let target = target else { return }
      if target == "addPrice"{
           
                priceVal.placeholder = "Add Price"
                btnAdd.addTarget(self, action: #selector(add_price), for: .touchUpInside)
            addSubview(priceVal)
            priceVal.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 40, marginLeft: 10, marginBottom: 0, marginRigth: 10, width: 0, heigth: 50)
            let stack = UIStackView(arrangedSubviews: [btnCancel,btnAdd])
            stack.axis = .horizontal
            stack.spacing = 5
            stack.distribution = .fillEqually
            addSubview(stack)
            stack.anchor(top: priceVal.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 10, marginLeft: 20, marginBottom: 0, marginRigth: 20, width: 0, heigth: 35)
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            btnCancel.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
            
        }
    }
    
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    //MARK:-selectors
    @objc func handleDismissal(target : String)
    {
        delegate?.handleDismissal(target)
        
    }
    @objc func donePicker(){
      
    }
   
    @objc func add_price(){
        self.price = priceVal.text
        delegate?.addPrice(priceVal.text)
        priceVal.text = ""
        target = nil
    }
  
   
}


