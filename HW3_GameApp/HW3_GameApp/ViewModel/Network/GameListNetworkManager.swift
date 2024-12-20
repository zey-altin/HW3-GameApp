//
//  GameListNetworkManager.swift
//  HW3_GameApp
//
//  Created by Zeynep Nur Altın on 25.05.2024.
//

import Foundation

func ParsingJson(completion: @escaping ([Results]) ->()){
    
    let baseUrl = "https://api.rawg.io/api/games?key="
    let APIkey = "595d3aee003c4f8cb81f9a4555975bb2"
    let urlString = baseUrl + APIkey
    let url = URL(string: urlString)
    
    guard url != nil else {
        print("Url error")
        return
    }
        
    let session = URLSession.shared
    
    let task = session.dataTask(with: url!) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        guard let jsonData = data else {
            print("No data received")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let parsingData = try decoder.decode(Games.self, from: jsonData)
            if let results = parsingData.results {
                completion(results)
            } else {
                print("No results found")
            }
        } catch {
            print("Parsing error: \(error)")
        }
    }
    task.resume()
}
