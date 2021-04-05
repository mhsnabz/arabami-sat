//
//  Extensions.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 31.03.2021.
//

import UIKit
extension UIView{
    func anchor(top : NSLayoutYAxisAnchor?
                ,left : NSLayoutXAxisAnchor?,
                bottom : NSLayoutYAxisAnchor? ,
                rigth: NSLayoutXAxisAnchor?,
                marginTop : CGFloat ,
                marginLeft : CGFloat ,
                marginBottom: CGFloat
                ,marginRigth : CGFloat ,
                width : CGFloat ,
                heigth : CGFloat){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: marginTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: marginLeft).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -marginBottom).isActive = true
        }
        if let rigth = rigth {
            self.rightAnchor.constraint(equalTo: rigth, constant: -marginRigth).isActive = true
        }
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if heigth != 0{
            heightAnchor.constraint(equalToConstant: heigth).isActive = true
        }
    }
}
extension UIColor {
    static func mainColor2() -> UIColor {
        return  UIColor.init(red: 111/255, green: 152/255, blue: 174/255, alpha: 1)
    }
   
    static func mainColor() -> UIColor {
        return  UIColor.init(red: 66/255, green: 126/255, blue: 164/255, alpha: 1)
    }
    static func mainColorTransparent() -> UIColor {
        return  UIColor.init(red: 66/255, green: 126/255, blue: 164/255, alpha: 0.4)
    }
    static func linkColor() -> UIColor {
        return  UIColor.init(red: 70/255, green: 140/255, blue: 247/255, alpha: 1)
    }
    static func cancelColor() -> UIColor {
        return  UIColor.init(red: 241/255, green: 238/255, blue: 246/255, alpha: 1)
    }
    static func collectionColor () -> UIColor {
        return UIColor.init(red: 218/255, green: 230/255, blue: 245/255, alpha: 1)
    }
    static func unselectedColor () -> UIColor {
        return UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 0.5)
    }
    static func notificationNotRead() -> UIColor {
        return  UIColor.init(red: 80/255, green: 145/255, blue: 233/255, alpha: 0.1)
    }
    static func googleButton() -> UIColor {
        return  UIColor.init(red: 220/255, green: 78/255, blue: 65/255, alpha: 1)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func setNavigationBar(){
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: Utils.fontBold, size: Utils.normalSize)!]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }

}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
