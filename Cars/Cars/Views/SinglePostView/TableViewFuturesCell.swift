//
//  TableViewFuturesCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit

class TableViewFuturesCell: UITableViewCell {

    //MARK:-varibales
    var car : Car?{
        didSet{
            configure()
        }
    }
    //MARK:-properties
    let brandLbl : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    var branddAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    let modelLbl : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    var modelLblAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    
    let kmLbl : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    var kmAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    let yearLbl : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    var yearAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    
    let priceLbl : UILabel = {
       let lbl = UILabel()
        return lbl
    }()
    var priceAtt : NSMutableAttributedString = {
       let name = NSMutableAttributedString()
        return name
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        let stack = UIStackView(arrangedSubviews: [brandLbl  , modelLbl , yearLbl , kmLbl , priceLbl])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 3
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 4, marginLeft: 12, marginBottom: 4, marginRigth: 12, width: 0, heigth: 72)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-handlers
    func configure(){
        guard let model = car else { return }
        branddAtt = NSMutableAttributedString(string: "Brand : ", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        branddAtt.append(NSMutableAttributedString(string: "\(model.brand!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.black]))
        brandLbl.attributedText = branddAtt
        
        modelLblAtt = NSMutableAttributedString(string: "Model : ", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        modelLblAtt.append(NSMutableAttributedString(string: "\(model.carModel!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.black]))
         modelLbl.attributedText = modelLblAtt
        
        kmAtt = NSMutableAttributedString(string: "Km : ", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        kmAtt.append(NSMutableAttributedString(string: " \(model.km!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.blue]))
        kmAtt.append(NSMutableAttributedString(string: " km", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.black]))
         kmLbl.attributedText = kmAtt
        
        
        
        yearAtt = NSMutableAttributedString(string: "Year : ", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        yearAtt.append(NSMutableAttributedString(string: " \(model.year!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.black]))
         yearLbl.attributedText = yearAtt
        
        priceAtt = NSMutableAttributedString(string: "Price : ", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        priceAtt.append(NSMutableAttributedString(string: " \(model.price!)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.red]))
        priceAtt.append(NSMutableAttributedString(string: "  TL", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.red]))
         priceLbl.attributedText = priceAtt
        
    }
    
}
