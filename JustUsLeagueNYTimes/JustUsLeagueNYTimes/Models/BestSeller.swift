//
//  BestSeller.swift
//  NYTimes Project
//
//  Created by Jason Ruan on 10/19/19.
//  Copyright © 2019 Just Us League. All rights reserved.
//

import Foundation

struct GenreWrapper: Codable {
    let results: [Genre]
}

struct Genre: Codable {
    let listName: String
    let displayName: String
    let listNameEncoded: String
    let oldestPublishedDate: String
    let newestPublishedDate: String
    let updated: String
    
    private enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
        case updated
    }
}

struct BestSellerWrapper: Codable {
    let results: BestSeller
}

struct BestSeller: Codable {
    let listName: String
    let displayName: String
    let listNameEncoded: String
    let bestSellersDate: String
    let updated: String
    let books: [Book]
    
    
    private enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case bestSellersDate = "bestsellers_date"
        case updated
        case books
    }
}

struct Book: Codable {
    let rank: Int
    let weeksOnList: Int
    let ISBN13: String
    let publisher: String
    let description: String
    let title: String
    let author: String
    let contributor: String
    let contributorNote: String
    let bookImage: URL
    let bookImageWidth: Int
    let bookImageHeight: Int
    let amazonProductURL: URL
    
    
    
    private enum CodingKeys: String, CodingKey {
        case rank
        case weeksOnList = "weeks_on_list"
        case ISBN13 = "primary_isbn13"
        case publisher
        case description
        case title
        case author
        case contributor
        case contributorNote = "contributor_note"
        case bookImage = "book_image"
        case bookImageWidth = "book_image_width"
        case bookImageHeight = "book_image_height"
        case amazonProductURL = "amazon_product_url"
    }
}
