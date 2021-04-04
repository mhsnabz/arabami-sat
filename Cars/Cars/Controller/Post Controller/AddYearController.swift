//
//  AddYearController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 4.04.2021.
//

import UIKit
import TweeTextField
class AddYearController: UIViewController {

    //MARK:-varibales
    weak var delegate : PopUpYearDelegate?
    var yearsTillNow : [String] {
        var years = [String]()
        for i in (1990..<2022).reversed() {
            years.append("\(i)")
        }
        return years
    }
    //MARK:-properties
    let yearVal : TweeAttributedTextField = {
         let txt = TweeAttributedTextField()
         txt.placeholder = "Add Year"
         txt.font = UIFont(name: Utils.font, size: 14)!
         txt.activeLineColor =   UIColor.mainColor()
         txt.lineColor = .lightGray
         txt.textAlignment = .left
         txt.activeLineWidth = 1.5
         txt.animationDuration = 0.7
         txt.infoFontSize = UIFont.smallSystemFontSize
         txt.infoTextColor = .red
         txt.infoAnimationDuration = 0.4
         txt.textContentType = .telephoneNumber
         txt.autocorrectionType = .no
         txt.autocapitalizationType = .none
         txt.returnKeyType = .continue
         txt.textAlignment = .center
         
         return txt
     }()
    let   btnAdd : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Add", for: .normal)
        btn.titleLabel?.font = UIFont(name: Utils.font, size: 14)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 5
        btn.backgroundColor = .mainColor()
        btn.setTitleColor(.white, for: .normal)
     
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(yearVal)
        yearVal.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, rigth: view.rightAnchor, marginTop: 40, marginLeft: 40, marginBottom: 0, marginRigth: 40, width: 0, heigth: 50)
        view.addSubview(btnAdd)
        btnAdd.anchor(top: yearVal.bottomAnchor, left: nil, bottom: nil, rigth: nil, marginTop: 20, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 200, heigth: 40)
        btnAdd.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        btnAdd.addTarget(self, action: #selector(add_year), for: .touchUpInside)
        showUIPickerView()
    }
    
    //MARK:-handlers
    private func showUIPickerView(){
        yearVal.text = "2020"
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.frame = CGRect(x: 0, y: 200, width: view.frame.width, height: 200)
        picker.backgroundColor = .white
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
   

        toolBar.items = [flexBarButton, doneBarButton]
        toolBar.isUserInteractionEnabled = true

        yearVal.inputView = picker
        yearVal.inputAccessoryView = toolBar
    }
    
    //MARK:-selectors
    @objc func add_year(){

        delegate?.addYear(yearVal.text)
        yearVal.text = ""
        self.dismiss(animated: true, completion: nil)
    }
    @objc func donePicker(){
        yearVal.resignFirstResponder()
     
    }
}
extension AddYearController :   UIPickerViewDelegate, UIPickerViewDataSource{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return yearsTillNow.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = yearsTillNow[row]
        return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       let date = yearsTillNow[row]
        yearVal.text = date
    }
    
}
