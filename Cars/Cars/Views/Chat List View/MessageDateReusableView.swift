//
//  MessageDateReusableView.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
import MessageKit
import SnapKit
class MessageDateReusableView: MessageReusableView {
    var label: PaddingLabel!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = .none
        
        label = PaddingLabel()
        label.backgroundColor = .white
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 11)
        label.paddingLeft = 5
        label.paddingRight = 5
        self.addSubview(label)
        
        label.clipsToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = .lightGray
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self.center)
            make.top.equalTo(self.snp.top).offset(1)
            make.bottom.equalTo(self.snp.bottom).offset(-1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
