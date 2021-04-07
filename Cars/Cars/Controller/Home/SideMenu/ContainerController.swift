//
//  ContainerController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 1.04.2021.
//

import UIKit
import FirebaseAuth
class ContainerController: UIViewController {
    //MARK:-variables
    var menuController : MenuController!
    var centralController : UIViewController!
    var currentUser : CurrentUser

    public var isExanded = false
    //MARK:-properties
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureHomeContainerController()
    }
    
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    //MARK:-handlers
    
    func configureHomeContainerController(){
        let feedController = FeedVC(currentUser: currentUser)
        feedController.delegate = self
        centralController = UINavigationController(rootViewController: feedController)
        view.addSubview(centralController.view)
        addChild(centralController)
        centralController.didMove(toParent: self)
    }
    func configureMenuController(){
        if  menuController == nil {
            self.menuController = MenuController(currentUser: currentUser)
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        }
    }
    func showMenuController(shouldExpand : Bool , menuOption : MenuOption?){
        if shouldExpand {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centralController.view.frame.origin.x = self.centralController.view.frame.width - 80
                self.centralController.view.layer.shadowColor = UIColor.darkGray.cgColor
                self.centralController.view.layer.shadowOffset = CGSize(width: 0, height: 2)
                self.centralController.view.layer.shadowRadius = 2
                self.centralController.view.layer.shadowOpacity = 0.8
                self.centralController.view.layer.masksToBounds = false
//                self.centrelController.view.layer.shadowOpacity = 0.8
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centralController.view.frame.origin.x = 0
                      self.centralController.view.layer.shadowOpacity = 0.0
            }) { (_) in
                guard let menuOption = menuOption else{return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
    }
    
    func didSelectMenuOption(menuOption : MenuOption){
        switch menuOption{
        
        case .setting:
            print("DEBUG :: setting vc")
            break
        case .messages:
            print("DEBUG:: chatVC")
            let vc = ChatList(currentUser: currentUser)
            let rootController = UINavigationController(rootViewController: vc)
            rootController.modalPresentationStyle = .fullScreen
            self.present(rootController, animated: true, completion: nil)
            break
        case .logOut:
            try! Auth.auth().signOut()
            let vc = SplashScreen()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    //MARK:-selectors


}
extension ContainerController : HomeControllerDelegate {
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        if !isExanded{
            configureMenuController()
        }
        isExanded = !isExanded
        showMenuController(shouldExpand: isExanded, menuOption: menuOption)
    }
      
}
