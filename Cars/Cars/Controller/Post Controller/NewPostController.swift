//
//  NewPostController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
import SDWebImage
import ImagePicker
import Lightbox
import Gallery
import CoreLocation
import FirebaseFirestore
class NewPostController: UIViewController, PostTopBarSelectedIndex,LightboxControllerDismissalDelegate, GalleryControllerDelegate, addImage, SendLocationDelegate {
    func getLocation(geoPoint: GeoPoint, locaitonName: String) {
        self.geoPoint = geoPoint
        self.locaitonText = locaitonName
    }
    
    func getIndex(indexItem: Int) {
        print(indexItem)
    }
    
    //MARK:-variables
    var locationManager : CLLocationManager!
    var currentUser : CurrentUser
    var heigth : CGFloat = 0.0
    var imageList = [Data]()
    var gallery: GalleryController!
    weak var getLocation : SendLocationDelegate?
    var geoPoint : GeoPoint?
    var priceText : String?{
        didSet{
            guard let text = priceText else{
                priceLabel.text = "Add Price"
                return
            }
            priceLabel.textColor = .red
            priceLabel.text = text
        }
    }
    var locaitonText : String? {
        didSet{
            guard let text = locaitonText else{
                locationLabel.text = "Add Locaiton"
                return
            }
            
            locationLabel.text = text
            addLocation.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    //MARK:-properties
    lazy var collecitonView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = .zero
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    let profileImage : UIImageView = {
        let imagee = UIImageView()
        imagee.clipsToBounds = true
        imagee.contentMode = .scaleAspectFit
        imagee.layer.borderColor = UIColor.lightGray.cgColor
        imagee.layer.borderWidth = 0.5
        return imagee
        
    }()
    lazy var text : CaptionText = {
        let text = CaptionText()
        text.backgroundColor = .white
        text.font = UIFont(name: Utils.font, size: Utils.normalSize)
        text.isEditable = true
        text.dataDetectorTypes = [.all]
        text.isScrollEnabled = false
        text.isUserInteractionEnabled = true
        text.isScrollEnabled = true
        text.isSelectable = true
        return text
    }()
    let name : UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .left
        lbl.font = UIFont(name: Utils.font, size: Utils.regularSize)
        return lbl
    }()
    lazy var headerView : UIView = {
       let view = UIView()
        view.addSubview(profileImage)
        profileImage.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 45, heigth: 45)
        profileImage.layer.cornerRadius = 45 / 2
        view.addSubview(name)
        name.anchor(top: nil, left: profileImage.rightAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 10, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 0, heigth: 20)
        name.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor).isActive = true
        return view
    }()
    let addPrice : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(_addPrice), for: .touchUpInside)
        return btn
    }()
    let priceLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Add Price"
        lbl.font = UIFont(name: Utils.font, size: Utils.normalSize)
        lbl.textColor = .darkGray
        
        return lbl
    }()
  
    let addLocation : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(_addLocaiton), for: .touchUpInside)
        return btn
    }()
    let locationLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Add Locaiton"
        lbl.font = UIFont(name: Utils.font, size: Utils.normalSize)
        lbl.textColor = .darkGray
        
        return lbl
    }()
    
    
    
    lazy var menuBar : PostTopBar = {
        let mb = PostTopBar()
        mb.rootContoller = self
        return mb
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        configureCollectionView()
        getLocation = self
    }
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-imagePicker
    func addImage() {
        Config.Camera.recordLocation = false
        Config.tabsToShow = [.imageTab]
        gallery = GalleryController()
        gallery.delegate = self
        gallery.modalPresentationStyle = .fullScreen
        present(gallery, animated: true, completion: nil)
    }
    
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        controller.dismiss(animated: true) {
            for image in images{
                image.resolve { (img) in
                    if let image_data = img!.jpegData(compressionQuality: 0.8){
                        self.imageList.append(image_data)
                        self.collecitonView.reloadData()
                    }
                }
            }
        }
        gallery = nil
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        LightboxConfig.DeleteButton.enabled = true
        
        Utils.waitProgress(msg: nil)
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            Utils.dismissProgress()
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
        })
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
        gallery = nil
    }
    func showLightbox(images: [UIImage]) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        lightbox.modalPresentationStyle = .fullScreen
        
        gallery.present(lightbox, animated: true, completion: nil)
    }
    //MARK:-handlers
    private func setToolbar(){
        setNavigationBar()
        navigationItem.title = "New Post"
        let rigthBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(uploadPost))
        navigationController?.navigationItem.rightBarButtonItem = rigthBarButton
        hideKeyboardWhenTappedAround()
    }
    
   
    
    fileprivate func configurePriceStack() {
        let priceStack = UIStackView(arrangedSubviews: [addPrice,priceLabel,addLocation,locationLabel])
        priceStack.alignment = .center
        priceStack.axis = .horizontal
        priceStack.spacing = 6
        view.addSubview(priceStack)
        
        priceStack.anchor(top: text.bottomAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 8, marginLeft: 8, marginBottom: 0, marginRigth: 8, width: 0, heigth: 30)
        priceStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuBar.delegate = self
        view.addSubview(menuBar)
        menuBar.anchor(top: priceStack.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 44)
        menuBar.rootContoller = self
        
        
    }
    
    fileprivate func configureheaderView() {
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 50)
        
        view.addSubview(text)
        
        text.anchor(top: headerView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, rigth: headerView.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 100)
        text.delegate = self
        text.isScrollEnabled = true
        textViewDidChange(text)

        
        
    }
    
    private func configureCollectionView(){
        configureheaderView()
        configureCurrentUser()
        configurePriceStack()
        view.addSubview(collecitonView)
        collecitonView.anchor(top: menuBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        
        collecitonView.register(FuturesCell.self, forCellWithReuseIdentifier: "futures_cell")
        collecitonView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "images_cell")
        
    }
    
    private func configureTopBar(){
        
    }
    private func configureCurrentUser(){
        name.text = currentUser.name
        if let thumbImage = currentUser.thumbImage{
            profileImage.sd_imageIndicator = SDWebImageActivityIndicator.white
            profileImage.sd_setImage(with: URL(string: thumbImage))

        }else{
            profileImage.backgroundColor = .darkGray
        }
    }
    
    func scrollToIndex ( menuIndex : Int) {
        let index = IndexPath(item: menuIndex, section: 0)
        self.collecitonView.isPagingEnabled = false
        self.collecitonView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
        self.collecitonView.isPagingEnabled = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizantalLeftConstraint?.constant = scrollView.contentOffset.x / 2
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let memoryIndex = targetContentOffset.pointee.x / view.frame.width
        
        let index = IndexPath(item: Int(memoryIndex), section: 0)
        menuBar.collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
        menuBar.delegate?.getIndex(indexItem: Int(memoryIndex))
    }
    //MARK:-selectors
    @objc func uploadPost(){
        
    }
    @objc func _addPrice(){
        
    }
    @objc func _addLocaiton(){
        if locaitonText != nil {
            self.locaitonText = nil
            self.geoPoint = nil
            self.addLocation.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        }else{
            getLocation = self
            let vc = LocationPicker(currentUser: currentUser)
            vc.locationManager = locationManager
            vc.sendLocationDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
       
       
    }
  
}


//MARK:-text view delegate
extension NewPostController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView)
    {
       
        let size = CGSize(width: view.frame.width, height: 150)
        let estimatedSize = textView.sizeThatFits(size)
        
        if textView.contentSize.height >= 150
        {
            textView.isScrollEnabled = true
            collecitonView.frame = CGRect(x: 0, y: 150, width: view.frame.width-150, height: view.frame.height)
            collecitonView.reloadData()
        }
        else
        {
            textView.frame.size.height = textView.contentSize.height
            heigth = textView.contentSize.height
            textView.isScrollEnabled = false
            collecitonView.frame = CGRect(x: 0, y: size.width, width: view.frame.width-size.width, height: view.frame.height)
            collecitonView.reloadData()
            
        }
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                
                if textView.contentSize.height >= 150
                {
                    textView.isScrollEnabled = true
                    constraint.constant = 150
                    textView.frame.size.height = 150
                    heigth = 150
                    
                }
                else
                {
                    textView.frame.size.height = textView.contentSize.height
                    textView.isScrollEnabled = true
                    constraint.constant = estimatedSize.height
                    heigth = estimatedSize.height
                }
            }
        }
    }
}
extension NewPostController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "images_cell", for: indexPath) as! ImagesCollectionViewCell
            cell.imagesList = imageList
            cell.delegate = self
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "futures_cell", for: indexPath) as!
            FuturesCell
            cell.backgroundColor = .black
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}

