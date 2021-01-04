//
//  PostDetailInfoViewModel.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class PostDetailInfoViewModel {
    
    //MARK: - Constants
    
    private let padding: CGFloat = 8.0
    
    //MARK: - Properties
    
    private let post: Post
    
    var postedDateString: String {
        return post.pubDate.fromStringFormatToNewStringFormat(newFormat: "EEEE, MMM d, yyyy")
    }
    
    var authors: String {
        
        var authorsString = ""
        
        for item in post.authors {
            authorsString += item + "\n"
        }
        
        return authorsString + "\n" + postedDateString
    }
    
    var imageUrlString: String? {
        return post.imageUrl
    }
    
    var title: String {
        return post.title
    }
    
    var descriptionText: String {
        return post.description ?? ""
    }
    
    var content: String {
        return post.content ?? ""
    }
    
    var source: String {
        return post.source
    }
    
    var postUrl: String {
        return post.url
    }
    
    //MARK: - Init
    
    init(_ post: Post) {
        self.post = post
    }
    
    //MARK: - Public methods
    
    func getHeightForTextContainer(by font: UIFont, text: String) -> CGFloat {
        return text.height(withConstrainedWidth: ScreenSize.width - padding * 2, font: font) + padding * 2
    }
}
