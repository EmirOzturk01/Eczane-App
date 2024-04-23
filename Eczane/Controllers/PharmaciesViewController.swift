//
//  MapViewController.swift
//  Eczane
//
//  Created by Emir Öztürk on 10.03.2024.
//

import UIKit
import CoreLocation

class PharmaciesViewController: UIViewController {
    
    private var pharmacies: [Data] = [Data] ()
    
    var manager = CLLocationManager()
    
    private let pharmacyTable: UITableView = {
        let table = UITableView()
        table.register(EczaneInfoTableViewCell.self, forCellReuseIdentifier: EczaneInfoTableViewCell.identifier)
        table.separatorStyle = .none
        table.backgroundColor = .black
        return table
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        view.addSubview(pharmacyTable)
        title = "Eczane Listesi"
        pharmacyTable.delegate = self
        pharmacyTable.dataSource = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pharmacyTable.frame = view.bounds
    }
    
    func getData(latitude: String, longitude: String) {
        NetworkManager.shared.getPharmacies(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .success(let pharmacies):
                self?.pharmacies = pharmacies
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.pharmacyTable.reloadData()
                    self.view.bringSubviewToFront(self.pharmacyTable)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension PharmaciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pharmacies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EczaneInfoTableViewCell.identifier, for: indexPath) as? EczaneInfoTableViewCell else { return UITableViewCell() }
        let pharmacy = pharmacies[indexPath.row]
        guard let name = pharmacy.pharmacyName, let address = pharmacy.address, let phone = pharmacy.phone, let latitude = pharmacy.latitude, let longitude = pharmacy.longitude, let distance = pharmacy.distanceKm else { return UITableViewCell()}
        cell.configure(with: PharmacyInfoViewModel(pharmacyName: name, pharmacyAddress: address, pharmacyPhone: phone, latitude: latitude, longitude: longitude, distance: distance))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pharmacy = pharmacies[indexPath.row]
        
        DispatchQueue.main.async {
            let alertVC = AlertVC(pharmacy: pharmacy, width: self.view.frame.width)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC, animated: true)
        }
    }
    
    
}
extension PharmaciesViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let location = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let latitude = location.latitude
            let longitude = location.longitude
            getData(latitude: String(latitude), longitude: String(longitude))
        }
    }
}
