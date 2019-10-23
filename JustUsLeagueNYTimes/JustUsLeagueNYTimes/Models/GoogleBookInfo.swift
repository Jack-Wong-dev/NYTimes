//
//  GoogleBookInfo.swift
//  JustUsLeagueNYTimes
//
//  Created by Jason Ruan on 10/21/19.
//  Copyright © 2019 Jack Wong. All rights reserved.
//

import Foundation

struct GoogleBookInfoWrapper: Codable {
    let items: [GoogleBookInfo]?
}

struct GoogleBookInfo: Codable {
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let publisher: String?
    let publishedDate: String?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: URL?
    let thumbnail: URL?
}
