//
//  PostTopBar.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
class PostTopBar : UIView,  UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UICollectionViewDelegate{
    //MARK:-properties
    weak var delegate : PostTopBarSelectedIndex?
    weak var rootContoller : NewPostController?
    var horizantalLeftConstraint : NSLayoutConstraint?
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    //MARK:-lifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, rigth: rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "cell")
        let selecteIndex = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selecteIndex, animated: false, scrollPosition: .left)
        setUpHorizantalBar()
        delegate?.getIndex(indexItem: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:--funcitons
    func setUpHorizantalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = .black
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
       
        horizantalLeftConstraint =  horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizantalLeftConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MenuCell
        if indexPath.item == 0 {
            cell.lbl.text = "Media"
        }else if indexPath.item == 1 {
            cell.lbl.text = "Futures"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2, height: frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.getIndex(indexItem: indexPath.item)
        rootContoller?.scrollToIndex(menuIndex: indexPath.item)
    }
    
}
class MenuCell : UICollectionViewCell {
    
    let lbl : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 11)
        lbl.textColor = .lightGray

        return lbl
    }()
  
    override var isSelected: Bool{
        didSet{
            if isSelected {
                lbl.font = UIFont(name: Utils.fontBold, size: 13)
                lbl.textColor = .black
            }else{
                lbl.font = UIFont(name: Utils.font, size: 11)
                lbl.textColor = .lightGray
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(lbl)

        lbl.anchor(top: nil, left: nil, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        lbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        lbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
