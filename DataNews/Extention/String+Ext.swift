//
//  String+Ext.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height) + 5
    }
    
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = self.contains("+") ? format : "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else {
            return Date()
        }
        
        return date
        
    }
    
    func fromStringFormatToNewStringFormat(format: String = "yyyy-MM-dd'T'HH:mm:ssZ", newFormat: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = self.contains("+") ? format : "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dateFormatter.date(from: self) else {
            return  dateFormatter.string(from: Date())
        }
        
        dateFormatter.dateFormat = newFormat
        
        return dateFormatter.string(from: date)
    }
}
