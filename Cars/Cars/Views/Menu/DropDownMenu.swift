//
//  DropDownMenu.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
class DropDownMenu : NSObject{
    //MARK:-varibales
    private let currentUser : CurrentUser
    private let tableView = UITableView()
    private var window : UIWindow?
    private lazy var viewModel = QueriesVM(currentUser: currentUser)
    weak var delegate : QueriesDelegate?
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
     init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init()
        configureTableView()
    }
    
    //MARK:-handlers
  
    
     func showMenu(){
        self.tableView.reloadData()
        guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
        self.window = window
        window.addSubview(blackView)
        blackView.frame = window.frame
        window.addSubview(tableView)
        self.tableViewHeight = CGFloat(viewModel.options.count * 50)
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0.5
            self.tableView.frame = CGRect(x: window.frame.width - (window.frame.width / 3) - 12, y: window.safeAreaInsets.top + 56, width: window.frame.width / 3, height:  CGFloat(self.viewModel.options.count * 50))
        }, completion: nil)
    }
    func configureTableView(){
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        tableView.register(DropDownMenuCell.self, forCellReuseIdentifier: "id")
    }
    
    
    //MARK:-selectors
    @objc  func handleDismiss(){
        guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
        UIView.animate(withDuration: 0.4, animations: {
            self.blackView.alpha = 0
            self.tableView.frame = CGRect(x: window.frame.width - (window.frame.width / 3) - 12, y: window.safeAreaInsets.top + 56, width: window.frame.width / 3, height: 0)
        }, completion: nil)
    }
}
extension DropDownMenu : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! DropDownMenuCell
        cell.titleText = viewModel.options[indexPath.row].description
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        delegate?.didSelect(option: option)
        handleDismiss()
    }
    
    
}
class DropDownMenuCell : UITableViewCell {
    
    var titleText : String?{
        didSet{
            guard let text = titleText else { return }
            titleLabel.text = text
        }
       
    }
    
    let titleLabel : UILabel = {
       let lbl  = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 16)
        lbl.textColor = .black
        return lbl
    }()
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(titleLabel)
        titleLabel.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 0)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
