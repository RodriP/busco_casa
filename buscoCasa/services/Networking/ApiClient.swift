//
//  APIClient.swift
//  Restaurants
//
//  Created by Maximiliano Chiesa on 7/25/19.
//  Copyright © 2019 Maximiliano Chiesa. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case unknownError
    case parseError
    case noDataError
    case responseError
    case badRequestError
    case notAuthorizedError
    case notFoundError
    case clientError
    case serverError
}

class APIClient {
    
    private var latitude : String
    private var longitude : String
    private let lat : String = "lat:"
    private let long : String = "lon:"
    private let underseparator : String = "_"
    
    init(latitude: String, longitude : String) {
        self.latitude = latitude
        self.longitude = longitude
    }

    
    private let session = URLSession.shared
    
    func fetchPlaces(completion: @escaping (Result<HouseModel, NetworkError>) -> ()) {
        let url = URL(string:"https://api.mercadolibre.com/sites/MLA/search?item_location=" + lat + latitude + underseparator + prepareLatitudeLocation() + long + longitude + underseparator + prepareLongitudeLocation() + "&category=MLA1459&limit=10")!
        
        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unknownError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            guard response.statusCode == 200 else {
                let error = self.networkError(forStatusCode: response.statusCode)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noDataError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let houseModels = try decoder.decode(HouseModel.self, from: data)
                completion(.success(houseModels))
            } catch {
                completion(.failure(.parseError))
            }
            }.resume()
    }
    
    private func prepareLatitudeLocation () -> String {
        //This only works in ARG and thats why lat and log starts with - always and we didnt consider another cases
        if latitude.starts(with: "-") {
            let newLatitude : Double = Double (latitude)! + 7.000000
            return String(newLatitude)
        }
        return ""
    }
    
    private func prepareLongitudeLocation() -> String {
        if longitude.starts(with: "-"){
            let newLongitude : Double = Double (longitude)! + 7.000000
            return String(newLongitude)
        }
        return ""
    }
    
    private func networkError(forStatusCode statusCode: Int) -> NetworkError {
        switch statusCode {
        case 400:
            return .badRequestError
        case 401:
            return .notAuthorizedError
        case 404:
            return .notFoundError
        case 405...499:
            return .clientError
        case 500...599:
            return .serverError
        default:
            return .unknownError
        }
    }
    
}
