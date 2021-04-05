//
//  ImagesCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit

class ImagesCell: UITableViewCell {
    //MARK:-varibles
    var imageList : [String]?{
        didSet{
            imageSlider.imageList = imageList
        }
    }
    //MARK:-properites
    lazy var imageSlider : ImageSlieder = {
        let v = ImageSlieder(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        v.backgroundColor = .red
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(imageSlider)
        imageSlider.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
