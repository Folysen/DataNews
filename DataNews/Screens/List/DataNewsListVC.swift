//
//  DataNewsListVC.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

enum FilterType: Int {
    case country
    case language
}

class DataNewsListVC: DNDataLoadingVC {
    
    //MARK: - Constants
    
    private let storyboardName = "Main"
    private let detailNewsVCId = "PostDetailInfoVC"
    private let filterVCId = "FilterVC"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Properties
    
    var restorationInfo: [AnyHashable: Any]?
    private let viewModel = DataNewsListViewModel()
    
    //MARK: - Life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Data news"
        
        configureTableView()
        viewModel.retrieve(restorationinfo: self.restorationInfo)
        getNews()
        addRightButtonToNavigationBar()
        addLeftButtonToNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.userActivity = self.view.window?.windowScene?.userActivity
        self.restorationInfo = nil
    }
    
    override func updateUserActivityState(_ activity: NSUserActivity) {
        super.updateUserActivityState(activity)
        
        if viewModel.newsList.isEmpty {
            return
        }
        
        var indexPathRow = 0
        
        if let visible = tableView.indexPathsForVisibleRows,
           !visible.isEmpty {
            
            let indexPath = visible[0]
            indexPathRow = indexPath.row
        }
        
        let post = viewModel.newsList[indexPathRow]

        activity.addUserInfoEntries(from: ["pageNumber": viewModel.getCurrentPage(basedOn: indexPathRow)])
        activity.addUserInfoEntries(from: ["postsId": post.url])
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    
                    if !self.viewModel.postId.isEmpty {
                        self.tableView.scrollToRow(at: self.viewModel.getIndexPathOfPostIdentifier(postIdentifier: self.viewModel.postId), at: .top, animated: false)
                    }
                }
            }
        }
    }
    
    private func updateNews() {
        
        self.showLoadingView()
        
        viewModel.updateNews { [weak self] (error, insertDataAtTheBeginning) in
            
            guard let self = self else { return }
            
            self.dismissLoadingView()
  
            if let error = error {
                self.presentDNAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            
            } else {
                DispatchQueue.main.async {
  
                    if insertDataAtTheBeginning {
                        let initialOffset = self.tableView.contentOffset.y
                        self.tableView.reloadData()
                        self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.pageSize, section: 0), at: .top, animated: false)
                        self.tableView.contentOffset.y += initialOffset
                        
                    } else {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    private func showActionSheet() {
        let alertController = UIAlertController(title: "Choose filters", message: "", preferredStyle: .actionSheet)
        
        let chooseLanguageAction = UIAlertAction(title: "Choose language", style: .default, handler: { (action) -> Void in
            self.openFiltersVC(with: .language)
        })
        
        let chooseCountryAction = UIAlertAction(title: "Choose country", style: .default, handler: { (action) -> Void in
            self.openFiltersVC(with: .country)
        })
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            print("Cancel button tapped")
        })
        
        
        alertController.addAction(chooseLanguageAction)
        alertController.addAction(chooseCountryAction)
        alertController.addAction(cancelButton)
        
        navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    private func openFiltersVC(with filterType: FilterType) {
  
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: nil)
        let filterVC = storyboard.instantiateViewController(withIdentifier: self.filterVCId) as! FilterVC
        filterVC.setup(viewModel: FilterViewModel(filterType))
        filterVC.delegate = self
        
        let navVC = UINavigationController(rootViewController: filterVC)
        navVC.modalPresentationStyle = .overFullScreen
        self.present(navVC, animated: true)
    }
    
    private func addRightButtonToNavigationBar() {
        let button1 = UIBarButtonItem(image: UIImage(named: "dots"), style:.plain, target: self, action: #selector(openPickerView))
        self.navigationItem.rightBarButtonItem  = button1
    }
    
    private func addLeftButtonToNavigationBar() {
        let button1 = UIBarButtonItem(image: UIImage(named: "searchIcon"), style:.plain, target: self, action: #selector(goToSearchVC))
        self.navigationItem.leftBarButtonItem  = button1
    }
    
    @objc private func openPickerView() {
        showActionSheet()
    }
    
    @objc private func goToSearchVC() {
        
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
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension DataNewsListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.getPostTableViewCellHeight(for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if viewModel.needToLoadNews(basedOn: indexPath) {
            updateNews()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: detailNewsVCId) as! PostDetailInfoVC
        detailVC.setup(viewModel: viewModel.getDetailPostViewModel(for: indexPath))
        
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - FilterVCDelegate

extension DataNewsListVC: FilterVCDelegate {
    
    func reloadContent() {
        viewModel.clearAllData()
        getNews()
    }
}
