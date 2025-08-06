//
//  Digimon.swift
//  DigiHunt
//
//  Created by Sahil ChowKekar on 3/3/25.
//

import Foundation

struct Digimon: Decodable {
    let name: String
    let img: String
    let level: String
}

extension Digimon: Identifiable {
    var id: String {
        return name + img
    }
}

//{
//    "name": "Koromon",
//    "img": "https://digimon.shadowsmith.com/img/koromon.jpg",
//    "level": "In Training"
//  }
