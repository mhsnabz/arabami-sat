//
//  ImageSlieder.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit

class ImageSlieder: UIView  , UICollectionViewDataSource  , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    
    
    //MARK:-varibles
    
    var imageList : [String]?
    var collectionview : UICollectionView!
    
    //MARK:-lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handler
    private func configureUI(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionview = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        addSubview(collectionview)
        collectionview.anchor(top: topAnchor, left: leftAnchor, bottom:bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        collectionview.register(ImageCell.self, forCellWithReuseIdentifier: "id")
    }
    //MARK:-selectors
    //MARK:-UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ImageCell
        if let url = imageList?[indexPath.row] {
            cell.imageUrl = url
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
}
