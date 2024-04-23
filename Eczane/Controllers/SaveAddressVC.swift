//
//  SaveAddressVC.swift
//  Eczane
//
//  Created by Emir Öztürk on 22.03.2024.
//

import UIKit
import MapKit
import CoreLocation

class SaveAddressVC: UIViewController {

    var manager = CLLocationManager()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 10
        map.clipsToBounds = true
        return map
    }()
    
    private let nameTextfield = CustomTextField()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBackground
        button.setTitle("Kaydet", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private let infoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "info.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.backgroundColor = .none
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(infoButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let pharmacyName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.backgroundColor = .darkGray
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.text = "Kaydetmek istediğiniz adresi 3 saniye basılı tutarak harita üzerinde işaretleyebilirsiniz."
        return label
    }()
    
    var infoTappedBefore = false
    var secilenLatitude: Double?
    var secilenLongitude: Double?
    var annotationAddedBefore = false

    @objc func saveButtonTapped() {
        guard let latitude = secilenLatitude, let longitude = secilenLongitude, let name = nameTextfield.text else { return }
        DataPersistence.shared.saveAddressWith(model: Address(id: UUID(), name: name, latitude: latitude, longitude: longitude)) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("saved"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func configureLabelConstraints() {
        pharmacyName.topAnchor.constraint(equalTo: infoButton.bottomAnchor).isActive = true
        pharmacyName.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor).isActive = true
        pharmacyName.heightAnchor.constraint(equalToConstant: 70).isActive = true
        pharmacyName.widthAnchor.constraint(equalToConstant: 220).isActive = true
    }
    
    @objc func infoButtonPressed() {
        if infoTappedBefore {
            infoTappedBefore = false
            pharmacyName.removeFromSuperview()
        } else {
            infoTappedBefore = true
            mapView.addSubview(pharmacyName)
            configureLabelConstraints()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        view.addSubview(nameTextfield)
        view.addSubview(saveButton)
        mapView.addSubview(infoButton)
        configureViewController()
        nameTextfield.delegate = self
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(konumSec))
        gestureRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func konumSec(gestureRecognizer : UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began {
            let dokunulanNokta = gestureRecognizer.location(in:mapView)
            let dokunulanKoordinat = mapView.convert(dokunulanNokta, toCoordinateFrom: mapView)
            
            secilenLatitude = dokunulanKoordinat.latitude
            secilenLongitude = dokunulanKoordinat.longitude
            if !annotationAddedBefore {
                let annotation = MKPointAnnotation()
                annotation.coordinate = dokunulanKoordinat
                mapView.addAnnotation(annotation)
                annotationAddedBefore = true
            }
            else {
                mapView.removeAnnotation(mapView.annotations.first!)
                let annotation = MKPointAnnotation()
                annotation.coordinate = dokunulanKoordinat
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func configureViewController() {
        view.backgroundColor = .black
    }
    
    private func applyConstraints() {
        
        let mapViewConstraints = [
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: nameTextfield.topAnchor, constant: -15)
        ]
        
        let nameTextFieldConstraints = [
            nameTextfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameTextfield.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            nameTextfield.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -15),
            nameTextfield.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let saveButtonConstraints = [
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let infoButtonConstraints = [
            infoButton.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 5),
            infoButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -5),
            infoButton.heightAnchor.constraint(equalToConstant: 40),
            infoButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(mapViewConstraints)
        NSLayoutConstraint.activate(nameTextFieldConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(infoButtonConstraints)
    }
}

extension SaveAddressVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            //self.latitude = location.latitude
            //self.longitude = location.longitude
                        
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            
        }
    }
}
extension SaveAddressVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
