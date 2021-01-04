//
//  DataNewsListVC.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

class DataNewsListVC: DNDataLoadingVC {
    
    //MARK: - Constants
    
    private let storyboardName = "Main"
    private let detailNewsVC = "PostDetailInfoVC"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Properties
    
    private let viewModel = DataNewsListViewModel()
    
    //MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Data news"
        
        navigationController?.navigationBar.isHidden = true
        
        configureTableView()
        getNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Private methods
    
    private func getNews() {
        
        showLoadingView()
        viewModel.getNews { [weak self] (error) in
            
            guard let self = self else { return }
            
            self.dismissLoadingView()
            
            if let error = error {
                self.presentDNAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            } else {
//                self.endRefreshing()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    
//                    if !self.viewModel.postId.isEmpty {
//                        self.tableView.scrollToRow(at: self.viewModel.getIndexPathOfPostIdentifier(postIdentifier: self.viewModel.postId), at: .middle, animated: false)
//                    }
                }
            }
        }
    }
    
    // MARK: - Configure tableView
    
    private func configureTableView() {
        let cellNib = UINib(nibName: DataNewsPostTableViewCell.reuseID, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: DataNewsPostTableViewCell.reuseID)
    }
}

//MARK: - UITableViewDataSource

extension DataNewsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsList.count
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataNewsPostTableViewCell.reuseID) as! DataNewsPostTableViewCell
        let postViewModel = viewModel.getPostViewModel(for: indexPath)
        
        cell.setupCell(viewModel: postViewModel)
        
        viewModel.downloadImage(fromURLString: postViewModel.imageUrlString) { (image) in
            if let updatedCell = tableView.cellForRow(at: indexPath) as? DataNewsPostTableViewCell {
                updatedCell.postImageView.image = image
            }
        }
        
        if viewModel.needToLoadNews(basedOn: indexPath) {
            getNews()
        }
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DataNewsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getPostTableViewCellHeight(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: detailNewsVC) as! PostDetailInfoVC
        detailVC.setup(viewModel: viewModel.getDetailPostViewModel(for: indexPath))
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
