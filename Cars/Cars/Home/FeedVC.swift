//
//  FeedVC.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit

class FeedVC: UIViewController {
    //MARK:-variables
    var currentUser : CurrentUser
    //MARK:-properties
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Feed"

    }
    

    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
