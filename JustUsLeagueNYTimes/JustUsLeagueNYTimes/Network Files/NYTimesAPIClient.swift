//
//  NYTimesAPIClient.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/19/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import Foundation

class NYTimesAPIClient {
    private init() {}
    static let manager = NYTimesAPIClient()
    
    func getGenres(completionHandler: @escaping (Result<[Genre], AppError>) -> () ) {
        let urlString = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(Secrets().NYTimesAPIKey)"
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure:
                completionHandler(.failure(.noDataReceived))
            case .success(let data):
                do {
                    let genresInfo = try JSONDecoder().decode(GenreWrapper.self, from: data)
                    completionHandler(.success(genresInfo.results))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
    
    func getBestSellersForGenre(genre: String, completionHandler: @escaping (Result<BestSeller, AppError>) -> () ) {
        let urlString =  "https://api.nytimes.com/svc/books/v3/lists/current/\(genre).json?api-key=\(Secrets().NYTimesAPIKey)"
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        NetworkHelper.manager.performDataTask(withUrl: url, andMethod: .get) { (result) in
            switch result {
            case .failure:
                completionHandler(.failure(.noDataReceived))
            case .success(let data):
                do {
                    let bestSellerInfo = try JSONDecoder().decode(BestSellerWrapper.self, from: data)
                    completionHandler(.success(bestSellerInfo.results))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
        
    }
}
