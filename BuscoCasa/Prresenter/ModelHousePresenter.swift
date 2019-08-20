//
//  ModelHousePresenter.swift
//  buscoCasa
//
//  Created by Rodrigo Pintos Costa on 8/20/19.
//  Copyright © 2019 Rodrigo Pintos. All rights reserved.
//

import Foundation
import UIKit

class ModelHousePresenter {
    private let apiClient : APIClient
    private var houseDelegate : HouseModelDelegate?

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func setViewDelegate(houseDelegate:HouseModelDelegate?){
        self.houseDelegate = houseDelegate!
    }
    
    func getHouseModels() {
        apiClient.fetchPlaces { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    self.houseDelegate!.displayHouseResults(resultList: places.results, networkError: nil)
                }
            case .failure(let error):
                self.houseDelegate!.displayHouseResults(resultList: [], networkError: error)
            }
        }
    }
}
