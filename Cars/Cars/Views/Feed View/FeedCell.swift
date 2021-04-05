//
//  FeedCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit

class FeedCell: UICollectionViewCell {
   
    //MARK:-variables
    var model : Car?{
        didSet{
          setCell()
        }
    }
    //MARK:-properites
    lazy var imageSlider : ImageSlieder = {
        let v = ImageSlieder(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        v.backgroundColor = .red
        return v
    }()
    let logo : UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.darkGray.cgColor
        image.backgroundColor = .lightText
        return image
    }()
    
    let carBrand : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    
    var carBrandAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    let descp : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 12)
        lbl.textColor = .black
        lbl.numberOfLines = 2
        return lbl
    }()
    let price : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 12)
        lbl.textColor = .red
        lbl.textAlignment = .center
        return lbl
    }()
    let locaiton  : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 12)
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    let time  : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 12)
        lbl.textColor = .darkGray
        lbl.textAlignment = .center
        return lbl
    }()
    //MARK:-lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-handlers
    
    private func configureCell(){
        addSubview(logo)
        logo.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 8, marginLeft: 8, marginBottom: 8, marginRigth: 0, width: 45, heigth: 45)
        logo.layer.cornerRadius = 45 / 2
        addSubview(carBrand)
        carBrand.anchor(top: nil, left: logo.rightAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 0)
        carBrand.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
        addSubview(imageSlider)
      
        addSubview(descp)
        let stack = UIStackView(arrangedSubviews: [price,locaiton,time])
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 6
        addSubview(stack)
        stack.anchor(top: descp.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 30)
    }
    
    private func setCell(){
        guard let model = model else { return }
        imageSlider.imageList = model.imageList
        
        carBrandAtt = NSMutableAttributedString(string: "\(model.brand!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 14)!, NSAttributedString.Key.foregroundColor : UIColor.black])
        carBrandAtt.append(NSMutableAttributedString(string: " : \(model.carModel!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray]))
        carBrandAtt.append(NSMutableAttributedString(string: "  \(model.year!) model", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray]))
        
        carBrand.attributedText = carBrandAtt
        price.text = model.price! + " TL"
        locaiton.text = model.locationName ?? ""
        descp.text = model.decription
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        time.text  = dateFormatter.string(from: (model.postTime?.dateValue())!)
        logo.image = UIImage(named: model.brand!)
    }
    //MARK:-selectors
}
