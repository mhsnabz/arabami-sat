//
//  ConservationController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
import MessageKit
import SDWebImage
import InputBarAccessoryView
import MobileCoreServices
import CoreLocation
import MapKit
import Lightbox
import Gallery
import Lottie
import FirebaseFirestore
import FirebaseStorage
class ConservationController: MessagesViewController, GalleryControllerDelegate,LightboxControllerDismissalDelegate  {
    
    //MARK:-varibles
    var locationManager : CLLocationManager!
    var currentUser : CurrentUser
    var otherUser : OtherUser
    private let selfSender : SelfSender?
    private lazy var messages = [Message]()
    weak var snapShotListener : ListenerRegistration?
    var page : DocumentSnapshot? = nil
    var firstPage : DocumentSnapshot? = nil
    var actionsSheet : MessagesItemLauncher
    
    var dataModel = [MessageGalleryModel]()
    var data = [SelectedData]()
    var gallery: GalleryController!
    var waitAnimation = AnimationView()
    private var uploadTask : StorageUploadTask?
    //MARK:-properties
    
    let sendingDescription : UILabel = {
        let lbl = UILabel()
        lbl.text = "Images Sending"
        lbl.font = UIFont(name: Utils.fontBold, size: 10)
        lbl.textColor = .black
        return lbl
    }()
    lazy var progressBar : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.addSubview(sendingDescription)
        sendingDescription.anchor(top: v.topAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 4, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 14)
        sendingDescription.centerXAnchor.constraint(equalTo: v.centerXAnchor).isActive = true
        waitAnimation = .init(name : "bar")
        waitAnimation.animationSpeed = 1
        waitAnimation.contentMode = .scaleAspectFill
        waitAnimation.loopMode = .loop
        
        v.addSubview(waitAnimation)
        waitAnimation.anchor(top: sendingDescription.bottomAnchor, left: v.leftAnchor, bottom: nil, rigth: v.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 8)
        
        return v
    }()
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return control
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setMessagesSetting()
        configureNavBar()
        setupInputButton()
        getAllMessages(currentUser: currentUser, otherUser: otherUser)
        view.addSubview(progressBar)
        progressBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 30)
        progressBar.isHidden = true
    }
    init(currentUser : CurrentUser , otherUser : OtherUser) {
        self.otherUser = otherUser
        self.currentUser = currentUser
        self.selfSender = SelfSender(senderId: currentUser.uid ?? "", displayName: currentUser.name ?? "", profileImageUrl: currentUser.thumbImage ?? "")
        actionsSheet = MessagesItemLauncher(currentUser: currentUser)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let deleteBadgeDb = Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list")
            .document(otherUser.uid!).collection("badgeCount").whereField("badge", isEqualTo: "badge")
        let dbc = Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list")
            .document(otherUser.uid!).collection("badgeCount")
        deleteBadgeDb.getDocuments { (querySnap, err) in
            if err == nil {
                guard let snap = querySnap else { return }
                if !snap.isEmpty {
                    for item in snap.documents{
                        dbc.document(item.documentID).delete()
                    }
                }
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let deleteBadgeDb = Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list")
            .document(otherUser.uid!).collection("badgeCount").whereField("badge", isEqualTo: "badge")
        let dbc = Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list")
            .document(otherUser.uid!).collection("badgeCount")
        deleteBadgeDb.getDocuments { (querySnap, err) in
            if err == nil {
                guard let snap = querySnap else { return }
                if !snap.isEmpty {
                    for item in snap.documents{
                        dbc.document(item.documentID).delete()
                    }
                }
            }
        }
        let setCurrentUserOnline =  Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list")
            .document(otherUser.uid!)
        setCurrentUserOnline.setData( ["badgeCount":0], merge: true)
    }
    
  //MARK:-handlers
    private func setupInputButton() {
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(#imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), for: .normal)
        button.onTouchUpInside { [weak self] _ in
            self?.optionsMenu()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 35, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: true)
        
        let sendButton = InputBarButtonItem()
        sendButton.setSize(CGSize(width: 35, height: 35), animated: false)
        sendButton.setImage(#imageLiteral(resourceName: "send").withRenderingMode(.alwaysOriginal), for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([sendButton], forStack: .right, animated: false)
        sendButton.addTarget(self, action: #selector(sendMessages), for: .touchUpInside)
    }
    
    fileprivate func configureNavBar(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(goProfile))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "options_dots").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(settingMenu))
        navigationItem.title = otherUser.name
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        
        imageview.contentMode = .scaleAspectFit
        imageview.layer.cornerRadius = 35 / 2
        imageview.layer.masksToBounds = true
        imageview.layer.borderWidth = 0.3
        imageview.layer.borderColor = UIColor.darkGray.cgColor
        imageview.addGestureRecognizer(tap)
        imageview.isUserInteractionEnabled = true
        containView.addSubview(imageview)
        let leftButton = UIBarButtonItem(customView: containView)
        
        imageview.sd_imageIndicator = SDWebImageActivityIndicator.white
        imageview.sd_setImage(with: URL(string: otherUser.thumbImage ?? ""))
        self.navigationItem.leftItemsSupplementBackButton = true
        
        navigationItem.leftBarButtonItems = [leftButton]
    }
    fileprivate func setMessagesSetting() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        //messageInputBar.delegate = self
        messagesCollectionView.register(MessageDateReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        scrollsToLastItemOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        //      messagesCollectionView.showMessageTimestampOnSwipeLeft = true // default false
        
        messagesCollectionView.refreshControl = refreshControl
        
        
    }
    
    func getAllMessages(currentUser : CurrentUser , otherUser : OtherUser){
        let db = Firestore.firestore().collection("messages")
            .document(currentUser.uid!)
            .collection(otherUser.uid!).limit(toLast: 10).order(by: "id")
        snapShotListener = db.addSnapshotListener({[weak self] (querySnap, err) in
            if let err = err {
                print("DEBUG:: messages load err \(err.localizedDescription)")
            }else{
                guard let sself = self else { return }
                guard let snap = querySnap else { return }
                for item in snap.documentChanges{
                    if item.type == .added {
                        var profileUrl = ""
                        if (item.document.get("senderUid") as! String) == currentUser.uid{
                            profileUrl = currentUser.thumbImage ?? ""
                        }else{
                            profileUrl = otherUser.thumbImage ?? ""
                        }
                        let sender = SelfSender(senderId: item.document.get("senderUid") as! String, displayName: item.document.get("name") as! String , profileImageUrl: profileUrl)
                        let date = item.document.get("date") as? Timestamp
                        if (item.document.get("type")as! String == "photo") {
                            let h = item.document.get("heigth") as! CGFloat
                            let w = item.document.get("width") as! CGFloat
                            let url = item.document.get("content") as! String
                            guard let val = URL(string: url) else { return }
                            let media = Media(url: val, image: nil, placeholderImage:  #imageLiteral(resourceName: "place_holder"), size: CGSize(width: w, height: h))
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.photo(media)))
                        }else if (item.document.get("type") as! String) == "text" {
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.text(item.document.get("content") as! String)))
                        }else if (item.document.get("type") as! String) == "location"{
                            let h = item.document.get("heigth") as! CGFloat
                            let w = item.document.get("width") as! CGFloat
                            let val = item.document.get("geoPoint") as! GeoPoint
                            let locaiton = Location(location: CLLocation(latitude: val.latitude, longitude: val.longitude), size: CGSize(width: w, height: h))
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind: .location(locaiton)))
                        }
                        sself.messagesCollectionView.reloadDataAndKeepOffset()
                        sself.page = snap.documents.last
                        sself.firstPage = snap.documents.first
                            
                    }
                }
            }
        })
        guard let page = self.page else { return }
        let next = Firestore.firestore().collection("messages")
            .document(currentUser.uid!)
            .collection(otherUser.uid!).order(by: "id").start(afterDocument: page).limit(to: 1)
        snapShotListener = next.addSnapshotListener({[weak self] (querySnap, err) in
            if let err = err {
                print("DEBUG :: load next message err :\(err.localizedDescription)")
            }else{
                guard let sself = self else { return }
                guard let snap = querySnap else { return }
                for item in snap.documentChanges{
                    if item.type == .added {
                        var profileUrl = ""
                        if (item.document.get("senderUid") as! String) == currentUser.uid{
                            profileUrl = currentUser.thumbImage ?? ""
                        }else{
                            profileUrl = otherUser.thumbImage ?? ""
                        }
                        
                        let sender = SelfSender(senderId: item.document.get("senderUid") as! String, displayName: item.document.get("name") as! String , profileImageUrl: profileUrl)
                        let date = item.document.get("date") as? Timestamp
                        if (item.document.get("type") as! String) == "photo" {
                            let h = item.document.get("heigth") as! CGFloat
                            let w = item.document.get("width") as! CGFloat
                            let url = item.document.get("content") as! String
                            guard let val = URL(string: url) else { return }
                            let media = Media(url: val, image: nil, placeholderImage:  #imageLiteral(resourceName: "place_holder"), size: CGSize(width: w, height: h))
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.photo(media)))
                        }
                        else if (item.document.get("type") as! String) == "text"{
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.text(item.document.get("content") as! String)))
                        }else if (item.document.get("type") as! String) == "location"{
                            let h = item.document.get("heigth") as! CGFloat
                            let w = item.document.get("width") as! CGFloat
                            let val = item.document.get("geoPoint") as! GeoPoint
                            let locaiton = Location(location: CLLocation(latitude: val.latitude, longitude: val.longitude), size: CGSize(width: w, height: h))
                            sself.messages.append(Message(sender: sender, messageId: item.document.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind: .location(locaiton)))
                        }
                        sself.messagesCollectionView.reloadDataAndKeepOffset()
                        sself.page = snap.documents.last
                        sself.firstPage = snap.documents.first
                    }
                }
            }
        })
    }
    private func loadBeforePage(){
        guard let page = firstPage else {
            refreshControl.endRefreshing()
            return }
        let db = Firestore.firestore().collection("messages")
            .document(currentUser.uid!)
            .collection(otherUser.uid!).order(by: "id").end(beforeDocument: page).limit(toLast: 10)
        db.getDocuments {[weak self] (querySnap, err) in
            guard let sself = self else { return }
            if let err = err {
                sself.refreshControl.endRefreshing()
                print("DEBUG:: load before message err : \(err.localizedDescription)")
            }else{
                guard let snap = querySnap else {
                    sself.refreshControl.endRefreshing()
                    return
                }
                if snap.isEmpty {
                    sself.refreshControl.endRefreshing()
                    return
                }
                for item in snap.documents{
                    var profileUrl = ""
                    if (item.get("senderUid") as! String) == sself.currentUser.uid{
                        profileUrl = sself.currentUser.thumbImage ?? ""
                    }else{
                        profileUrl = sself.otherUser.thumbImage ?? ""
                    }
                    
                    let sender = SelfSender(senderId: item.get("senderUid") as! String, displayName: item.get("name") as! String , profileImageUrl: profileUrl)
                    
                    let date = item.get("date") as? Timestamp
                    if (item.get("type") as! String) == "photo" {
                        let h = item.get("heigth") as! CGFloat
                        let w = item.get("width") as! CGFloat
                        let url = item.get("content") as! String
                        guard let val = URL(string: url) else { return }
                        let media = Media(url: val, image: nil, placeholderImage:  #imageLiteral(resourceName: "place_holder"), size: CGSize(width: w, height: h))
                        sself.messages.append(Message(sender: sender, messageId: item.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.photo(media)))
                    }
                    else if (item.get("type") as! String) == "text"{
                        sself.messages.append(Message(sender: sender, messageId: item.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind:.text(item.get("content") as! String)))
                    }else if (item.get("type") as! String) == "location"{
                        let h = item.get("heigth") as! CGFloat
                        let w = item.get("width") as! CGFloat
                        let val = item.get("geoPoint") as! GeoPoint
                        let locaiton = Location(location: CLLocation(latitude: val.latitude, longitude: val.longitude), size: CGSize(width: w, height: h))
                        sself.messages.append(Message(sender: sender, messageId: item.get("id") as! String, sentDate: date?.dateValue() ?? Date(), kind: .location(locaiton)))
                    }
                    sself.messages.sort { (msg1, msg2) -> Bool in
                        return msg1.sentDate < msg2.sentDate
                    }
                    sself.messagesCollectionView.reloadDataAndKeepOffset()
                    sself.firstPage = snap.documents.first
                }
                sself.refreshControl.endRefreshing()
            }
        }
    }
    
    //MARK:-imagePicker
    private func checkDataModelHasValue(data : Data) ->Bool{
        dataModel.contains { (model) -> Bool in
            return  model.data == data
        }
    }
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func getImagesData(images: [Image] , completion:@escaping([SelectedData])->Void){
        
        completion(data)
    }
    private let dispatchQueue = DispatchQueue(label: "taskQueue", qos: .background)
    private let semaphore = DispatchSemaphore(value: 1)
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        
        controller.dismiss(animated: true) {
            if images.count > 0{
                self.waitAnimation.play()
                self.progressBar.isHidden = false
            }
            
            for image  in images {
                
                image.resolve { (img) in
                    
                    if let img_data = img!.jpegData(compressionQuality: 0.4),
                       let heigth = img?.size.height,
                       let width = img?.size.width{
                        self.uploadImage(heigth : heigth , width: width ,data: img_data,currentUser: self.currentUser.uid!, uploadCount : images.count, otherUser: self.otherUser.uid!, type: "jpeg") { (url) in
                            print("url \(url)")
                            
                        }
                        //
                        
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
    
    //MARK:--sendImage
    func sendImageMessage(currentUser : CurrentUser,width : CGFloat , heigth : CGFloat , otherUser : OtherUser , url : String  , completion : @escaping(Bool) ->Void){
        guard let url = URL(string: url) else {
            completion(false)
            return }
        let media = Media(url: url, image: nil, placeholderImage: #imageLiteral(resourceName: "place_holder"), size: CGSize(width: width, height: heigth))
        let message = Message(sender: selfSender!, messageId: Int64(Date().timeIntervalSince1970 * 1000).description, sentDate: Date(), kind: .photo(media))
      
        MessagesService.shared.sendMessage(newMessage: message, fileName: nil, currentUser: currentUser, otherUser: otherUser, time: Int64(Date().timeIntervalSince1970 * 1000))
      
    }
    func uploadImage(heigth : CGFloat , width : CGFloat,data : Data , currentUser : String ,uploadCount : Int, otherUser : String , type : String ,completion:@escaping(String) ->Void){
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+5) {
            self.semaphore.wait()
            let metaDataForData = StorageMetadata()
            let dataName = Date().millisecondsSince1970.description
            
      
                metaDataForData.contentType = "image/jpeg"
                let storageRef = Storage.storage().reference()
                    .child("messages")
                    .child(currentUser)
                    .child(otherUser)
                    .child(dataName + ".jpg")
                self.uploadTask = storageRef.putData(data, metadata: metaDataForData, completion: { (metaData, err) in
                    if err != nil {
                        print("err \(err as Any)")
                    }else{
                        Storage.storage().reference()
                            .child("messages")
                            .child(currentUser)
                            .child(otherUser)
                            .child(dataName + ".jpg").downloadURL { (url, err) in
                                guard let dataUrl = url?.absoluteString else {
                                    
                                    return
                                }
                                self.sendImageMessage(currentUser: self.currentUser, width: width, heigth: heigth, otherUser: self.otherUser, url: dataUrl) { (val) in
                                  
                                }
                                completion(dataUrl)
                                self.semaphore.signal()
                            }
                    }
                })
            
            self.uploadFiles(uploadTask: self.uploadTask! , count : uploadCount , percentTotal: 5 )
        }
        
    }
    var succesCount : Int = 0
    func uploadFiles(uploadTask : StorageUploadTask , count : Int , percentTotal : Float )
    {
        
        uploadTask.observe(.progress) {  snapshot in
            print(snapshot.progress as Any) //
            
            let percentComplete = 100.0 * Float(snapshot.progress!.completedUnitCount)
                / Float(snapshot.progress!.totalUnitCount)
            print("upload : \(percentComplete )")
            
            self.sendingDescription.text = "\(self.succesCount + 1). Image %\(Int(percentComplete))"
            
            
        }
        
        uploadTask.observe(.success) { (snap) in
            
            switch (snap.status) {
            
            case .unknown:
                break
            case .resume:
                break
            case .progress:
                
                break
            case .pause:
                break
            case .success:
                if count > 1 {
                    self.succesCount += 1
                    self.sendingDescription.text = "\(count) File Sending \(self.succesCount). File Sent"
                    if self.succesCount == count {
                        self.waitAnimation.stop()
                        self.progressBar.isHidden = true
                        self.sendingDescription.text = "Files Sending"
                    }
                    print("succesCount \(self.succesCount)")
                }else{
                    self.waitAnimation.stop()
                    self.progressBar.isHidden = true
                    self.sendingDescription.text =  "Files Sending"
                }
                
                break
                
            case .failure:
                print("error ")
                break
            @unknown default:
                break
            }
            
        }
        
    }
    //MARK:-selectors
    @objc func loadData(){
        loadBeforePage()
    }
    @objc func goProfile(){
        
    }
    @objc func settingMenu(){
        
    }
    @objc func optionsMenu()
    {
        
        messageInputBar.inputTextView.resignFirstResponder()
        actionsSheet.show()
        actionsSheet.delegate = self
        actionsSheet.dismisDelgate = self
        inputAccessoryView?.isHidden = true
    }
    @objc func sendMessages(){
        guard let text = messageInputBar.inputTextView.text else { return }
        messageInputBar.inputTextView.text = ""
        let message =  Message(sender: selfSender!, messageId: Int64(Date().timeIntervalSince1970 * 1000).description, sentDate: Date(), kind: .text(text) )
        MessagesService.shared.sendMessage(newMessage: message, fileName: nil, currentUser: currentUser, otherUser: otherUser , time : Int64(Date().timeIntervalSince1970 * 1000))
        messagesCollectionView.scrollToBottom()
    }

}
//MARK:--MessagesDataSource , MessagesLayoutDelegate , MessagesDisplayDelegate
extension  ConservationController :  MessagesDataSource , MessagesLayoutDelegate , MessagesDisplayDelegate{
    func currentSender() -> SenderType {
        return selfSender!
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]

    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            avatarView.sd_setImage(with: URL(string: currentUser.thumbImage ?? ""), completed: nil)
        }else{
            avatarView.sd_setImage(with: URL(string: otherUser.thumbImage ?? ""), completed: nil)
        }
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            return .mainColor()
        }
        return  UIColor.init(white: 0.80, alpha: 0.5)
    }
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        let sender = message.sender
        if sender.senderId == selfSender?.senderId {
            return .white
        }
        return .black
    }
    func headerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        let size = CGSize(width: messagesCollectionView.frame.width, height: 25)
        if section == 0 {
            return size
        }
        
        let currentIndexPath = IndexPath(row: 0, section: section)
        let lastIndexPath = IndexPath(row: 0, section: section - 1)
        let lastMessage = messageForItem(at: lastIndexPath, in: messagesCollectionView)
        let currentMessage = messageForItem(at: currentIndexPath, in: messagesCollectionView)
        
        if currentMessage.sentDate.isInSameDayOf(date: lastMessage.sentDate) {
            return .zero
        }
        
        return size
    }
    func messageHeaderView( for indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView ) -> MessageReusableView {
        let messsage = messageForItem(at: indexPath, in: messagesCollectionView)
        let header = messagesCollectionView.dequeueReusableHeaderView(MessageDateReusableView.self, for: indexPath)
        header.label.text = MessageKitDateFormatter.shared.string(from: messsage.sentDate)
        return header
    }
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 14
    }
    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = MessageKitDateFormatter.shared.string(from: messages[[indexPath.section][indexPath.item]].sentDate)
        
        return NSMutableAttributedString(string: "\(dateString)", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.fontBold, size: 10)!, NSAttributedString.Key.foregroundColor : UIColor.lightGray])
    }
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard  let message = message as? Message else {
            return
        }
        
        switch message.kind{
        case .photo(let media):
        guard let url = media.url else { return }
            imageView.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageView.sd_setImage(with: url)
            break
        case .text(_):
            break
        case .attributedText(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        case .linkPreview(_):
        break
        }
    }
}

//MARK:-MessageCellDelegate
extension ConservationController : MessageCellDelegate {
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else { return }
        let message = messages[indexPath.section]
        switch message.kind{
        
        case .text(_):
            break
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(let item):
            let coordinates = item.location.coordinate
            let lat = coordinates.latitude
            let long = coordinates.longitude
            let coordinate = CLLocationCoordinate2DMake(lat, long)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .custom(_):
            break
        case .linkPreview(_):
            break
        }
    }
}

extension ConservationController : InputBarAccessoryViewDelegate{
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        print("text : \(text)")
    }
}

extension ConservationController : MessagesItemDelagate {
    func didSelect(option: MesagesItemOption) {
        switch option {
        
        case .addImage(_):
            Config.Camera.recordLocation = false
            Config.tabsToShow = [.imageTab]
            gallery = GalleryController()
            gallery.delegate = self
            gallery.modalPresentationStyle = .fullScreen
            present(gallery, animated: true, completion: nil)
            break
        case .addLocation(_):
            let vc = LocationPicker(currentUser: currentUser)
            vc.locationManager = locationManager
            vc.sendLocationDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    
}
extension ConservationController : DismisDelegate {
    func dismisMenu() {
        inputAccessoryView?.isHidden = false
    }
    
    
}
extension ConservationController : SendLocationDelegate {
    func getLocation(geoPoint: GeoPoint, locaitonName: String) {
        let long: Double = geoPoint.longitude
        let lat: Double = geoPoint.latitude
        let locaitonItem = Location(location: CLLocation(latitude: lat, longitude: long), size: .zero)
        let message = Message(sender: self.selfSender!, messageId: Int64(Date().timeIntervalSince1970 * 1000).description, sentDate: Date(), kind: .location(locaitonItem))
        MessagesService.shared.sendMessage(newMessage: message, fileName: nil, currentUser: self.currentUser, otherUser: self.otherUser, time: Int64(Date().timeIntervalSince1970 * 1000))
    }
    
    
}
