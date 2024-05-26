//
//  Games.swift
//  HW3_GameApp
//
//  Created by Zeynep Nur Altın on 26.05.2024.
//

import Foundation

struct Games: Decodable {
    let results : [Results]?
}

struct Results : Decodable {
    let rating : Float?
    let name : String?
    let released : Date?
    let backgroundImage : String?
    let platforms : [Platforms]?
    
    enum CodingKeys: String, CodingKey {
        case rating
        case name
        case released
        case backgroundImage = "background_image"
        case platforms
    }
}

struct Platforms : Decodable {
    let requirements : Requirements?
    
    enum CodingKeys: String, CodingKey {
        case requirements = "requirements_en"
    }
}

struct Requirements : Decodable {
    let description : String?
    
    enum CodingKeys: String, CodingKey {
        case description = "minimum"
    }
}
