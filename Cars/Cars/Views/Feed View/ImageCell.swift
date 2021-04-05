//
//  ImageCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit
import SDWebImage
class ImageCell: UICollectionViewCell {
    
    var imageUrl : String?{
        didSet{
            guard let url = imageUrl else { return }
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageView.sd_setImage(with: URL(string: url))
        }
    }
    
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightText
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
