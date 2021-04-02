//
//  PermissionConroller.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 2.04.2021.
//

import UIKit
import Lottie
import CoreLocation
class PermissionConroller: UIViewController {
    //MARK:-properties
    var waitAnimation = AnimationView()
    var locationManager : CLLocationManager?
    let lbl : UILabel = {
       let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    lazy var text : NSMutableAttributedString = {
       let text = NSMutableAttributedString()
        return text
    }()
    let accept : UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle("İzin Ver", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 16)
        return btn
        
    }()
    let denied : UIButton = {
        let btn = UIButton(type: .system)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 10
        btn.setTitle("Vazgeç", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 16)
      
        return btn
        
    }()
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        waitAnimation = .init(name : "location-pin")
        waitAnimation.animationSpeed = 1
        waitAnimation.contentMode = .scaleAspectFill
        waitAnimation.loopMode = .loop
        
        view.addSubview(waitAnimation)
        waitAnimation.anchor(top: view.topAnchor , left: nil, bottom: nil, rigth: nil, marginTop: 100, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 200, heigth: 200)
        waitAnimation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitAnimation.play()
        text =  NSMutableAttributedString(string: "Konum Servislerini Aç\n\n", attributes: [NSAttributedString.Key.font : UIFont(name: Utils.font, size: 15)!, NSAttributedString.Key.foregroundColor : UIColor.black])
        text.append(NSAttributedString(string: " Eklemek İstediğiniz Konuma Erişebilmemiz İçin İzin Vermeniz Gerekiyor ", attributes: [NSAttributedString.Key.font:UIFont(name: Utils.font, size: 13)!, NSAttributedString.Key.foregroundColor : UIColor.lightGray ]))
        lbl.attributedText = text
        view.addSubview(lbl)
        lbl.anchor(top: waitAnimation.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 0, marginLeft: 20, marginBottom: 0, marginRigth: 20, width: 0, heigth: 0)
        
        view.addSubview(accept)
        accept.anchor(top: lbl.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        view.addSubview(denied)
        denied.anchor(top: accept.bottomAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 20, marginLeft: 60, marginBottom: 0, marginRigth: 60, width: 0, heigth: 40)
        denied.addTarget(self, action: #selector(deniedPermisson), for: .touchUpInside)
        accept.addTarget(self, action: #selector(acceptPermisson), for: .touchUpInside)
        Utils.shared.styleFilledButton(accept)
        Utils.shared.styleHollowButton(denied)
    }
    //MARK: - selectors
    @objc func deniedPermisson()
    {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func acceptPermisson(){
        guard let locationManager = locationManager else { return }
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

}
extension PermissionConroller : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard  locationManager?.location != nil else {
            print("err ")
            return
        }
        dismiss(animated: true, completion: nil)
    }
}
