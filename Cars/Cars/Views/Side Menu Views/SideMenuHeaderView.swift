//
//  SideMenuHeaderView.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
import SDWebImage
class SideMenuHeaderView: UITableViewHeaderFooterView {
    //MARK:-varibles
    static let reuseIdentifier: String = String(describing: self)
    var currentUser : CurrentUser?{
        didSet{
            guard let user = currentUser else { return }
            setUserInfo(user: user)
        }
    }
    
    //MARK:-properties
    
    private let profileImage : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.backgroundColor = .darkGray
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.darkGray.cgColor
        return image
    }()
    private let fullName : UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: Utils.fontBold, size: Utils.boldSize)
        lbl.textColor = .black
        return lbl
    }()
    private let phoneNumber : UILabel = {
        let lbl = UILabel()
         lbl.font = UIFont(name: Utils.font, size: Utils.normalSize)
         lbl.textColor = .black
         return lbl
     }()
    //MARK:-lifeCycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    private func configureUI(){
        addSubview(profileImage)
        profileImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 75, heigth: 75)
        profileImage.layer.cornerRadius = 75 / 2
        addSubview(fullName)
        fullName.anchor(top: profileImage.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 8, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 20)
        addSubview(phoneNumber)
        phoneNumber.anchor(top: fullName.bottomAnchor, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 8, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 0, heigth: 20)
    }
    private func setUserInfo(user : CurrentUser){
        fullName.text = user.name
        if let image  = user.thumbImage {
            profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            profileImage.sd_setImage(with: URL(string: image))
        }else{
            profileImage.backgroundColor = .darkGray
        }
       
    }
    //MARK:-selectors
    
    
    
}
