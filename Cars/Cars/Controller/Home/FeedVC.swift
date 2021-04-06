//
//  FeedVC.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
import FirebaseAuth
import SDWebImage
import  FirebaseFirestore
class FeedVC: UIViewController, SearchingDelegate {
    func queryCallBack(query: String?) {
        self.sortByPrice = nil
        self.sortByYear = nil
        self.sortByDate = nil
        self.query = query
    }
    
    //MARK:-variables
    var page : DocumentSnapshot? = nil
    var loadMore : Bool = false
    var lastDocumentSnapshot: DocumentSnapshot!
    private var dropDownMenu : DropDownMenu
    var currentUser : CurrentUser
    let transparentView = UIView()
    weak var delegate : HomeControllerDelegate?
    var isMenuOpen : Bool = false
    var collectionview: UICollectionView!
    var isSearching = false
    let searchBar = UISearchBar()
    var searchList = SearchingList()
    private(set) lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return control
    }()
    var carList = [Car]()
    //MARK:-properties
    let tableView = UITableView()
    var query : String?{
        didSet{
            getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
        }
    }
    
    var sortByPrice : Bool?{
        didSet{
            guard let val = sortByPrice else { return }
            if val {
                getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
            }
            
        }
    }
    var sortByYear : Bool?{
        didSet{
            guard let val = sortByYear else { return }
            if val {
                getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
            }
            
        }
    }
    var sortByDate : Bool?{
        didSet{
            guard let val = sortByDate else { return }
            if val {
                getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
            }
          
        }
    }
    
    let newPostButton  : UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.backgroundColor = .white
        return btn
    }()
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Feed"
        setNavBatButton()
        
        configureUI()
        getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
        searchList.delegate = self
        
    }
    
    
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        self.dropDownMenu = DropDownMenu(currentUser: currentUser)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-seletors
    @objc func logOut(){
        do{
            try! Auth.auth().signOut()
            let vc = SplashScreen()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    @objc func sortQueries(){
        print("DEBUG:: sort queries click")
        // addTransprantView(frame: view.frame)
        dropDownMenu.showMenu()
        dropDownMenu.delegate = self
    }
    @objc func removeTransparentView(){
        
    }
    @objc func newPost(){
        self.navigationController?.pushViewController(NewPostController(currentUser: currentUser), animated: true)
    }
    @objc func showMenu(){
        self.delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func loadData(){
        getPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: query)
    }
    @objc func searchBarClick(){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search Brand"
        searchList.showSuggestion()
        
    }
    //MARK:-handlers
    
    private func configureUI(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionview = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = .mainColorTransparent()
        collectionview.alwaysBounceVertical = true
        collectionview.refreshControl = refreshControl
        refreshControl.tintColor = .white
        
        view.addSubview(collectionview)
        collectionview.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom:view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        collectionview.register(FeedCell.self, forCellWithReuseIdentifier: "id")
        collectionview.register(LoadMoreCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "moreId")
        view.addSubview(newPostButton)
        newPostButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 25, marginRigth: 12, width: 50, heigth: 50)
        newPostButton.addTarget(self, action: #selector(newPost), for: .touchUpInside)
        newPostButton.layer.cornerRadius = 25
        
    }
    
    private func setNavBatButton(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showMenu))
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
        if let thumbImage = currentUser.thumbImage{
            imageview.sd_imageIndicator = SDWebImageActivityIndicator.white
            imageview.sd_setImage(with: URL(string: thumbImage))
        }else{
            imageview.image = #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysOriginal)
            imageview.contentMode = .scaleAspectFit
        }
        
        self.navigationItem.leftItemsSupplementBackButton = true
        
        navigationItem.leftBarButtonItems = [leftButton]
        
        searchBar.sizeToFit()
        searchBar.delegate = self
        showSearchBar(shouldShow: true)
        
    }
    func showSearchBar(shouldShow : Bool){
        if shouldShow {
            let item1 =  UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarClick))
            let item2 =  UIBarButtonItem(image: #imageLiteral(resourceName: "sort_by").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(sortQueries))
            navigationItem.rightBarButtonItems  = [item1,item2]
            
            
        }else{
            navigationItem.rightBarButtonItem = nil
            
            
        }
    }
    func search( shouldShow : Bool ){
        showSearchBar(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
        
    }
    
    
    private func addTransprantView(frame : CGRect){
        guard  let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else { return }
        transparentView.frame = window.frame
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        tableView.reloadData()
        transparentView.alpha = 0
        window.addSubview(transparentView)
        tableView.frame = CGRect(x: frame.origin.x, y: window.safeAreaInsets.top, width: (window.frame.width / 2), height: 0)
        
        window.addSubview(tableView)
        tableView.layer.cornerRadius = 5
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(removeTransparentView))
        transparentView.addGestureRecognizer(tapgesture)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.transparentView.alpha = 0.5
            self.tableView.frame = CGRect(x: window.frame.width - (window.frame.width / 2) - 12, y: window.safeAreaInsets.top + 56, width: window.frame.width / 2, height: 250)
        }, completion: nil)
    }
    
    fileprivate func getPost(sortByPrice : Bool? , sortByYear : Bool?, sortByDate : Bool? , sortByQuery : String?){
        carList = [Car]()
        loadMore  = true
        collectionview.reloadData()
        fetchPost(sortByPrice: sortByPrice, sortByYear: sortByYear, sortByDate: sortByDate, sortByQuery: sortByQuery) {[weak self] (list) in
            guard let sself = self else { return }
            sself.carList = list
            if list.count == 0 {
                sself.loadMore = false
                sself.collectionview.reloadData()
                sself.collectionview.refreshControl?.endRefreshing()
            }else{
                sself.collectionview.reloadData()
                sself.collectionview.refreshControl?.endRefreshing()
            }
        }
        
        
        
    }
    func fetchPost(sortByPrice : Bool? , sortByYear : Bool? , sortByDate : Bool? , sortByQuery : String?,completion : @escaping([Car])->()){
        collectionview.refreshControl?.beginRefreshing()
        var post = [Car]()
        let db = Firestore.firestore().collection("feed-post") as CollectionReference
        if let _ = sortByPrice {
            db.order(by: "price",descending: true).limit(to: 5)
            
        }
        else if let _  = sortByDate {
            db.order(by: "postTimeLong",descending: true).limit(to: 5)
        }else if let _ = sortByYear {
            db.order(by: "year",descending: true).limit(to: 5)
        }else if let query = sortByQuery  {
            db.whereField("brand", isEqualTo: query  as String).limit(to: 5)
        }else{
            db.limit(to: 5)
        }
        db.getDocuments {[weak self] (querySnap, err) in
            guard let sself = self else { return }
            if let err = err {
                print("DEBUG:: fetch post err : \(err.localizedDescription)")
            }else{
                guard let snap = querySnap else {
                    completion([])
                    sself.collectionview.refreshControl?.endRefreshing()
                    return
                }
                if snap.isEmpty {
                    completion([])
                    sself.collectionview.refreshControl?.endRefreshing()
                    print("DEBUG :: snap is empty")
                }
                for item in snap.documents {
                    let db = Firestore.firestore().collection("feed-post").document(item.documentID)
                    db.getDocument { (docSnap, err) in
                        if let err = err {
                            print("DEBUG:: err fetch single post \(err.localizedDescription)")
                        }else{
                            guard let snap = docSnap else { return }
                            if snap.exists{
                                post.append(Car.init(dic: snap.data()!))
                            }
                        }
                        completion(post)
                    }
                }
                sself.page = snap.documents.last
                sself.loadMore = true
                sself.collectionview.refreshControl?.endRefreshing()

            }
        }
    }
}

extension FeedVC : QueriesDelegate {
    func didSelect(option: QueriesOptions) {
        switch option{
        
        case .sortByPrice:
            print("DEBUG:: sortByPrice")
            self.sortByYear = nil
            self.sortByDate = nil
            self.sortByPrice = true
        case .sortByDate:
            print("DEBUG:: sortByDate")
            self.sortByYear = nil
            self.sortByDate = true
            self.sortByPrice = nil
        case .sortByYear:
            print("DEBUG:: sortByYear")
            self.sortByYear = true
            self.sortByDate = nil
            self.sortByPrice = nil
        }
    }
    
    
}
extension FeedVC : UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return carList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCell(withReuseIdentifier: "id", for: indexPath) as! FeedCell
        cell.backgroundColor = .white
        cell.model = carList[indexPath.row]
        cell.imageSlider.frame = CGRect(x: 0, y: 61, width: view.frame.width, height: view.frame.width)
        let h = carList[indexPath.row].decription!.height(withConstrainedWidth: view.frame.width - 24, font: UIFont(name: Utils.font, size: 11)!)
        if h > 15{
            cell.descp.frame = CGRect(x: 12, y: view.frame.width + 61, width: view.frame.width - 24, height: h + 4)
        }else{
            cell.descp.frame = CGRect(x: 12, y: view.frame.width + 61, width: view.frame.width - 24, height: 19)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "moreId", for: indexPath)
            as! LoadMoreCell
        cell.activityView.startAnimating()
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if loadMore{
            return .zero
            //            return CGSize(width: view.frame.width, height: 50)
        }else{
            return .zero
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let h = carList[indexPath.row].decription!.height(withConstrainedWidth: view.frame.width - 24, font: UIFont(name: Utils.font, size: 11)!)
        if h > 30 {
            return CGSize(width: view.frame.width, height: view.frame.width + h + 4 + 20 + 61)
        }else{
            return CGSize(width: view.frame.width, height: view.frame.width + 15 + 4 + 20 + 61)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if carList[indexPath.row].senderUid! != currentUser.uid!  {
            Utils.waitProgress(msg: nil)
            UserService.shared.getOtherUser(uid: carList[indexPath.row].senderUid!) {[weak self] (user) in
                guard let sself = self else { return }
                guard let user = user else {
                    Utils.dismissProgress()
                    return
                }
                let vc = SinglePost(currentUser : sself.currentUser , car : sself.carList[indexPath.row])
                vc.otherUser = user
                sself.navigationController?.pushViewController(vc, animated: true)
                Utils.dismissProgress()
            }
        }else{
            let vc = SinglePost(currentUser : currentUser , car : carList[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}
extension FeedVC : UISearchBarDelegate{
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("start")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("cancel")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == " " {
            isSearching = false
            self.tableView.reloadData()
        }
        else
        {
            
            var list = [String]()
            isSearching = true
            Firestore.firestore().collection("feed-post").order(by: "brand").whereField("brand", isGreaterThanOrEqualTo : searchText).whereField("brand", isLessThanOrEqualTo: "\(searchText)uf8ff").getDocuments { (querySnap, err) in
                if let err = err {
                    print("DEBUG :: searchin query err :\(err.localizedDescription)")
                }
                guard let snap = querySnap else { return }
                if !snap.isEmpty{
                    for item in snap.documents{
                        print("DEBUG:: \(item.get("carModel") as! String)")
                        if !list.contains(item.get("brand") as! String) {
                            list.append(item.get("brand") as! String)
                        }
                        
                        print("DEBUG:: \(list)")
                    }
                    self.searchList.searchResult = list
                }else{
                    self.searchList.searchResult = []
                }
            }
            
        }
    }
}
