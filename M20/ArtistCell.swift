//
//  ArtistCell.swift
//  M20
//
//  Created by Максим Зыкин on 12.05.2024.
//

import UIKit
import SnapKit

class ArtistCell: UITableViewCell {
    
    private let nameLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Имя"
        lable.font = .systemFont(ofSize: 18, weight: .medium)
        return lable
    }()
    
    private let lastNameLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Фамилия"
        lable.font = .systemFont(ofSize: 18, weight: .medium)
        return lable
    }()
    
    private let dateOfBithdLabel: UILabel = {
        let lable = UILabel()
        lable.text = "День рождения"
        lable.font = .systemFont(ofSize: 16, weight: .regular)
        return lable
    }()
    
    private let countryLabel: UILabel = {
        let lable = UILabel()
        lable.text = "Страна"
        lable.font = .systemFont(ofSize: 16, weight: .regular)
        return lable
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Artist) {
        nameLabel.text = model.name
        lastNameLabel.text = model.lastName
        countryLabel.text = model.country
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        dateOfBithdLabel.text = formatter.string(for: (model.dateOfBith) )
    }
    
    func setupUI() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(dateOfBithdLabel)
        contentView.addSubview(countryLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(20)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
        }
        
        dateOfBithdLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(dateOfBithdLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
        }
    }
}

