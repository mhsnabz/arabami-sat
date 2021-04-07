//
//  ConservationController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
import MessageKit
import SDWebImage

class ConservationController: MessagesViewController  {
    
    //MARK:-varibles
    var currentUser : CurrentUser
    var otherUser : OtherUser
    private let selfSender : SelfSender?
    private lazy var messages = [Message]()
    //MARK:-properties
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return control
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    init(currentUser : CurrentUser , otherUser : OtherUser) {
        self.otherUser = otherUser
        self.currentUser = currentUser
        self.selfSender = SelfSender(senderId: currentUser.uid ?? "", displayName: currentUser.name ?? "", profileImageUrl: currentUser.thumbImage ?? "")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  //MARK:-handlers
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
    //MARK:-selectors
    @objc func loadData(){
        
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
            avatarView.sd_setImage(with: URL(string: currentUser.thumbImage), completed: nil)
        }else{
            avatarView.sd_setImage(with: URL(string: otherUser.thumbImage), completed: nil)
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
        
        return NSMutableAttributedString(string: "\(dateString)", attributes: [NSAttributedString.Key.font : UIFont(name: Utilities.fontBold, size: 10)!, NSAttributedString.Key.foregroundColor : UIColor.lightGray])
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
    
}

