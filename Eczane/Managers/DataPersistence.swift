//
//  DataPersistence.swift
//  Eczane
//
//  Created by Emir Öztürk on 23.03.2024.
//

import Foundation
import UIKit
import CoreData

class DataPersistence {
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistence()
    
    func saveAddressWith(model: Address, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let address = AddressData(context: context)
        
        address.id = model.id
        address.name = model.name
        address.latitude = model.latitude
        address.longitude = model.longitude
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchAddressesFromDatabase(completion: @escaping (Result<[AddressData],Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<AddressData>
        
        request = AddressData.fetchRequest()
        
        do {
            let addresses = try context.fetch(request)
            completion(.success(addresses))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteAddressWith(model: AddressData, completion: @escaping(Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
