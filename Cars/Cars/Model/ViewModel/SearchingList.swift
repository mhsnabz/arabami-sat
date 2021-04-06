//
//  SearchingList.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 6.04.2021.
//

import UIKit
class SearchingList : NSObject{
    //MARK:-varibales
    weak var delegate : SearchingDelegate?
    var maxCount : Int = 5
    var searchResult : [String]?{
        didSet{
           tableView.reloadData()
            guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
            if let result = searchResult {
                self.blackView.alpha = 1
                if result.count > 5 {
                    self.tableViewHeight = CGFloat(maxCount * 50)
                    self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: CGFloat(maxCount * 50))
                    
                }else{
                    self.tableViewHeight = CGFloat(result.count * 50)
                    self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: CGFloat(result.count * 50))
                }
            }else{
                self.blackView.alpha = 0
                self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: 0)
            }
        }
    }
    private let tableView = UITableView()
    private var window : UIWindow?
    private var tableViewHeight : CGFloat?
    //MARK:-properties
    private lazy var blackView : UIView = {
       let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleDismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    //MARK:-lifeCycle
    override init() {
        super.init()
        configureTableView()
    }
    
    //MARK:-handlers
    private func configureTableView(){
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(SearchingCell.self, forCellReuseIdentifier: "id")
    }
    func showSuggestion(){
        self.tableView.reloadData()
        guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        if let result = searchResult {
            self.tableViewHeight = CGFloat(result.count * 50)
            UIView.animate(withDuration: 0.4, animations: {
                self.blackView.alpha = 1
                self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24, height: CGFloat(result.count * 50))
            }, completion: nil)
        }
        else{
            self.tableViewHeight = CGFloat(50)
            UIView.animate(withDuration: 0.4, animations: {
                self.blackView.alpha = 1
                self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: 50)
            }, completion: nil)
        }
        
       
    }
    //MARK:-selectors
    @objc func handleDismiss(){
        guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24, height: 0)
        }, completion: nil)
    }
    
    
}
extension SearchingList : UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = searchResult?.count else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! SearchingCell
        cell.item = searchResult?[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.queryCallBack(query : searchResult?[indexPath.row])
        handleDismiss()
    }
    
}
class SearchingCell : UITableViewCell {
    var item : String?{
        didSet{
            guard let item = item else { return }
            logo.image = UIImage(named: "\(item)")
            brand.text = item
        }
    }
    
    let logo : UIImageView = {
       let img = UIImageView()
        img.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.darkGray.cgColor
        return img
    }()
    let brand : UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 18)
        lbl.textColor = .black
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "id")
        addSubview(logo)
        logo.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 40, heigth: 40)
        logo.layer.cornerRadius = 20
        logo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(brand)
        brand.anchor(top: nil, left: logo.rightAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 20)
        brand.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
