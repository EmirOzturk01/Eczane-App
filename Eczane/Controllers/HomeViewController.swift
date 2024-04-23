//
//  HomeViewController.swift
//  Eczane
//
//  Created by Emir Öztürk on 10.03.2024.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController {

    private var pharmacies: [Data] = [Data] ()
    var manager = CLLocationManager()
    var latitude = Double()
    var longitude = Double()
    
    var annotationTappedBefore: Bool = false
    
    private var pharmacyInfoView: PharmacyInfoUIView?
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        view.addSubview(mapView)
        mapView.delegate = self
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    private func applyConstraints() {
        let mapViewConstraints = [
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ]
        NSLayoutConstraint.activate(mapViewConstraints)
    }
    
    func getData(latitude: String, longitude: String) {
        NetworkManager.shared.getPharmacies(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let pharmacies):
                self?.pharmacies = pharmacies
                for location in pharmacies {
                    guard let latitude = location.latitude, let longitude = location.longitude else { return }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    annotation.title = location.pharmacyName
                    annotation.subtitle = location.address ?? ""
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.mapView.addAnnotation(annotation)
                        self.mapView.reloadInputViews()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}


extension HomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        if let location = locations.first {
            manager.stopUpdatingLocation()
            
            let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.latitude = location.latitude
            self.longitude = location.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.subtitle = "CurrentLocation"
            self.mapView.addAnnotation(annotation)
            
            getData(latitude: String(latitude), longitude: String(longitude))
            
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)

        }
    }
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        var topSafeArea = CGFloat()
        
        if #available(iOS 15.0, *) {
            topSafeArea = mapView.safeAreaInsets.top
        }
        
        var tappedPharmacy: Data?
        guard let annotation = view.annotation else { return }
        
        for pharmacy in self.pharmacies {
            if pharmacy.address == annotation.subtitle {
                tappedPharmacy = pharmacy
            }
        }
        
        guard let name = tappedPharmacy?.pharmacyName, let address = tappedPharmacy?.address, let phone = tappedPharmacy?.phone, let latitude = tappedPharmacy?.latitude, let longitude = tappedPharmacy?.longitude, let distance = tappedPharmacy?.distanceKm else { return }
        pharmacyInfoView = PharmacyInfoUIView(frame: CGRect(x: 30, y: topSafeArea / 2 + 15, width: mapView.bounds.width - 60, height: 150))
        pharmacyInfoView?.configure(with: PharmacyInfoViewModel(pharmacyName: name, pharmacyAddress: address, pharmacyPhone: phone, latitude: latitude, longitude: longitude, distance: distance))
        mapView.addSubview(pharmacyInfoView!)
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        pharmacyInfoView?.removeFromSuperview()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView()
            
        if annotation.subtitle == "CurrentLocation" {
                let pinImage = UIImage(named: "placeholder")
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                annotationView.image = resizedImage
                annotationView.canShowCallout = false
            } else {
                let pinImage = UIImage(named: "eczane")
                let size = CGSize(width: 50, height: 50)
                UIGraphicsBeginImageContext(size)
                pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                annotationView.image = resizedImage
                annotationView.canShowCallout = false
            }
        return annotationView
    }
}

