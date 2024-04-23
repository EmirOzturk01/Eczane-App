//
//  NetworkManager.swift
//  Eczane
//
//  Created by Emir Öztürk on 11.03.2024.
//

import Foundation

enum APIError: Error {
    case failedTogetData
}

class NetworkManager {
    static let shared = NetworkManager()

    func getPharmacies(latitude: String, longitude: String, completed: @escaping (Result<[Data], Error>) -> Void) {
        
        var baseUrl: String?
        
        if MesaiTime().isNormalTime() {
            baseUrl = Constants.baseURLforLocationEczane
        } else {
            baseUrl = Constants.baseURLforLocationNobetci
        }
        
        guard let baseUrl = baseUrl else { return }
        // boşluğu sil çalışmasın diye ekledim
        guard let url = URL(string: "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)&apiKey=\(Constants.API_KEY)") else { return }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(Pharmacy.self, from: data)
                completed(.success(results.data))
            } catch {
                completed(.failure(error))
            }
        }
        task.resume()
    }
}
