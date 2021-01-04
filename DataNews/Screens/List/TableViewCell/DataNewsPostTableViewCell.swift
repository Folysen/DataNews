//
//  DataNewsPostTableViewCell.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DataNewsPostTableViewCell: UITableViewCell {
    
    //MARK: - Constants
    
    static let reuseID = "DataNewsPostTableViewCell"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var sourceLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet private weak var postTitleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    //MARK: - Properties
    
    private var viewModel: DataNewsPostTableViewModel?
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Public methods
    
    func setupCell(viewModel: DataNewsPostTableViewModel) {
        
        self.viewModel = viewModel
        
        self.postImageView.image = nil
        
        sourceLabel.text = viewModel.source
        postTitleLabel.text = viewModel.title
        dateLabel.text = viewModel.postedByString

        guard let urlString = viewModel.imageUrlString,
              !urlString.isEmpty else {
            self.postImageView.image = UIImage(named: "NoAvailableImage")
            return
        }
    }
}
