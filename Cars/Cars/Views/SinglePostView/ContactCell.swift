//
//  ContactCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit
import SDWebImage
class ContactCell: UITableViewCell {
    weak var delegate : ContactDelegate?
    var nameString : String? {
        didSet{
            fullName.text = nameString
        }
    }
    var photoUrl : String?{
        didSet{
            profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            profileImage.sd_setImage(with: URL(string: photoUrl!))
        }
    }
    var otherUser : OtherUser?
    let profileImage : UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    let fullName : UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: Utils.fontBold, size: Utils.regularSize)
        lbl.textColor = .black
        return lbl
    }()
    
    lazy var sendMsg : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send Direct Message", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .mainColor()
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    lazy var callPhone : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Call", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 12)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .red
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 45, heigth: 45)
        profileImage.layer.cornerRadius = 45 / 2
        addSubview(fullName)
        fullName.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 0)
        fullName.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        
        let stack  = UIStackView(arrangedSubviews: [sendMsg,callPhone])
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.axis = .horizontal
        addSubview(stack)
        stack.anchor(top: profileImage.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 8, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 50)
        callPhone.addTarget(self, action: #selector(phoneCall), for: .touchUpInside)
        sendMsg.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-selectors
    @objc func phoneCall(){
        delegate?.phoneCall(for: self)
    }
    @objc func sendMessage(){
        delegate?.sendMessage(for: self)
    }
}
