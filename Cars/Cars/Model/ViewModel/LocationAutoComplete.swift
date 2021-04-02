//
//  LocationAutoComplete.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 2.04.2021.
//

import UIKit
import MapKit
class LocaitonAutoComplete : NSObject {
    //MARK:-varibales
    var maxCount : Int = 5
    var searchResult : [MKMapItem]?{
        
        didSet{
            print("debug :: result \(searchResult)")
           tableView.reloadData()
            guard let window = UIApplication.shared.windows.first(where: { ($0.isKeyWindow)}) else { return }
            if let result = searchResult {
                self.blackView.alpha = 1
                if result.count > 5{
                    self.tableViewHeight = CGFloat(maxCount * 50)
                    self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: CGFloat(maxCount * 50))
                }else{
                    self.tableViewHeight = CGFloat(result.count * 50)
                    self.tableView.frame = CGRect(x: 12, y: window.safeAreaInsets.top + 56, width: window.frame.width - 24 , height: CGFloat(result.count * 50))
                }
                
            }
            else{
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
        tableView.register(AutoCompleteCell.self, forCellReuseIdentifier: "id")
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
extension LocaitonAutoComplete  : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = searchResult?.count else { return 0}
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! AutoCompleteCell
        cell.contentView.isUserInteractionEnabled = false
        if let result = searchResult {
            cell.item = result[indexPath.row]
            
        }
        return cell
    }

    
}


class AutoCompleteCell : UITableViewCell {
    //MARK: - AutoCompleteCell variables
    var item : MKMapItem?{
        didSet{
            configure()
        }
    }
    
    //MARK: - AutoCompleteCell properties
    //MARK: - AutoCompleteCell LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: "id")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - AutoCompleteCell handler
    private func configure(){
        guard let item = item else { return }
        textLabel?.text = item.name
        detailTextLabel?.text = parseAddress(selectedItem: item.placemark)
    }
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    //MARK: - AutoCompleteCell selectors
    
}
