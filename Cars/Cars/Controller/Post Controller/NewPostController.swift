//
//  NewPostController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
import SDWebImage
class NewPostController: UIViewController {
    //MARK:-variables
    var currentUser : CurrentUser
    var heigth : CGFloat = 0.0
    //MARK:-properties
    
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
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
        configureCollectionView()
    }
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-handlers
    private func setToolbar(){
        setNavigationBar()
        navigationItem.title = "New Post"
        let rigthBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(uploadPost))
        navigationController?.navigationItem.rightBarButtonItem = rigthBarButton
        hideKeyboardWhenTappedAround()
    }
    
    private func configureCollectionView(){
        view.addSubview(headerView)
        headerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 12, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 50)
        
        view.addSubview(text)
        
        text.anchor(top: headerView.bottomAnchor, left: headerView.leftAnchor, bottom: nil, rigth: headerView.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 100)
        text.delegate = self
        text.isScrollEnabled = true
        textViewDidChange(text)
        
        configureCurrentUser()
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
    
    //MARK:-selectors
    @objc func uploadPost(){
        
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
        }
        else
        {
            textView.frame.size.height = textView.contentSize.height
            heigth = textView.contentSize.height
            textView.isScrollEnabled = false // textView.isScrollEnabled = false for swift 4.0
            
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
                    textView.isScrollEnabled = true // textView.isScrollEnabled = false for swift 4.0
                    constraint.constant = estimatedSize.height
                    heigth = estimatedSize.height
                }
            }
        }
    }
}
