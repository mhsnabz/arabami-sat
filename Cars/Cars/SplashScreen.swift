//
//  SplashScreen.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 30.03.2021.
//

import UIKit
import FirebaseAuth
import RevealingSplashView
import FirebaseFirestore
class SplashScreen: UIViewController {
    //MARK:-variables
    
    var navControl : UIViewController!
    let splashScreen = RevealingSplashView(iconImage: #imageLiteral(resourceName: "cars_logo"), iconInitialSize: CGSize(width: 100, height: 100), backgroundColor: UIColor.white)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(splashScreen)
        splashScreen.animationType = .squeezeAndZoomOut
    }
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser?.uid != nil {
            let db = Firestore.firestore().collection("status")
                .document(Auth.auth().currentUser!.uid)
            db.getDocument {[weak self] (docSnap, err) in
                guard let sself = self else { return }
                if let err =  err {
                    print("DEBUG:: \(err.localizedDescription)" )
                    sself.goLoginController()
                }else{
                    guard let snap = docSnap else {
                        sself.goLoginController()
                        return
                    }
                    if let status = snap.get("status") as? Bool {
                        if status {
                            guard let uid = Auth.auth().currentUser?.uid else { return }
                            sself.goFeedVC(uid: uid)
                        }else{
                            UserService.shared.getTaskUser(with: Auth.auth().currentUser?.uid ?? "") { (user) in
                                guard let user = user else { return }
                                sself.completeSignUp(taskUser: user)
                            }
                   
                        }
                    }
                }
            }
        }else{
            goLoginController()
        }
            
       
    }

 
    private func goLoginController(){
        self.splashScreen.startAnimation {
            let rootViewController = UINavigationController(rootViewController: LoginController())
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
       
    }
    private func completeSignUp(taskUser : TaskUser){
        self.splashScreen.startAnimation {
            let rootViewController = UINavigationController(rootViewController: CompleteSignUpVC(taskUser : taskUser))
            rootViewController.modalPresentationStyle = .fullScreen
            self.present(rootViewController, animated: true, completion: nil)
        }
      
    }
    private func goFeedVC(uid : String){
  
            
            UserService.shared.getCurrentUser(with: uid) {[weak self] (currentUser) in
                guard let user  = currentUser else { return }
                guard let sself = self else { return }
                sself.splashScreen.startAnimation {
                let controller = UINavigationController(rootViewController: ContainerController(currentUser: user))
                controller.modalPresentationStyle = .fullScreen
                sself.present(controller, animated: true, completion: nil)
            }
        }
    }

}
