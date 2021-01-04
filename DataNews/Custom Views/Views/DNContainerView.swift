//
//  DNContainerView.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DNContainerView: UIView {
    
    //MARK: - Constants
    
    let titleLabel = DNTitleLabel(textAligment: .center, fontSize: 20)
    let messageLabel = DNBodyLabel(textAligment: .center)
    let actionButton = DNButton(backgroundColor: .systemPink, title: "Ok")
    
    //MARK: - Properties
    
    var alertTitle: String?
    var message: String?
    var buttonTitle: String?
    
    let padding: CGFloat = 20.0
    
    //MARK: - Public methods

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainerView()
    }
    
    init(title: String, message: String, buttonTitle: String) {
        super.init(frame: .zero)
        self.alertTitle = title
        self.message = message
        self.buttonTitle = buttonTitle
        configureContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func configureContainerView() {
        backgroundColor                           = .systemBackground
        layer.cornerRadius                        = 16.0
        layer.borderWidth                         = 2.0
        layer.borderColor                         = UIColor.white.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(titleLabel, actionButton, messageLabel)
        
        configureTitleLabel()
        configureActionButton()
        configureMessageLabel()
    }
    
    private func configureTitleLabel() {
        titleLabel.text = alertTitle ?? "Something went wrong(alert title is empty)"
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func configureActionButton() {
        actionButton.setTitle(buttonTitle ?? "Ok", for: .normal)
        
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -padding),
            actionButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            actionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func configureMessageLabel() {
        messageLabel.text          = message ?? "Unable to request"
        messageLabel.numberOfLines = 4
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: actionButton.topAnchor, constant: -12)
        ])
    }
}
