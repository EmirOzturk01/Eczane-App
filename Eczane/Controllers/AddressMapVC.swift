//
//  AddressMapVC.swift
//  Eczane
//
//  Created by Emir Öztürk on 27.03.2024.
//

import UIKit
import MapKit

class AddressMapVC: UIViewController {

    private var pharmacies: [Data] = [Data] ()
    
    var annotationTappedBefore: Bool = false
    
    var latitude: Double!
    var longitude: Double!
    
    init(latitude: Double, longitude: Double) {
        super.init(nibName: nil, bundle: nil)
        
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        configureMapview()
        getData()
    }
    
    private func configureMapview() {
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.latitude = location.latitude
        self.longitude = location.longitude
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
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
    
    func getData() {
        guard let latitudeDouble = self.latitude, let longitudeDouble = self.longitude else { return }
        let latitude = String(latitudeDouble)
        let longitude = String(longitudeDouble)
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
extension AddressMapVC: MKMapViewDelegate {
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
        if mapView.annotations.count > 1 {
            
            var annotationView = MKAnnotationView()
            let pinImage = UIImage(named: "eczane")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView.image = resizedImage
            annotationView.canShowCallout = false
            
            return annotationView
        } else {
            var annotationView = MKAnnotationView()
            let pinImage = UIImage(named: "placeholder")
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            annotationView.image = resizedImage
            annotationView.canShowCallout = false
            return annotationView
        }
    }

}

