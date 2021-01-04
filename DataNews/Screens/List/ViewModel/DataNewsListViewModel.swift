//
//  DataNewsListViewModel.swift
//  DataNews
//
//  Created by Yaroslav on 1/4/21.
//

import UIKit

typealias ImageCacheLoaderCompletionHandler = ((UIImage?) -> ())

class DataNewsListViewModel {
    
    //MARK: - Constants
    
    private let postTableViewCellHeightWithoutTitle: CGFloat = 77
    
    //MARK: - Properties
    
    private(set) var newsList: [Post] = []
    private(set) var insertDataAtTheBeginning: Bool = false
    
    private(set) var pageNumber = 0
    private(set) var language = "en"
    private(set) var country = ""
    
    private(set) var hasMorePosts = true
    private(set) var isLoadingMorePosts = false
    
    private var pageSize: Int {
        return NetworkManager.shared.pageSize
    }
    
    private var needToLoadPreviousNews: Bool {
        return (pageNumber + 1) * pageSize > newsList.count
    }
    

    //MARK: - Public methods
    
    func getNews(completion: @escaping (DNError?) -> Void) {
        
        isLoadingMorePosts = true
        
        NetworkManager.shared.getNews(page: pageNumber, language: language, country: country) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let newsData):
                
                if self.insertDataAtTheBeginning {
                    self.newsList.insert(contentsOf: newsData.hits, at: 0)
                } else {
                    self.newsList.append(contentsOf: newsData.hits)
                    
                    if newsData.hits.count < self.pageSize {
                        self.hasMorePosts = false
                    }
                }
                
                self.insertDataAtTheBeginning = false
                
                completion(nil)
                break
                
            case .failure(let error):
                completion(error)
                break
            }
            
            self.isLoadingMorePosts = false
        }
    }
    
    func getPostViewModel(for indexPath:IndexPath) -> DataNewsPostTableViewModel {
        let postViewModel = DataNewsPostTableViewModel(newsList[indexPath.row])
        return postViewModel
    }
    
    func getDetailPostViewModel(for indexPath:IndexPath) -> PostDetailInfoViewModel {
        let detailPostViewModel = PostDetailInfoViewModel(newsList[indexPath.row])
        return detailPostViewModel
    }
    
    func getPostTableViewCellHeight(for indexPath:IndexPath) -> CGFloat {
        let topPostViewModel = getPostViewModel(for: indexPath)
        return postTableViewCellHeightWithoutTitle + topPostViewModel.getRedditPostTableViewCellTitleHeight()
    }
    
    func needToLoadNews(basedOn indexPath: IndexPath) -> Bool {
        
        var needLoadData = false
        
        if hasMorePosts, !isLoadingMorePosts {
            if indexPath.row == newsList.count - 3 {
                pageNumber += 1
                needLoadData = true
                
            } else if indexPath.row == 0 && pageNumber != 0 && needToLoadPreviousNews  {
                pageNumber -= 1
                insertDataAtTheBeginning = true
                needLoadData = true
            }
        }
        
        return needLoadData
    }
    
    func downloadImage(fromURLString url: String?, completionHandler: @escaping ImageCacheLoaderCompletionHandler) {
        
        guard let urlString = url,
              !urlString.isEmpty else {
            completionHandler(UIImage(named: "NoAvailableImage"))
            return
        }
        
        NetworkManager.shared.downloadImage(from: urlString) { (image) in
            DispatchQueue.main.async { completionHandler(image) }
        }
    }
}
