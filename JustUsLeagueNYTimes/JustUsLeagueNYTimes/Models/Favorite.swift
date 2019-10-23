//
//  Favorite.swift
//  JustUsLeagueNYTimes
//
//  Created by Kevin Natera on 10/21/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Foundation

struct Favorite : Codable {
    let date: Date
    let weeks_on_list: Int
    let description: String
    let book_image: URL
    let amazon_product_url: URL
}
