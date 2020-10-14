//
//  NewsDataModel.swift
//  OptisolTask
//
//  Created by Santhosh on 12/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import Foundation


// MARK: - Model Element
struct NewsResponse: Decodable {
    let articles : [articleArr]
}

struct articleArr : Decodable {
    let source : sourceDict
    let title: String?
    let description: String?
    let publishedAt: String?
    let imageUrl : URL?

    enum CodingKeys : String , CodingKey {
        case title, description, publishedAt, source
        case imageUrl = "urlToImage"
    }
}

struct sourceDict : Decodable {
    let name : String?
}
