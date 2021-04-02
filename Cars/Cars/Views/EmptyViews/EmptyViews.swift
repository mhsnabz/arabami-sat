//
//  EmptyViews.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
protocol addImage : class {
    func addImage()
}
class EmptyView : UIView {
    weak var addImage : addImage?
    lazy var imageButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    var infoText : String?{
        didSet{
            guard let text = infoText else { return }
            lbl.text = text
        }
    }
    //MARK:-properties
    let lbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: Utils.normalSize)
        lbl.textAlignment = .center
        lbl.textColor = .darkGray
        return lbl
    }()
    
    //MARK:-lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageButton)
        imageButton.anchor(top: nil, left: nil, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 45, heigth: 45)
        imageButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(lbl)
        lbl.anchor(top: imageButton.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0 , heigth: 0)
        lbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageButton.addTarget(self, action: #selector(_addImage), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func _addImage(){
        addImage?.addImage()
    }
}
