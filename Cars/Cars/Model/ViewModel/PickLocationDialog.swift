//
//  PickLocationDialog.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 2.04.2021.
//

import UIKit
import MapKit

class PickLocationDialog : NSObject{
    //MARK:-varibales
    private var window : UIWindow?
    weak var delegate : PickLocationDelegate?
    var selectedPlaceName : String?{
        didSet{
            self.placeName.text = selectedPlaceName
        }
    }
    var selectedAdress : String?{
        didSet{
            self.cityName.text = selectedAdress
        }
    }
    var item : MKPlacemark?


    //MARK:-properties
    private lazy var blackView : UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy var placeName : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.fontBold, size: Utils.normalSize)
        lbl.textColor = .black
        
        return lbl
    }()
    lazy var cityName : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: Utils.smallSize)
        lbl.textColor = .darkGray
        return lbl
    }()
    
    let selectButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .mainColor()
        btn.setTitle("Select Location", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: Utils.regularSize)
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    let dismiss : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .red
        btn.setTitle("Cancel", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: Utils.regularSize)
        btn.setTitleColor(.white, for: .normal)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    lazy var dialogView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        let labelStack = UIStackView(arrangedSubviews: [placeName,cityName])
        labelStack.axis = .vertical
        labelStack.alignment = .center
        labelStack.distribution = .fillEqually
        labelStack.spacing = 6
        
        view.addSubview(labelStack)
        labelStack.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 30, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: view.frame.width , heigth: 60)
        labelStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        let stackButton = UIStackView(arrangedSubviews: [selectButton,dismiss])
        stackButton.axis = .horizontal
        stackButton.spacing = 6
        stackButton.distribution = .fillEqually
        view.addSubview(stackButton)
        stackButton.anchor(top: labelStack.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 40, marginBottom: 40, marginRigth: 40, width: 0, heigth: 50)
        
        selectButton.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        dismiss.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return view
    }()
    //MARK:-lifeCycle
     override init(){
        super.init()
    }
    
    //MARK:-handlers
    func show(placeMark : MKPlacemark , selectedPlace : String , selectedAdress : String){
        self.item = placeMark
        self.selectedAdress = selectedAdress
        self.selectedPlaceName = selectedPlace
        guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
        window.addSubview(dialogView)
        dialogView.anchor(top: nil, left: window.leftAnchor, bottom: window.safeAreaLayoutGuide.bottomAnchor, rigth: window.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 200)
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.dialogView.frame.origin.y -= 200
            
        }
      
       
    }
    
    
    //MARK:--selector
    @objc  func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
           
            self.blackView.alpha = 0
            self.dialogView.frame.origin.y += 200
          
        }
    }
    @objc func selectLocation(){
        guard let item = item else { return }
        delegate?.didSelect(placeMark: item)
        handleDismiss()
    }
}
