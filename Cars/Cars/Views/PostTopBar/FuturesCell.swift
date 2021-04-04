//
//  FuturesCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit

class FuturesCell: UICollectionViewCell {

    
    //MARK:-variables
    let UIPicker: UIPickerView = UIPickerView()
    var tableView = UITableView()
    weak var delegate : FuturesItemDelegate?
    var yearText : String?{
        didSet{
            tableView.reloadData()
        }
    }
    var km : String?{
        didSet{
            tableView.reloadData()
        }
    }
    var brand : String?{
        didSet{
            tableView.reloadData()
        }
    }
    var carModel : String?{
        didSet{
            tableView.reloadData()
        }
    }
    //MARK:-properties
   
    
    //MARK:-lifeCycle
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTableView()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    private func configureTableView(){
        addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.register(FuturesItem.self, forCellReuseIdentifier: "id")
        tableView.rowHeight = 40
    }
    
    //MARK:-selectors
   
}
extension FuturesCell : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! FuturesItem
        if indexPath == [0,0] {
            if let text = brand {
                cell.lbl.text = text
                cell.img.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.lbl.text  = "Add Brand"
                cell.img.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
            }
           
        }else if indexPath == [1,0]{
            if let text = carModel {
                cell.lbl.text = text
                cell.img.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.lbl.text  = "Add Model"
                cell.img.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        else if indexPath == [2,0]{
            if let text = yearText {
                cell.lbl.text = text
                cell.img.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.lbl.text  = "Add Year"
                cell.img.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
            }
            
        }
        else if indexPath == [3,0]{
            cell.lbl.text  = "Add km"
            if let text = km {
                cell.lbl.text = text
                cell.img.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
            }else{
                cell.lbl.text  = "Add Km"
                cell.img.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        let headerLabel = UILabel(frame: CGRect(x: 12, y: 4, width:
                                                    tableView.bounds.size.width, height: 12))
        headerLabel.font = UIFont(name: Utils.font, size: 12)
        
        headerLabel.textColor = UIColor.lightGray
        headerLabel.text = self.tableView(self.tableView, titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Brand"
        }else if section == 1 {
            return "Model"
        }
        else if section == 2 {
            return "Year"
        }
        else if section == 3 {
            return "Km"
        }
        return ""
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if indexPath == [0,0] {
            if  brand != nil{
                delegate?.removeBrand()
                delegate?.removeModel()
            }else{
                delegate?.addBrand()
            }
        
        }else if indexPath == [1,0]{
            if  carModel != nil{
                delegate?.removeModel()
            }else{
                delegate?.addModel()
            }
        }
        else if indexPath == [2,0]{
            if  yearText != nil{
                delegate?.removeYear()
            }else{
                delegate?.addYear()
            }
        }
        else if indexPath == [3,0]{
            if km != nil {
                delegate?.removeKm()
            }else{
                delegate?.addKm()
            }
            
        }
    }
}

class FuturesItem : UITableViewCell{
    //MARK:- cell variables
    weak var delegate : FuturesItemDelegate?
    //MARK:- cell properties
    
    let img : UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.setImage(#imageLiteral(resourceName: "new_post").withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    let lbl : UILabel = {
       let lbl = UILabel()
       lbl.font = UIFont(name: Utils.font, size: Utils.normalSize)
        
        lbl.textColor = .darkGray
        return lbl
    }()
    //MARK:-cell lifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(img)
        img.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 25, heigth: 25)
        img.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(lbl)
        lbl.anchor(top: nil, left: img.rightAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 8, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        lbl.centerYAnchor.constraint(equalTo: img.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- cell handlers
    //MARK:-cell selectors
}

