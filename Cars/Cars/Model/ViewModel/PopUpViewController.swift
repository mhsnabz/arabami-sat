//
//  PopUpViewController.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 3.04.2021.
//

import UIKit
import TweeTextField
class PopUpViewController : UIView{
    //MARK:-properties
    weak var delegate : PopUpNumberDelegate?
    var price : String?
    var year : String?
    var yearsTillNow : [String] {
        var years = [String]()
        for i in (1990..<2021).reversed() {
            years.append("\(i)")
        }
        return years
    }
    var target : String?{
        didSet{
            
            configure(target: target)
        }
    }
    let priceVal : TweeAttributedTextField = {
         let txt = TweeAttributedTextField()
         txt.placeholder = "Add Price"
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
        btn.backgroundColor = .red
        btn.setTitleColor(.white, for: .normal)
     
        return btn
    }()
    let btnCancel : UIButton = {
         let btn = UIButton(type: .system)
         btn.setTitle("Cancel", for: .normal)
         btn.titleLabel?.font = UIFont(name: Utils.font, size: 14)
         btn.clipsToBounds = true
         btn.layer.cornerRadius = 5
         btn.backgroundColor = .mainColor()
         btn.setTitleColor(.white, for: .normal)
      
         return btn
     }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        showUIPickerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:-handlers
    private func configure(target : String?){
        guard let target = target else { return }
        if target == "addYear" {
            addSubview(yearVal)
            yearVal.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 40, marginLeft: 10, marginBottom: 0, marginRigth: 10, width: 0, heigth: 50)
            let stack = UIStackView(arrangedSubviews: [btnCancel,btnAdd])
            stack.axis = .horizontal
            stack.spacing = 5
            stack.distribution = .fillEqually
            addSubview(stack)
            stack.anchor(top: yearVal.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 10, marginLeft: 20, marginBottom: 0, marginRigth: 20, width: 0, heigth: 35)
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            btnCancel.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
            btnAdd.addTarget(self, action: #selector(add_year), for: .touchUpInside)
        }else if target == "addPrice"{
            addSubview(priceVal)
            priceVal.anchor(top: topAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 40, marginLeft: 10, marginBottom: 0, marginRigth: 10, width: 0, heigth: 50)
            let stack = UIStackView(arrangedSubviews: [btnCancel,btnAdd])
            stack.axis = .horizontal
            stack.spacing = 5
            stack.distribution = .fillEqually
            addSubview(stack)
            stack.anchor(top: priceVal.bottomAnchor, left: leftAnchor, bottom: nil, rigth: rightAnchor, marginTop: 10, marginLeft: 20, marginBottom: 0, marginRigth: 20, width: 0, heigth: 35)
            stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            btnCancel.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
            btnAdd.addTarget(self, action: #selector(add_price), for: .touchUpInside)
        }
    }
    
    private func showUIPickerView(){
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.frame = CGRect(x: 0, y: 200, width: frame.width, height: 200)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    //MARK:-selectors
    @objc func handleDismissal()
    {
        delegate?.handleDismissal()
        
    }
    @objc func donePicker(){
        yearVal.resignFirstResponder()
        year = yearVal.text
    }
    @objc func add_year(){
        guard let year = year else { return }
        delegate?.addYear(year)
    }
    @objc func add_price(){
        self.price = priceVal.text
        
        delegate?.addPrice(priceVal.text)
    }
    
    @objc func add_year_val(sender : UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        dateFormatter.timeStyle = .none
        self.yearVal.text = dateFormatter.string(from: sender.date)
    }
}
extension PopUpViewController :   UIPickerViewDelegate, UIPickerViewDataSource{
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

