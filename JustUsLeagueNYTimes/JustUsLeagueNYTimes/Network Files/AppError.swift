//
//  AppError.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/18/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import Foundation

enum AppError: Error {
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badURL
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
