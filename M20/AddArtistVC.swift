//
//  AddArtistVC.swift
//  M20
//
//  Created by Максим Зыкин on 12.05.2024.
//

import UIKit
import SnapKit

class AddArtistVC: UIViewController {
    
    var artist:  Artist?
    
    private var nameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Имя"
        return textField
    }()
    
    private var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Фамилия"
        return textField
    }()
    
    private var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "ДД-ММ-ГГГГ"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setDateOfBirtButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(setDateOfBirt), for: .touchUpInside)
        return button
    }()
    
    private var countryLabel: UILabel = {
        let label = UILabel()
        label.text = "Страна"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setCountryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выбрать", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(setCountry), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @objc func setDateOfBirt() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 50)
        let picetView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        picetView.datePickerMode = .date
        vc.view.addSubview(picetView)
        
        picetView.snp.makeConstraints { make in
            make.center.equalTo(vc.view.snp.center)
        }
        
        picetView.addTarget(self, action: #selector(updateDateOfBithd(sender: )), for: .valueChanged)
        let dataAlert = UIAlertController(title: "Укажите дату рождения", message: "", preferredStyle: .alert)
        dataAlert.setValue(vc, forKey: "contentViewController")
        dataAlert.addAction(UIAlertAction(title: "Готово", style: .default))
        updateDateOfBithd(sender: picetView)
        present(dataAlert, animated: true)
    }
    
    @objc func updateDateOfBithd(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOfBirthLabel.text = formatter.string(from: sender.date)
    }
    
    @objc func setCountry() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250, height: 200)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let countryAlert = UIAlertController(title: "Выберите страну", message: "", preferredStyle: .alert)
        countryAlert.setValue(vc, forKey: "contentViewController")
        countryAlert.addAction(UIAlertAction(title: "Готово", style: .default))
        present(countryAlert, animated: true)
    }
    
    @objc func save() {
        if nameTextField.hasText && lastNameTextField.hasText && dateOfBirthLabel.text != "дд-мм-гггг" {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            artist?.name = nameTextField.text
            artist?.lastName = lastNameTextField.text
            artist?.dateOfBith = formatter.date(from: dateOfBirthLabel.text ?? "")
            artist?.country = countryLabel.text
            
            try? artist?.managedObjectContext?.save()
            dismiss(animated: true)
        } else {
            let errorAlert = UIAlertController(title: "Ошибка", message: "Укажите все данные", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
            present(errorAlert, animated: true)
        }
    }
    
    private func setupUI() {
        view.addSubview(nameTextField)
        view.addSubview(lastNameTextField)
        view.addSubview(dateOfBirthLabel)
        view.addSubview(setDateOfBirtButton)
        view.addSubview(countryLabel)
        view.addSubview(setCountryButton)
        view.addSubview(saveButton)
        
        view.backgroundColor = .white
        
        nameTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(view.snp.topMargin).offset(40)
        }
        lastNameTextField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
        }
        dateOfBirthLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.right.equalTo(view.snp.centerX)
            make.centerY.equalTo(setDateOfBirtButton.snp.centerY)
        }
        setDateOfBirtButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
        }
        countryLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.top.equalTo(dateOfBirthLabel.snp.bottom).offset(20)
            make.right.equalTo(view.snp.centerX)
            make.centerY.equalTo(setCountryButton.snp.centerY)
        }
        setCountryButton.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
            make.top.equalTo(setDateOfBirtButton.snp.bottom).offset(20)
        }
        saveButton.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.left.equalTo(view.snp.leftMargin).offset(20)
            make.right.equalTo(view.snp.rightMargin).offset(-20)
        }
        
//        nameTextField.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.topMargin).offset(20)
//            make.left.equalTo(view.snp.leftMargin).offset(20)
//            make.right.equalTo(view.snp.rightMargin).offset(-20)
//        }
//        
//        lastNameTextField.snp.makeConstraints { make in
//            make.top.equalTo(nameTextField.snp.bottom).offset(10)
//            make.left.equalTo(view.snp.leftMargin).offset(20)
//            make.right.equalTo(view.snp.rightMargin).offset(-20)
//        }
//        
//        dateOfBirthLabel.snp.makeConstraints { make in
//            make.top.equalTo(lastNameTextField.snp.bottom).offset(10)
//            make.left.equalTo(view.snp.leftMargin).offset(20)
//            make.right.equalTo(view.snp.centerX)
//            make.centerX.equalTo(setDateOfBirtButton.snp.centerY)
//        }
//        
//        setDateOfBirtButton.snp.makeConstraints { make in
//            make.top.equalTo(lastNameTextField.snp.bottom).offset(10)
//            make.left.equalTo(view.snp.centerX)
//            make.right.equalTo(view.snp.rightMargin).offset(-20)
//        }
//        
//        countryLabel.snp.makeConstraints { make in
//            make.top.equalTo(dateOfBirthLabel.snp.bottom).offset(10)
//            make.left.equalTo(view.snp.leftMargin).offset(20)
//            make.right.equalTo(view.snp.centerX)
//            make.centerX.equalTo(setCountryButton.snp.centerY)
//        }
//        
//        setCountryButton.snp.makeConstraints { make in
//            make.top.equalTo(setDateOfBirtButton.snp.bottom).offset(10)
//            make.left.equalTo(view.snp.centerX)
//            make.right.equalTo(view.snp.rightMargin).offset(-20)
//        }
//        
//        saveButton.snp.makeConstraints { make in
//            make.center.equalTo(view.snp.center)
//            make.left.equalTo(view.snp.leftMargin).offset(20)
//            make.right.equalTo(view.snp.rightMargin).offset(-20)
//        }
    }
    
}


extension AddArtistVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let countries = Countries().countries
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let countries = Countries().countries
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let countries = Countries().countries
        self.countryLabel.text = countries[row]
    }
}