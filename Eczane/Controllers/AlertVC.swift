//
//  AlertVC.swift
//  Eczane
//
//  Created by Emir Öztürk on 18.03.2024.
//

import UIKit
import MapKit

class AlertVC: UIViewController {
    
    let containerView = AlertContainerUIView()
    
    var width: Double?
    
    var pharmacy: Data?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .label
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.9
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        label.minimumScaleFactor = 0.75
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        return label
    }()
    
    private let naviButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitle("Navigasyon", for: .normal)
        button.addTarget(self, action: #selector(naviButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        return button
    }()
    
    private let phoneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitle("Ara", for: .normal)
        button.addTarget(self, action: #selector(phoneButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        return button
    }()
    @objc func naviButtonTapped() {
        guard let pharmacy = pharmacy else { return }
        guard let latitude = pharmacy.latitude, let longitude = pharmacy.longitude else { return }
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = pharmacy.pharmacyName
        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
    }
    
    @objc func phoneButtonTapped(){
        guard let number = pharmacy?.phone else { return }
        var newNumber = number
        let chars = [" ","-","(",")"]
        
        for char in chars {
            newNumber = newNumber.replacingOccurrences(of: "\(char)", with: "")
        }
        callNumber(phoneNumber: newNumber)
    }
    private func callNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    init(pharmacy: Data, width: Double) {
        super.init(nibName: nil, bundle: nil)
        
        self.pharmacy = pharmacy
        self.titleLabel.text = pharmacy.pharmacyName
        self.width = width
        
        messageLabel.text = "Lütfen \(pharmacy.pharmacyName!) hakkında yapmak istediğiniz işlemi seçiniz."
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.addSubview(containerView)
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(phoneButton)
        view.addSubview(naviButton)
        applyConstraints()
        dismissVCTapGesture()
    }
    
    func dismissVCTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped() {
        dismiss(animated: true)
    }
    
    let padding: CGFloat = 20
    private func applyConstraints() {
        let containerViewConstraints = [
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: width! - 40),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ]
        
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ]
        
        let messageLabelConstraints = [
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: naviButton.topAnchor, constant: -12)
        ]
        
        let phoneButtonConstraints = [
            phoneButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            phoneButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding),
            phoneButton.trailingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: -padding),
            phoneButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        let naviButtonConstraints = [
            naviButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding),
            naviButton.leadingAnchor.constraint(equalTo: containerView.centerXAnchor, constant: padding),
            naviButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding),
            naviButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(messageLabelConstraints)
        NSLayoutConstraint.activate(naviButtonConstraints)
        NSLayoutConstraint.activate(phoneButtonConstraints)
    }
}
