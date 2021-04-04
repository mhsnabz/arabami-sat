//
//  ChooseBrandController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 4.04.2021.
//

import UIKit
protocol BrandDelegate : class {
    func chooseBrand(target : String)
    func chooseModel(target : String)
}
class ChooseBrandController: UITableViewController {

    var target : String
    var delegate : BrandDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(BrandCell.self, forCellReuseIdentifier: "id")
        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        tableView.reloadData()
    }

    init(target : String) {
        self.target = target
        super.init(nibName: nil, bundle: nil)
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if target == "brand" {
            return Utils.shared.getBrandList().count
           
        }else{
            return Utils.shared.getCarModel(target: target).count
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
       
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! BrandCell
        
        if target=="brand" {
            cell.logo.image = UIImage(named: (Utils.shared.getBrandList()[indexPath.row]))
            cell.name.text = Utils.shared.getBrandList()[indexPath.row]
        }else{
            cell.logo.image = UIImage(named: target)
            cell.name.text = Utils.shared.getCarModel(target: target)[indexPath.row]
        }
       
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            if self.target == "brand"{
                delegate.chooseBrand(target: Utils.shared.getBrandList()[indexPath.row])
                self.dismiss(animated: false, completion: nil)
            }else{
                delegate.chooseModel(target: Utils.shared.getCarModel(target: self.target)[indexPath.row])
                self.dismiss(animated: false, completion: nil)
            }
        }
            
            
            
        
    }

}
class BrandCell : UITableViewCell {
    
    let logo : UIImageView = {
       let img = UIImageView()
        return img
    }()
    let name : UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: Utils.font, size: 14)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(logo)
        logo.anchor(top: nil, left: leftAnchor, bottom: nil, rigth: nil, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 0, width: 45, heigth: 45)
        logo.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(name)
        name.anchor(top: nil, left: logo.rightAnchor, bottom: nil, rigth: rightAnchor, marginTop: 0, marginLeft: 12, marginBottom: 0, marginRigth: 12, width: 0, heigth: 30)
        name.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
