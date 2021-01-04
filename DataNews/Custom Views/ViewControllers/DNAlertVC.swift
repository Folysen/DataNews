//
//  DNAlertVC.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DNAlertVC: UIViewController {
    
    //MARK: - Constants
    
    let titleLabel      = DNTitleLabel(textAligment: .center, fontSize: 20)
    let messageLabel    = DNBodyLabel(textAligment: .center)
    let actionButton    = DNButton(backgroundColor: .systemPink, title: "Ok")
    
    
    //MARK: - Properties
    
    var containerView: DNContainerView
    
    //MARK: - Public methods
    
    init(title: String, message: String, buttonTitle: String) {
        containerView = DNContainerView(title: title, message: message, buttonTitle: buttonTitle)
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureContainerView()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true)
    }
    
    
    //MARK: - Private methods
    
    private func configureContainerView() {
        containerView.actionButton.addTarget(self, action: #selector(dismissVC), for:.touchUpInside)
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 280),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
}
