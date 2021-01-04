//
//  PostDetailInfoVC.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit
import SafariServices
import Photos

class PostDetailInfoVC: UIViewController {
    
    //MARK: - Constants
    
    private let rightBarButtonTitle = "Save Photo"

    //MARK: - Outlets
    
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var authorsLabel: UILabel!
    @IBOutlet private weak var postDescriptionLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet weak var fullPostButton: UIButton!
    
    @IBOutlet private weak var contentTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var authorsLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabelConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    private var viewModel: PostDetailInfoViewModel?

    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        
        
        checkAndPermitPhotoLibraryAccess()
        
        if let _ = viewModel?.imageUrlString {
            addRightButtonToNavigationBar()
        }
        
        setupUI()
        setupConstrains()
    }
    
    //MARK: - Private
    
    private func setupUI() {
        
        fullPostButton.layer.borderWidth = 1.0
        fullPostButton.layer.borderColor = UIColor.systemBlue.cgColor
        fullPostButton.layer.cornerRadius = 5.0

        guard let viewModel = self.viewModel else {
            return
        }
        
        postTitleLabel.text = viewModel.title
        authorsLabel.text = viewModel.authors
        postDescriptionLabel.text = viewModel.descriptionText
        contentLabel.text = viewModel.content
        sourceLabel.text = viewModel.source
        
        downloadImage(fromURLString: viewModel.imageUrlString)
    }
    
    private func setupConstrains() {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        titleLabelConstraint.constant = viewModel.getHeightForTextContainer(by: postTitleLabel.font, text: viewModel.title)
        contentTextHeightConstraint.constant = viewModel.getHeightForTextContainer(by: contentLabel.font, text: viewModel.content)
        descriptionTextHeightConstraint.constant =  viewModel.getHeightForTextContainer(by: postDescriptionLabel.font, text: viewModel.descriptionText)
        authorsLabelHeightConstraint.constant = viewModel.getHeightForTextContainer(by: authorsLabel.font, text: viewModel.authors)
    }
    
    private func addRightButtonToNavigationBar() {
        let button1 = UIBarButtonItem(title: rightBarButtonTitle, style: .done, target: self, action: #selector(savePhoto))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    @objc private func savePhoto() {
        
        guard let imageData = postImageView.image!.pngData(),
              let compressedImage = UIImage(data: imageData) else {
            
            self.presentDNAlertOnMainThread(title: "Something went wrong", message: "Can't save image", buttonTitle: "Ok")
            return
        }
        
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .denied {
            self.presentDNAlertOnMainThread(title: "Ooops", message: DNError.needToPermitRightsForPhotoAlbum.rawValue, buttonTitle: "Ok")
        } else {
            UIImageWriteToSavedPhotosAlbum(compressedImage, nil, nil, nil)
            self.presentDNAlertOnMainThread(title: "Success", message: "Your image has been saved", buttonTitle: "Ok")
        }
    }
    
    private func downloadImage(fromURLString url: String?) {
        
        guard let urlString = url,
              !urlString.isEmpty else {
            self.postImageView.image = UIImage(named: "NoAvailableImage")
            return
        }
        
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async { self.postImageView.image = image }
        }
    }
    
    private func checkAndPermitPhotoLibraryAccess() {
        
        let photos = PHPhotoLibrary.authorizationStatus()
        
        if photos == .notDetermined {
            PHPhotoLibrary.requestAuthorization({status in
                if status == .authorized{
                    
                } else {
                    self.presentDNAlertOnMainThread(title: "Ooops", message: DNError.needToPermitRightsForPhotoAlbum.rawValue, buttonTitle: "Ok")
                }
            })
        } else if photos == .denied  {
            self.presentDNAlertOnMainThread(title: "Ooops", message: DNError.needToPermitRightsForPhotoAlbum.rawValue, buttonTitle: "Ok")
        }
    }
    
    //MARK: - Public methods
    
    func setup(viewModel: PostDetailInfoViewModel) {
        self.viewModel = viewModel
    }
    
    //MARK: - Action
    
    @IBAction func fullPostButtonPressed(_ sender: UIButton) {
        
        guard let viewModel = self.viewModel else {
            return
        }
        
        let modalSafariVC = SFSafariViewController(url: URL(string: viewModel.postUrl)!)
        present(modalSafariVC, animated: true)
    }
}
