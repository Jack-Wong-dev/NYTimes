//
//  GoogleAPIClient.swift
//  JustUsLeagueNYTimes
//
//  Created by Jason Ruan on 10/21/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Foundation

class GoogleAPIClient {
    private init() {}
    static let manager = GoogleAPIClient()
    
    func getBookSummary(isbn: String, completionHandler: @escaping(Result<GoogleBookInfo, AppError>) -> () ) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(Secrets().GoogleAPIKey)"
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
                    let googleBookInfo = try JSONDecoder().decode(GoogleBookInfoWrapper.self, from: data)
                    guard let info = googleBookInfo.items?.first else {
                        completionHandler(.failure(.unauthenticated))
                        return
                    }
                    completionHandler(.success((info)))
                } catch {
                    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
                }
            }
        }
    }
}
