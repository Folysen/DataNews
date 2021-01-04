//
//  DNBodyLabel.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DNBodyLabel: UILabel {
    
    //MARK: - Public methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(textAligment: NSTextAlignment) {
        self.init(frame: .zero)
        self.textAlignment = textAligment
    }
    
    //MARK: - Private methods
    
    private func configure () {
        textColor                                 = .secondaryLabel
        font                                      = UIFont.preferredFont(forTextStyle: .body)
        adjustsFontForContentSizeCategory         = true
        adjustsFontSizeToFitWidth                 = true
        minimumScaleFactor                        = 0.75
        lineBreakMode                             = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
