//
//  ChatListItem.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
import SDWebImage
class ChatListItem: UICollectionViewCell {
    weak var user : ChatListModel?{
        didSet{
            configure()
        }
        
    }
    
    //MARK:-properties
    lazy var profileImage : UIImageView = {
       let img = UIImageView()
        img.clipsToBounds = true
        img.layer.borderWidth = 0.3
        img.layer.borderColor = UIColor.lightGray.cgColor
        return img
    }()
    lazy var userName : UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 14)
        lbl.textColor = .black
        
        return lbl
    }()
    lazy var name : NSMutableAttributedString = {
         let name = NSMutableAttributedString()
         return name
     }()
    let line : UIView = {
       let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    lazy var msgKidImage : UIImageView = {
       let img = UIImageView()

       return img
    }()
    lazy var lastMsg : UILabel = {
        let lbl = UILabel()
        
        return lbl
    }()
    lazy var tarih : UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: Utils.fontBold, size: 10)
        lbl.textColor = .darkGray
        lbl.textAlignment = .right
        return lbl
    }()
    lazy var badgeCount : UILabel = {
        let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.backgroundColor = .red
        lbl.textColor = .white
        lbl.font = UIFont(name: Utils.fontBold, size: 12)
        lbl.layer.cornerRadius = 15 / 2
        return lbl
    }()
    
    lazy var lastMsgViewWithImage : UIView = {
        let v = UIView()
        v.addSubview(msgKidImage)
  
        msgKidImage.anchor(top: nil, left: v.leftAnchor, bottom: nil
                           , rigth: nil
                           , marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 15, heigth: 15)
        msgKidImage.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        v.addSubview(lastMsg)
        lastMsg.anchor(top: nil
                       , left: msgKidImage.rightAnchor, bottom: nil, rigth: v.rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 0, heigth: 20)
        lastMsg.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        return v
    }()
    
    
    lazy var lastMsgView : UIView = {
        let v = UIView()

       
        v.addSubview(lastMsg)
        
        lastMsg.anchor(top: nil , left: v.leftAnchor, bottom: nil, rigth: v.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 20)
        lastMsg.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 20, marginBottom: 0, marginRigth: 0, width: 50, heigth: 50)
        profileImage.layer.cornerRadius = 25
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(tarih)
        tarih.anchor(top: topAnchor, left: nil, bottom: nil, rigth: rightAnchor, marginTop: 16, marginLeft: 0, marginBottom: 0, marginRigth: 12, width: 50, heigth: 10)
        addSubview(userName)
        userName.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, rigth: tarih.leftAnchor, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 1, width: 0, heigth: 20)
        addSubview(badgeCount)
        badgeCount.anchor(top: tarih.bottomAnchor, left: nil, bottom: nil, rigth: rightAnchor, marginTop: 12, marginLeft: 0, marginBottom: 0, marginRigth: 16, width: 15, heigth: 15)
        
   
        addSubview(lastMsgView)
        lastMsg.anchor(top: userName.bottomAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, rigth: badgeCount.leftAnchor, marginTop: 0, marginLeft: 12, marginBottom: 12, marginRigth: 12, width: 0, heigth: 0)
        addSubview(lastMsgViewWithImage)
        lastMsgViewWithImage.anchor(top: userName.bottomAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, rigth: badgeCount.leftAnchor, marginTop: 0, marginLeft: 12, marginBottom: 12, marginRigth: 12, width: 0, heigth: 0)
       
        addSubview(line)
        line.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 8, marginBottom: 1, marginRigth: 8, width: 0, heigth: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    //MARK:-handlers
    private func configure(){
        guard let user = user else { return }
        if user.type == "text" {
            msgKidImage.image = #imageLiteral(resourceName: "font").withRenderingMode(.alwaysOriginal)
        }else if user.type == "photo"{
            msgKidImage.image = #imageLiteral(resourceName: "gallery").withRenderingMode(.alwaysOriginal)
      
        }else if user.type == "location"{
            msgKidImage.image = #imageLiteral(resourceName: "location-orange").withRenderingMode(.alwaysOriginal)
    
        }else if user.type == "audio"{
            msgKidImage.image = #imageLiteral(resourceName: "audio").withRenderingMode(.alwaysOriginal)
      
        }
        
        lastMsg.text = user.lastMsg
       
        userName.text = user.name!
        tarih.text = user.time?.dateValue().timeAgoDisplay()
        profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
        profileImage.sd_setImage(with: URL(string : user.thumbImage ?? ""))
        
        guard let totalBadge = user.badgeCount else { return }
        
        if totalBadge == 0 {
            badgeCount.isHidden = true
            lastMsg.font = UIFont(name: Utils.font, size: 12)
            lastMsg.textColor = .darkGray
            
        }else{
            if totalBadge > 9 {
                badgeCount.font = UIFont(name: Utils.fontBold, size: 8)
                badgeCount.text = "+\(9)"
            }else{
                badgeCount.text = user.badgeCount?.description
                badgeCount.font = UIFont(name: Utils.fontBold, size: 10)
            }
           
            badgeCount.textAlignment = .center
            badgeCount.isHidden = false
            
            lastMsg.font = UIFont(name: Utils.fontBold, size: 12)
            lastMsg.textColor = .black
        }
        
    }
    
}
