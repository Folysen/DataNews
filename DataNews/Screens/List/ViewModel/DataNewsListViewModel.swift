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
    
    let defaults = UserDefaults.standard
    let langCodeKey = "langCode"
    let countryCodeKey = "countryCode"
    
    private let postTableViewCellHeightWithoutTitle: CGFloat = 77
    
    //MARK: - Properties
    
    private(set) var newsList: [Post] = []
    private(set) var insertDataAtTheBeginning: Bool = false
    
    private(set) var hasMorePosts = true
    private(set) var isLoadingMorePosts = false
    
    private(set) var postId = ""
    private(set) var pageNumber = 1
    //Last biggest page number that have been loaded
    private(set) var lastBiggestLoadedPageNumber = 1
    
    var language: String {
        guard let languageCode = defaults.string(forKey: langCodeKey) else {
            defaults.set("en", forKey: langCodeKey)
            return "en"
        }
        
        return languageCode
    }
    
    var country: String {
        guard let countryCode = defaults.string(forKey: countryCodeKey) else {
            defaults.set("", forKey: countryCodeKey)
            return ""
        }
        
        return countryCode
    }
    
    var pageSize: Int {
        return NetworkManager.shared.pageSize
    }
    
    private var needToLoadPreviousNews: Bool {
        return lastBiggestLoadedPageNumber * pageSize != newsList.count
    }
    

    //MARK: - Public methods
    
    func getNews(completion: @escaping (DNError?) -> Void) {
        
        isLoadingMorePosts = true
        
        //page index starts from "0" so we need to substract "1" from "pageNumber".
        NetworkManager.shared.getNews(page: pageNumber - 1, language: language, country: country) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let newsData):
                
                if self.insertDataAtTheBeginning {
                    self.newsList.insert(contentsOf: newsData.hits, at: 0)
                } else {
                    self.newsList.append(contentsOf: newsData.hits)
                    self.hasMorePosts = newsData.hits.count < self.pageSize ? false : true
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
    
    func updateNews(completion: @escaping (DNError?, Bool) -> Void) {
        
        isLoadingMorePosts = true
        
        //page index starts from "0" so we need to substract "1" from "pageNumber".
        NetworkManager.shared.getNews(page: pageNumber - 1, language: language, country: country) { [weak self] result in
            
            guard let self = self else { return }
            
            switch result {
            
            case .success(let newsData):
                
                if self.insertDataAtTheBeginning {
                    self.newsList.insert(contentsOf: newsData.hits, at: 0)
                } else {
                    self.newsList.append(contentsOf: newsData.hits)
                    self.hasMorePosts = newsData.hits.count < self.pageSize ? false : true
                }

                completion(nil, self.insertDataAtTheBeginning)
                
                self.insertDataAtTheBeginning = false
                
                break
                
            case .failure(let error):
                completion(error, false)
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

                lastBiggestLoadedPageNumber += 1
                pageNumber = lastBiggestLoadedPageNumber
                needLoadData = true
                
            } else if indexPath.row == 0 && pageNumber != 1 && needToLoadPreviousNews {
                
                pageNumber = minimalPageNumberOfCurrentDataNewsList()
                insertDataAtTheBeginning = true
                needLoadData = true
            }
        }
        
        return needLoadData
    }
    
    func minimalPageNumberOfCurrentDataNewsList() -> Int {

        let itemsCountForAllPages = lastBiggestLoadedPageNumber * pageSize
        let currentItemsCount = newsList.count
        let itemsDiff = itemsCountForAllPages - currentItemsCount
        
        let minimalPageNumberOfCurrentDataNewsList = itemsDiff/pageSize

        return minimalPageNumberOfCurrentDataNewsList
    }
    
    func getCurrentPage(basedOn index: Int) -> Int {
        
        //because of zero index in collection we need to add "1"
        let ratio = index/pageSize + 1
        let currentPage = minimalPageNumberOfCurrentDataNewsList() + ratio

        return currentPage
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
    
    func getIndexPathOfPostIdentifier(postIdentifier: String) -> IndexPath {
        guard let index = newsList.firstIndex(where: { $0.url == postIdentifier }) else {
            return IndexPath(row: 0, section: 0)
        }
        
        postId = ""
        
        return IndexPath(row: index, section: 0)
    }
    
    func retrieve(restorationinfo: [AnyHashable: Any]?) {
        
        guard let info = restorationinfo,
              let pageNumber = info["pageNumber"] as? Int,
              let postId = info["postsId"] as? String else {
            return
        }
        
        self.postId = postId
        self.pageNumber = pageNumber
        lastBiggestLoadedPageNumber = pageNumber
    }
    
    func clearAllData() {
        
        newsList = [Post]()
        insertDataAtTheBeginning = false
        
        hasMorePosts = true
        isLoadingMorePosts = false
        
        postId = ""
        pageNumber = 1
        lastBiggestLoadedPageNumber = 1
    }
}
