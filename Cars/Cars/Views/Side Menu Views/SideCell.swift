//
//  SideCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit

class SideCell: UITableViewCell {
    static let reuseIdentifier: String = String(describing: self)
  
    //MARK:-varibales
    
    //MARK:-properties
    
    let imageIcon : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()

    let optionButton : UILabel = {
        let btn = UILabel()
        btn.font = UIFont(name: Utils.font, size: 18)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubview(imageIcon)
        imageIcon.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 25, heigth: 25)
        imageIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(optionButton)
        optionButton.anchor(top: nil, left: imageIcon.rightAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 16, marginBottom: 0, marginRigth: 12, width: 0, heigth: 45)
        optionButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
