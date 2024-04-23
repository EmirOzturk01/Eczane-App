//
//  EczaneInfoTableViewCell.swift
//  Eczane
//
//  Created by Emir Öztürk on 13.03.2024.
//

import UIKit

class EczaneInfoTableViewCell: UITableViewCell {
    
   

    static let identifier = "EczaneInfoTableViewCell"
    
    private let pharmacyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "eczane")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let pharmacyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .red
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let pharmacyAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    private let pharmacyPhone: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .red
        return label
    }()
    
    private let pharmacyDistance: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .red
        label.textAlignment = .center
        return label
    }()
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(pharmacyImageView)
        contentView.addSubview(pharmacyName)
        contentView.addSubview(pharmacyAddress)
        contentView.addSubview(pharmacyPhone)
        contentView.addSubview(pharmacyDistance)
        contentView.backgroundColor = UIColor.white
        
        selectionStyle = .none
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = 20
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        let margins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
    }
    
    public func configure(with model: PharmacyInfoViewModel) {
        self.pharmacyName.text = model.pharmacyName
        self.pharmacyAddress.text = model.pharmacyAddress
        self.pharmacyPhone.text = model.pharmacyPhone
        
        let distance = round(100 * model.distance) / 100
        
        self.pharmacyDistance.text = String("\(distance) KM")
    }
    
    private func applyConstraints() {
        let pharmacyImageViewConstraints = [
            pharmacyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pharmacyImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            pharmacyImageView.widthAnchor.constraint(equalToConstant: 90),
            pharmacyImageView.heightAnchor.constraint(equalToConstant: 90)
        ]
        
        let pharmacyNameConstraints = [
            pharmacyName.leadingAnchor.constraint(equalTo: pharmacyImageView.trailingAnchor,constant: 5),
            pharmacyName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pharmacyName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            pharmacyName.heightAnchor.constraint(equalToConstant: 25),
        ]
        
        let pharmacyAddressConstraints = [
            pharmacyAddress.leadingAnchor.constraint(equalTo: pharmacyImageView.trailingAnchor,constant: 5),
            pharmacyAddress.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pharmacyAddress.topAnchor.constraint(equalTo: pharmacyName.bottomAnchor, constant: 5),
            pharmacyAddress.bottomAnchor.constraint(equalTo: pharmacyPhone.topAnchor, constant: -5)
        ]
        
        let pharmacyPhoneConstraints = [
            pharmacyPhone.leadingAnchor.constraint(equalTo: pharmacyImageView.trailingAnchor,constant: 5),
            pharmacyPhone.trailingAnchor.constraint(equalTo: pharmacyDistance.leadingAnchor, constant: -10),
            pharmacyPhone.heightAnchor.constraint(equalToConstant: 20),
            pharmacyPhone.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5)
        ]
        
        let pharmacyDistanceConstraints = [
            pharmacyDistance.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            pharmacyDistance.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            pharmacyDistance.widthAnchor.constraint(equalToConstant: 70),
            pharmacyDistance.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        NSLayoutConstraint.activate(pharmacyImageViewConstraints)
        NSLayoutConstraint.activate(pharmacyNameConstraints)
        NSLayoutConstraint.activate(pharmacyAddressConstraints)
        NSLayoutConstraint.activate(pharmacyPhoneConstraints)
        NSLayoutConstraint.activate(pharmacyDistanceConstraints)

    }
}
