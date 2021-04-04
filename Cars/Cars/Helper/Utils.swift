//
//  Utils.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
import SVProgressHUD
class Utils{
    public static let shared = Utils()
    static var font =  "AvenirNext-Medium"
    static var fontBold =  "AvenirNext-DemiBold"
    static var italic = "AvenirNext-Italic"
    
    
    static let smallSize : CGFloat = 10
    static let regularSize : CGFloat = 12
    static let normalSize : CGFloat = 14
    static let boldSize : CGFloat = 16
    
    static func waitProgress(msg : String?){
        if msg != nil{
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setBorderColor(.white)
            SVProgressHUD.show(withStatus: msg)
            SVProgressHUD.setForegroundColor(.white)
        }else{
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setBorderColor(.white)
            SVProgressHUD.show(withStatus: nil)
            SVProgressHUD.setForegroundColor(.white)
        }
        
    }
    static func succesProgress(msg : String?){
        if msg != nil{
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setBorderColor(.white)
            SVProgressHUD.showSuccess(withStatus: msg)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.dismiss(withDelay: 500)
        }else{
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setBorderColor(.white)
            SVProgressHUD.showSuccess(withStatus: nil)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.dismiss(withDelay: 500)
        }
        
    }
    static func dismissProgress(){
        SVProgressHUD.dismiss()
    }
    static func errorProgress(msg : String?){
        if  msg == nil {
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setBorderColor(.white)
            
            SVProgressHUD.showError(withStatus: nil)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.dismiss(withDelay:500)
        }else{
            SVProgressHUD.setBackgroundColor(.black)
            SVProgressHUD.setFont(UIFont(name: Utils.font, size: Utils.regularSize)!)
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.setBorderColor(.white)
            
            SVProgressHUD.showError(withStatus: msg)
            SVProgressHUD.setForegroundColor(.white)
            SVProgressHUD.dismiss(withDelay: 500)
        }
        
    }
     func styleFilledButton(_ button:UIButton) {
        
        button.backgroundColor = UIColor.mainColor()
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
    }
    
    
     func enabledButton (_ button:UIButton) {
        
        button.backgroundColor = UIColor.mainColorTransparent()
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.white
      }
    
     func styleHollowButton(_ button:UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.black
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var brandList = ["Volvo","Merceders","BMW","Toyota"]
    var volvoList = ["xc40","xc60","xc90","s40","s60","s90"]
    var mercerdersList = ["Mercedes-Benz AMG GLE Coupe","Mercedes-Benz AMG GT 4-Door Coupe","Mercedes-Benz E-Class All Terrain","Mercedes-Benz New GLA"]
    var bmwList = ["2 Series Gran Coupe","BMW X7","BMW Z4","BMW X5"]
    var toyotaList = ["Avalon","Camry","Corolla","Prius","Yaris","Sienna","C-HR"]
    
    func getBrandList() -> [String]{
        return brandList
    }
    func getCarModel(target : String) ->[String]{
        if target == "Volvo" {
            return volvoList
        }else if target == "Merceders"{
            return mercerdersList
        }else if target == "BMW"{
            return bmwList
        }else if target == "Toyota"{
            return toyotaList
        }
        return []
    }
    
    
    
}
