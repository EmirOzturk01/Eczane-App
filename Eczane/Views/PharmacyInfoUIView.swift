//
//  PharmacyInfo.swift
//  Eczane
//
//  Created by Emir Öztürk on 11.03.2024.
//

import UIKit
import MapKit

class PharmacyInfoUIView: UIView {
    
    var latitude: Double?
    var longitude: Double?
    
    private let pharmacyPhoneImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "phone.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        imageView.image = image
        return imageView
    }()
    
    @objc func pharmacyPhoneImageViewTapped(){
        guard let number = pharmacyPhone.text else { return }
        var newNumber = number
        let chars = [" ","-","(",")"]
        
        for char in chars {
            newNumber = newNumber.replacingOccurrences(of: "\(char)", with: "")
        }
        
        callNumber(phoneNumber: newNumber)
    }
    
    private let pharmacyNaviImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "location.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        imageView.image = image
        return imageView
    }()
    
    @objc func pharmacyNaviImageViewTapped(){
        guard let latitude = self.latitude, let longitude = self.longitude else { return }
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = pharmacyName.text
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    private let pharmacyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .red
        label.textAlignment = .center
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.borderWidth = 2
        layer.borderColor = UIColor.red.cgColor
        layer.cornerRadius = 20
        
        addSubview(pharmacyPhoneImageView)
        addSubview(pharmacyNaviImageView)
        addSubview(pharmacyName)
        addSubview(pharmacyAddress)
        addSubview(pharmacyPhone)
        applyConstraints()
        
        let tapGestureRecognizerPhone = UITapGestureRecognizer(target: self, action: #selector(pharmacyPhoneImageViewTapped))
        pharmacyPhoneImageView.isUserInteractionEnabled = true
        pharmacyPhoneImageView.addGestureRecognizer(tapGestureRecognizerPhone)
        
        let tapGestureRecognizerNavi = UITapGestureRecognizer(target: self, action: #selector(pharmacyNaviImageViewTapped))
        pharmacyNaviImageView.isUserInteractionEnabled = true
        pharmacyNaviImageView.addGestureRecognizer(tapGestureRecognizerNavi)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: PharmacyInfoViewModel) {
        self.pharmacyAddress.text = model.pharmacyAddress
        self.pharmacyName.text = model.pharmacyName
        self.pharmacyPhone.text = model.pharmacyPhone
        self.latitude = model.latitude
        self.longitude = model.longitude
    }
    
    private func applyConstraints() {
        let pharmacyNameConstraints = [
            pharmacyName.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            pharmacyName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pharmacyName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            pharmacyName.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let pharmacyAddressConstraints = [
            pharmacyAddress.topAnchor.constraint(equalTo: pharmacyName.bottomAnchor, constant: 10),
            pharmacyAddress.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            //pharmacyAddress.trailingAnchor.constraint(equalTo: pharmacyNaviImageView.leadingAnchor, constant: -10),
            pharmacyAddress.widthAnchor.constraint(equalTo: widthAnchor, constant: -60),
            pharmacyAddress.bottomAnchor.constraint(equalTo: pharmacyPhone.topAnchor, constant: -10)
        ]
        
        let pharmacyNaviImageViewConstraints = [
            pharmacyNaviImageView.centerYAnchor.constraint(equalTo: pharmacyAddress.centerYAnchor),
            pharmacyNaviImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ]
        
        let pharmacyPhoneConstraints = [
            pharmacyPhone.topAnchor.constraint(equalTo: pharmacyAddress.bottomAnchor, constant: 10),
            pharmacyPhone.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            pharmacyPhone.trailingAnchor.constraint(equalTo: pharmacyPhoneImageView.leadingAnchor, constant: -10),
            pharmacyPhone.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ]
        
        let pharmacyPhoneImageViewConstraints = [
            pharmacyPhoneImageView.centerYAnchor.constraint(equalTo: pharmacyPhone.centerYAnchor),
            pharmacyPhoneImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(pharmacyNameConstraints)
        NSLayoutConstraint.activate(pharmacyAddressConstraints)
        NSLayoutConstraint.activate(pharmacyNaviImageViewConstraints)
        NSLayoutConstraint.activate(pharmacyPhoneConstraints)
        NSLayoutConstraint.activate(pharmacyPhoneImageViewConstraints)
    }

    private func callNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
