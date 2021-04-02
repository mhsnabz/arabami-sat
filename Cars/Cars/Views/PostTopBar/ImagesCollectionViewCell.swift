//
//  ImagesCollectionViewCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
private let imageCell = "imageCell"
class ImagesCollectionViewCell: UICollectionViewCell, addImage  {
    func addImage() {
        delegate?.addImage()
    }
    

    var collectionview: UICollectionView!
    weak var delegate : addImage?
    var imagesList : [Data]?{
        didSet{
            collectionview.reloadData()
        }
    }
    //MARK:-lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionview()
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureCollectionview(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionview = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = .white
        addSubview(collectionview)
        collectionview.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        collectionview.register(PostImageCell.self, forCellWithReuseIdentifier: imageCell)
    }
    func setEmptyMessage(_ message: String) {
        let emptyView = EmptyView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        emptyView.infoText = message
        emptyView.addImage = self
        collectionview.backgroundView = emptyView;
    }
    func restore() {
        collectionview.backgroundView = nil
    }
    
}
extension ImagesCollectionViewCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate , DeleteImage {
    
   
    func deleteImage(for cell: PostImageCell) {
        print("DEBUG:: deleted image")
        if let index =  self.collectionview.indexPath(for: cell){
            imagesList?.remove(at: index.row)
            collectionview.reloadData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        guard let count = imagesList?.count else {
            return 0
        }
        if count == 0 {
            setEmptyMessage("Add Image")
        }else if count > 0  {
            restore()
        }
        return count
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: imageCell, for: indexPath) as! PostImageCell
        if let data = imagesList?[indexPath.row]{
            cell.imageData = data
            cell.delegate = self
        }
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width  = (frame.width - 30 ) / 3
        return CGSize(width: width, height: width)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,  minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
class PostImageCell : UICollectionViewCell{
    weak var delegate: DeleteImage?
    var imageData : Data?{
        didSet{
            guard let data = imageData else { return }
            img.image = UIImage(data: data)
        }
    }
    let deleteBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    let img : UIImageView = {
       let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.backgroundColor = UIColor(white: 0.90, alpha: 0.7)
        return img
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(img)
        img.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        addSubview(deleteBtn)
        deleteBtn.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 20, heigth: 20)
        deleteBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func deleteImage(){
        delegate?.deleteImage(for: self)
    }
}
