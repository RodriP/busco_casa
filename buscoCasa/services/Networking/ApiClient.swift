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
    
    
    private let session = URLSession.shared
    private let url = URL(string:"https://api.mercadolibre.com/sites/MLA/search?item_location=lat:-37.987148_-30.987148,lon:-57.5483864_-50.5483864&category=MLA1459&limit=10")!
    
    
    func fetchPlaces(completion: @escaping (Result<HouseModel, NetworkError>) -> ()) {
        
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
