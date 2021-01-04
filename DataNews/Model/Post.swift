//
//  Post.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import Foundation

struct Post: Codable {
    var url: String
    var source: String
    var authors: [String]
    var title: String
    var pubDate: String
    var country: String?
    var language: String?
    var description: String?
    var imageUrl: String?
    var content: String?
}
