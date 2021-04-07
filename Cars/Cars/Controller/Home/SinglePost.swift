//
//  SinglePost.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit
private let futures_cell = "futures_cell"
private let contact_cell = "contact_cell"
private let location_cell = "location_cell"
private let despription_cell = "despription_cell"
private let images_cell = "images_cell"
class SinglePost: UIViewController, ContactDelegate{
    func sendMessage(for cell: ContactCell) {
        guard let user = cell.otherUser else { return }
      
        self.navigationController?.pushViewController(  ConservationController(currentUser: currentUser, otherUser: user), animated: true)
    }
    
    func phoneCall(for cell: ContactCell) {
        
    }
    
    var car : Car
    var currentUser : CurrentUser
    var otherUser : OtherUser?
    lazy var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        navigationItem.title = "\(car.brand!) \(car.carModel!)"
        configureTableView()
    }
    init(currentUser : CurrentUser , car : Car) {
        self.currentUser = currentUser
        self.car = car
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:-handlers
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        
        tableView.register(ImagesCell.self, forCellReuseIdentifier: images_cell)
        tableView.register(TableViewFuturesCell.self, forCellReuseIdentifier: futures_cell)
        tableView.register(DespriptionCell.self, forCellReuseIdentifier: despription_cell)
        tableView.register(ContactCell.self, forCellReuseIdentifier: contact_cell)
        tableView.register(LocaitonCell.self, forCellReuseIdentifier: location_cell)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        
    }
}

extension SinglePost :  UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [0,0] {
            let cell = tableView.dequeueReusableCell(withIdentifier: images_cell, for: indexPath) as! ImagesCell
            cell.imageList = car.imageList
            cell.contentView.isUserInteractionEnabled = false
            return cell
            
        }else if indexPath == [1,0]{
            let cell = tableView.dequeueReusableCell(withIdentifier: despription_cell, for: indexPath) as! DespriptionCell
            let h = car.decription!.height(withConstrainedWidth: view.frame.width - 24, font: UIFont(name: Utils.font, size: Utils.regularSize)!)
            cell.lbl.frame = CGRect(x: 12, y:0 , width: view.frame.width - 24, height: h)
            cell.deps = car.decription!
            return cell
        }else if indexPath == [2,0]{
            let cell = tableView.dequeueReusableCell(withIdentifier: futures_cell, for: indexPath) as! TableViewFuturesCell
            cell.car = car
            return cell
        }else if indexPath == [3,0]{
            let cell = tableView.dequeueReusableCell(withIdentifier: location_cell , for: indexPath) as! LocaitonCell
            cell.image_View.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
            cell.geoPoint = car.locaiton
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: contact_cell , for: indexPath) as! ContactCell
            cell.contentView.isUserInteractionEnabled = false 
            if let user = otherUser {
              
                cell.nameString = user.name
                cell.photoUrl = user.profileImage
                cell.delegate = self
                cell.otherUser = otherUser
            }else{
               
                cell.nameString = currentUser.name
                cell.photoUrl = currentUser.profileImage
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Images"
        }else if section == 1 {
            return "Despription"
        }
        else if section == 2 {
            return "Features"
        }
        else if section == 3 {
            return "Locaiton"
        }else {
            return "Contact"
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 12, y: 4, width:
                                                    tableView.bounds.size.width, height: 14))
        headerLabel.font = UIFont(name: Utils.fontBold, size: 14)
        
        headerLabel.textColor = UIColor.darkGray
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == [0,0] {
            return view.frame.width
        }else if indexPath == [1,0]{
            let h = car.decription!.height(withConstrainedWidth: view.frame.width - 24, font: UIFont(name: Utils.font, size: Utils.regularSize)!)
            return h
        }else if indexPath == [2,0]{
            return 80
        }else if indexPath == [3,0]{
            return view.frame.width
        }else if indexPath == [4,0]{
            return 115
        }
        return UITableView.automaticDimension
    }
    
}
