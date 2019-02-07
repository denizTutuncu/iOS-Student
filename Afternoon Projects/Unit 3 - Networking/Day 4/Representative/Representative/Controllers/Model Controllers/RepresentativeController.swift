//
//  RepresentativeController.swift
//  Representative
//
//  Created by Deniz Tutuncu on 2/7/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class RepresentativeController {
    
    static let baseURL = URL(string: "http://whoismyrepresentative.com/getall_reps_bystate.php")
    
    static func searchRepresentatives(forState state: String, completion: @escaping ([Representative]) -> Void) {
        guard let url = baseURL else { completion([]); return }
        //url.appendPathComponent("state")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: "state", value: state.lowercased())
        let jsonQuery = URLQueryItem(name: "output", value: "json")
        components?.queryItems = [stateQuery, jsonQuery]
        
        guard let componentsURL = components?.url else { completion([]); return }
        var request = URLRequest(url: componentsURL)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching data for \(state): \(error): \(error.localizedDescription)")
                completion([])
                return
            }
            guard let data = data else { completion([]); return }
            let dataAsString = String(data: data, encoding: .ascii)
            guard let newData = dataAsString?.data(using: .utf8) else { return }
            
            do {
                let jsonDecoder = JSONDecoder()
                let topLevelJSON = try jsonDecoder.decode(TopLevelJSON.self, from: newData)
                let representatives = topLevelJSON.results
                completion(representatives)
            } catch {
                print("Error Decoding state for \(state): \(error): \(error.localizedDescription)")
                completion([])
                return
            }
            }.resume()
    }
}
