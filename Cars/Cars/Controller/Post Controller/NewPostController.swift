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
    weak var brandDelegate : BrandDelegate?
    var geoPoint : GeoPoint?
    var brand : String?{
        didSet{
            collecitonView.reloadData()
        }
    }
    
    var model : String?{
        didSet{
            collecitonView.reloadData()
        }
    }
    lazy var popUpView : PopUpViewController = {
        let view = PopUpViewController()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.delegate = self
        return view
    }()
   
    let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var priceText : String?{
        didSet{
            guard let text = priceText else{
                priceLabel.text = "Add Price"
                addPrice.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
                return
            }

            priceLabel.text = "\(text) TL"
            addPrice.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
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
    var yearText : String?{
        didSet{
            collecitonView.reloadData()
        }
    }
    var km : String?{
        didSet{
            collecitonView.reloadData()
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
        Utils.waitProgress(msg: nil)
        controller.dismiss(animated: true) {
            for image in images{
                image.resolve { (img) in
                    if let image_data = img!.jpegData(compressionQuality: 0.8){
                        self.imageList.append(image_data)
                        self.collecitonView.reloadData()
                        Utils.dismissProgress()
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
    
    func handleShowPopUp(target : String) {
        view.addSubview(visualEffectView)
        visualEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        visualEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        visualEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        visualEffectView.alpha = 0
        if target == "addPrice"{
            view.addSubview(popUpView)
            popUpView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80).isActive = true
            popUpView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            popUpView.heightAnchor.constraint(equalToConstant: view.frame.width - 200).isActive = true
            popUpView.widthAnchor.constraint(equalToConstant: view.frame.width - 44).isActive = true
            popUpView.target = target
        }
       
        
        UIView.animate(withDuration: 0.5) {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.visualEffectView.alpha = 1
            self.popUpView.alpha = 1
            self.popUpView.transform = CGAffineTransform.identity
            
        }
        return
    }
    func _handleDismissal(target : String) {
       if target == "addPrice"{
            UIView.animate(withDuration: 0.5, animations: {
                self.visualEffectView.alpha = 0
                self.popUpView.alpha = 0
                self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { (_) in
                self.popUpView.removeFromSuperview()
                print("Did remove pop up window..")
            }
        }
       
    }
    private func setToolbar(){
        setNavigationBar()
        navigationItem.title = "Set New Post"
       
        hideKeyboardWhenTappedAround()
        let postItButton = UIButton(type: .system)
        postItButton.backgroundColor = .mainColor()
        postItButton.setTitle("New Post", for: .normal)
        postItButton.setTitleColor(.white, for: .normal)
        postItButton.clipsToBounds = true
        postItButton.layer.cornerRadius = 5
        postItButton.titleLabel?.font = UIFont(name: Utils.font, size: Utils.smallSize)
        postItButton.frame = CGRect(x: 0, y: 0, width: 100, height: 35)
        postItButton.addTarget(self, action: #selector(postIt), for: .touchUpInside)
        let rigtBarButton = UIBarButtonItem(customView: postItButton)
        self.navigationItem.rightBarButtonItem = rigtBarButton
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
    @objc func postIt(){
        text.endEditing(true)
        guard !text.text.isEmpty else{
            Utils.errorProgress(msg: "Your Post Can Not Be Empty")
            text.resignFirstResponder()
            return
        }
        guard let price = priceText else {
            Utils.errorProgress(msg: "You Must Set a Price")
            handleShowPopUp(target: "addPrice")
            return
        }
        guard let brand = brand else {
            Utils.errorProgress(msg: "You Must Select Brand")
            let vc = ChooseBrandController(target: "brand")
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            return }
        guard let carModel = model else{
            Utils.errorProgress(msg: "You Must Select Car Model")
            brandDelegate = self
            let vc = ChooseBrandController(target: brand)
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            
            return
        }
        guard let year = yearText else{
            Utils.errorProgress(msg: "You Must Set Year")
            let vc = AddYearController()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            return
        }
        guard let km = km else {
            Utils.errorProgress(msg: "You Must Select Km")
            let vc = AddKmController()
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
            return
        }
        if imageList.count <= 0{
            Utils.errorProgress(msg: "You Must Add Images")
            addImage()
            return
        }
      
        let date =  Int64(Date().timeIntervalSince1970 * 1000).description
        UploadSerivce.shared.saveToStorageDatas(postDate: date, currentUser: currentUser, datas: imageList) {[weak self] (listOfUrl) in
            guard let sself = self else { return }
            let postId : String = Date().timeIntervalSince1970.description
            let dic = ["brand":brand,
                       "carModel":carModel,
                       "price":Int(price) ?? 0,
                       "year":Int(year) ?? 0,
                       "km":Int(km) ?? 0,
                       "postId" : postId,
                       "locaiton":sself.geoPoint as Any,
                       "locationName":sself.locaitonText ?? "",
                       "senderName":sself.currentUser.name as Any,
                       "senderUid": sself.currentUser.uid as Any,
                       "senderImage":sself.currentUser.thumbImage ?? "",
                       "decription":sself.text.text as Any,
                       "postTime":FieldValue.serverTimestamp(),"imageList":FieldValue.arrayUnion(listOfUrl),
                       "postTimeLong":Date().timeIntervalSince1970] as [String : Any]
            UploadSerivce.shared.setNewPost(postId: postId, dic: dic, uid: sself.currentUser.uid!) { (_val) in
                if _val{
                    Utils.succesProgress(msg: "Succes")
                    sself.navigationController?.popViewController(animated: true)
                }else{
                    Utils.errorProgress(msg: "err")
                }
            }
        }
    }
    @objc func _addPrice(){
        if priceText != nil{
            priceText = nil
        }else{
            handleShowPopUp(target: "addPrice")
        }
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
            cell.backgroundColor = .white
            cell.delegate = self
            cell.yearText = yearText
            cell.km = km
            cell.brand = brand
            cell.carModel = model
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
}

extension NewPostController : FuturesItemDelegate{
    func removeBrand() {
        self.brand = nil
        self.model = nil
        self.collecitonView.reloadData()
    }
    
    func removeModel() {
        self.model = nil
        self.collecitonView.reloadData()
    }
    
    func removeKm() {
        self.km = nil
        self.collecitonView.reloadData()
    }
    
    func removeYear() {
        self.yearText = nil
        self.collecitonView.reloadData()
       
    }
    
    func addBrand() {
        brandDelegate = self
        let vc = ChooseBrandController(target: "brand")
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func addKm() {
       let vc = AddKmController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func addModel() {
        if let brand = brand {
            brandDelegate = self
            let vc = ChooseBrandController(target: brand)
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
       
    }
    
    func addYear() {
  
        let vc = AddYearController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
extension NewPostController : PopUpNumberDelegate {
    func handleDismissal(_ target: String) {
        _handleDismissal(target: target)
    }
    func addPrice(_ target: String?) {
        priceText = target
        self.collecitonView.reloadData()
        _handleDismissal(target: "addPrice")

    }
    
}
extension NewPostController : PopUpYearDelegate {
    func addKm(_target: String) {
        km = _target
        self.collecitonView.reloadData()
    }
    
    func handleDismissal(_ target: String?) {
        _handleDismissal(target: "addYear")
    }
    
    func addYear(_ target: String?) {
        yearText = target
        self.collecitonView.reloadData()
       
    }
    
    
}
extension NewPostController : BrandDelegate {
    func chooseBrand(target: String) {
        self.brand = target
    }
    
    func chooseModel(target: String) {
        self.model = target 
    }
    
    
}
