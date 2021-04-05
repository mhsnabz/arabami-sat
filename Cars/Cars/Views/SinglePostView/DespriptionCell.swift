//
//  DespriptionCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit

class DespriptionCell: UITableViewCell {
    
    var deps : String?{
        didSet{
            lbl.text = deps
        }
    }
    let lbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: Utils.regularSize)
        lbl.textColor = .darkGray
        lbl.numberOfLines = 0
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(lbl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
