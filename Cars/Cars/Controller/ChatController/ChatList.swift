//
//  ChatList.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 7.04.2021.
//

import UIKit
import FirebaseFirestore
class ChatList: UIViewController {
    //MARK:-variables
    var list = [ChatListModel]()
    var collectionview: UICollectionView!
    var currentUser : CurrentUser
    weak var snapShotListener : ListenerRegistration?
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        navigationItem.title = "Chat"
        view.backgroundColor  = .white
        configureLeftBarButton()
        configureCollectionView()
        getMessagesList()
    }
    
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.snapShotListener?.remove()
    }
    
    //MARK:-handlers
    private func configureLeftBarButton(){
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-dark").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismissView))
        navigationItem.leftBarButtonItem = barButton
    }
    private func configureCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionview = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = .white
        view.addSubview(collectionview)
        collectionview.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        collectionview.register(ChatListItem.self, forCellWithReuseIdentifier: "id")
    }
   
    func getMessagesList(){
        let db = Firestore.firestore().collection("user")
            .document(currentUser.uid!)
            .collection("msg-list").order(by: "time",descending: true)
        snapShotListener = db.addSnapshotListener({[weak self] (querySnap, err) in
            guard let sself = self else { return }
            if err == nil {
                guard let snap = querySnap else { return }
                for item in snap.documentChanges{
                    if item.type == .added {
                        sself.list.append(ChatListModel.init(uid : item.document.documentID,dic: item.document.data()))
                        sself.collectionview.reloadData()
                    }else if item.type == .modified{
                        for user in sself.list{
                            if user.uid == item.document.documentID {
                                let index = sself.list.firstIndex{ $0.uid == item.document.documentID}
                                if let index = index {
                                    sself.list[index] =  ChatListModel.init(uid: item.document.documentID, dic: item.document.data())
                                }
                                
                            }
                           
                        }
                        sself.list.sort { (list1, list2) -> Bool in
                            return list1.time?.dateValue() ?? Date() > list2.time?.dateValue() ?? Date()
                        }
                        sself.collectionview.reloadData()
                    }else if item.type == .removed {
                        let index = sself.list.firstIndex{ $0.uid == item.document.documentID}
                        if let index = index {
                            sself.list.remove(at: index)
                        }
                        sself.collectionview.reloadData()
                    }
                }
            }
        })
    }
    //MARK:-seletor
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension ChatList : UICollectionViewDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! ChatListItem
        cell.user = list[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        Utils.waitProgress(msg: nil)
        UserService.shared.getOtherUser(uid: list[indexPath.row].uid) {[weak self] (user) in
            guard let sself = self else { return }
            guard let user = user else { return }
            let vc = ConservationController(currentUser: sself.currentUser, otherUser: user)
            sself.navigationController?.pushViewController(vc, animated: true)
            Utils.dismissProgress()
        }
    }
    

}
