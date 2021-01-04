//
//  NewsData.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import Foundation

struct NewsData: Codable {
    var status: Int
    var message: String?
    var numResults: Int?
    var hits: [Post]
}
