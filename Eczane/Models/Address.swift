//
//  Address.swift
//  Eczane
//
//  Created by Emir Öztürk on 23.03.2024.
//

import Foundation

struct Address: Codable{
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
}
