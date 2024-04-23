//
//  FavoritesViewController.swift
//  Eczane
//
//  Created by Emir Öztürk on 10.03.2024.
//

import UIKit

class AddressesViewController: UIViewController {
    
    private var addresses: [AddressData] = [AddressData] ()
    
    private let addressTable: UITableView = {
        let table = UITableView()
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTable.delegate = self
        addressTable.dataSource = self
        configureViewController()
        getAddresses()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("saved"), object: nil, queue: nil) { _ in
            self.getAddresses()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    private func configureViewController() {
        title = "Adreslerim"
        view.backgroundColor = .black
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        let saveAddressVC = SaveAddressVC()
        navigationController?.pushViewController(saveAddressVC, animated: true)
    }
    
    func getAddresses() {
        DataPersistence.shared.fetchAddressesFromDatabase { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let addresses):
                DispatchQueue.main.async {
                    self.addresses = addresses
                    self.updateUI(with: addresses)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func callNumber(phoneNumber: String) {
        if let url = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func showEmptyStateView() {
        let emptyStateView = EmptyStateView()
        view.addSubview(emptyStateView)
        emptyStateView.frame = view.bounds
        
    }
    
    func updateUI(with addresses: [AddressData]) {
        if addresses.isEmpty {
            showEmptyStateView()
        } else {
            DispatchQueue.main.async {
                self.view.addSubview(self.addressTable)
                self.addressTable.frame = self.view.frame
                self.addressTable.reloadData()
            }
        }
    }
}

extension AddressesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let address = addresses[indexPath.row].name
        cell.textLabel?.text = address
        cell.textLabel?.font = .systemFont(ofSize: 22, weight: .bold)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let latitude = addresses[indexPath.row].latitude
        let longitude = addresses[indexPath.row].longitude
        
        let vc = AddressMapVC(latitude: latitude, longitude: longitude)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistence.shared.deleteAddressWith(model: addresses[indexPath.row]) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success():
                    print("Deleted from the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.addresses.remove(at: indexPath.row)
                addressTable.deleteRows(at: [indexPath], with: .fade)
                if(addresses.count==0){
                    showEmptyStateView()
                }
            }
        default:
            break;
        }
    }
}
