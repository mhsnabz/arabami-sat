//
//  MenuController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit

class MenuController: UIViewController {
    //MARK:-variables
    var currentUser : CurrentUser
    var delegate : HomeControllerDelegate?
    //MARK:-properties
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       configureTableView()
    }
    
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    private  func configureTableView(){
        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.width - 80, height: view.frame.height)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorColor = .none
        tableView.separatorStyle = .none
        tableView.register(SideCell.self, forCellReuseIdentifier: SideCell.reuseIdentifier)
        tableView.register(SideMenuHeaderView.self, forHeaderFooterViewReuseIdentifier: SideMenuHeaderView.reuseIdentifier )
    }
    
    //MARK:-selectors
    
    

}
extension MenuController :  UITableViewDataSource , UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SideCell.reuseIdentifier, for: indexPath) as! SideCell
        cell.backgroundColor = .white
        
        let menuOption = MenuOption(rawValue : indexPath.row)
        cell.imageIcon.image = menuOption?.image
        cell.optionButton.setTitle(menuOption?.description, for: .normal)
        cell.selectionStyle = .none
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 152
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.contentView.backgroundColor = .white // Works!
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SideMenuHeaderView.reuseIdentifier) as! SideMenuHeaderView
     //   header.delegate = self
        header.currentUser = currentUser
        return header
        
        
    }
}
