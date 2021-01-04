//
//  DataNewsPostTableViewModel.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DataNewsPostTableViewModel {
    
    //MARK: - Constants

    private let defaultPostTableViewCellTitleHeight: CGFloat = 59.0
    private let cellLeftAndRightPaddingSummary: CGFloat = 130
    private let postTableViewCellFont = UIFont.systemFont(ofSize: 17.0)
    
    //MARK: - Properties
    
    private let post: Post
    
    var title: String {
        return post.title
    }
    
    var source: String {
        return post.source
    }
    
    var imageUrlString: String? {
        return post.imageUrl
    }
    
    var postedByString: String {
        
        let currentDateTime = Date().localDate()
        let createDate = post.pubDate.toDate()
        
        if currentDateTime < createDate {
            return "Posted recently"
        } else {
            
            let interval = currentDateTime - createDate
            
            var timeAgoString = ""
            
            if let yearCount = interval.year, yearCount == 1 {
                timeAgoString = "\(yearCount) year"
            } else if let yearCount = interval.year, yearCount > 1 {
                timeAgoString = "\(yearCount) years"
            } else if let monthCount = interval.month, monthCount == 1 {
                timeAgoString = "\(monthCount) month"
            } else if let monthCount = interval.month, monthCount > 1 {
                timeAgoString = "\(monthCount) months"
            } else if let dayCount = interval.day, dayCount == 1 {
                timeAgoString = "\(dayCount) day"
            } else if let dayCount = interval.day, dayCount > 1 {
                timeAgoString = "\(dayCount) days"
            } else if let hoursCount = interval.hour, hoursCount == 1{
                timeAgoString = "\(hoursCount) hour"
            } else if let hoursCount = interval.hour, hoursCount > 1{
                timeAgoString = "\(hoursCount) hours"
            } else if let minutesCount = interval.minute, minutesCount > 1 {
                timeAgoString = "\(minutesCount) minutes"
            } else {
                return "Posted recently"
            }
            
            return "Posted " + timeAgoString + " ago"
        }
    }
    
    // MARK: - Init
    
    init(_ post: Post) {
        self.post = post
    }
    
    //MARK: - Public method
    
    func getRedditPostTableViewCellTitleHeight() -> CGFloat {
        
        let labelHeight = title.height(withConstrainedWidth: CGFloat(ScreenSize.width - CGFloat(cellLeftAndRightPaddingSummary)), font: postTableViewCellFont)
        
        return (labelHeight < defaultPostTableViewCellTitleHeight ? defaultPostTableViewCellTitleHeight : labelHeight)
    }
}
