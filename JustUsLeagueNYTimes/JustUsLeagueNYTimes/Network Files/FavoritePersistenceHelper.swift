//
//  FavoritesPersistenceHelper.swift
//  JustUsLeagueNYTimes
//
//  Created by Kevin Natera on 10/21/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Foundation


struct FavoritePersistenceHelper {
    static let manager = FavoritePersistenceHelper()

    func save(newFavorite: Favorite) throws {
        try persistenceHelper.save(newElement: newFavorite)
    }
    
    func getFavorites() throws -> [Favorite] {
        return try persistenceHelper.getObjects()
    }
    
    func deleteFavorite(withDate: Date) throws {
        do {
            let favorites = try getFavorites()
            let newFavorites = favorites.filter { $0.date != withDate }
            try persistenceHelper.replace(elements: newFavorites)
        }
    }
    
    
    private let persistenceHelper = PersistenceHelper<Favorite>(fileName: "favorites.plist")

    private init() {}
}
