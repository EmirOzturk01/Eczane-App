//
//  Pharmacy.swift
//  Eczane
//
//  Created by Emir Öztürk on 11.03.2024.
//

import Foundation

struct Pharmacy: Codable{
    let data: [Data]
}

struct Data: Codable {
    let pharmacyID: Int
    let pharmacyName: String?
    let address: String?
    let city: String?
    let district: String?
    let phone: String?
    let pharmacyDutyStart: String?
    let pharmacyDutyEnd: String?
    let latitude: Double?
    let longitude: Double?
    let distanceKm: Double?
}
