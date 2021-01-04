//
//  Constants.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

enum ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
}
