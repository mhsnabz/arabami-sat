//
//  EmptyViews.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
class EmptyView : UIView {
    
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
        addSubview(lbl)
        lbl.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0 , heigth: 100)
        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
