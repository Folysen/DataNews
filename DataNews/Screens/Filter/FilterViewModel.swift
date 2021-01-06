//
//  FilterViewModel.swift
//  DataNews
//
//  Created by Yaroslav on 1/5/21.
//

import Foundation

class FilterViewModel {
    
    //MARK: - Constants
    
    let countryCodeKey = "countryCode"
    let langCodeKey = "langCode"
    
    let defaults = UserDefaults.standard
    
    let filterCountryArray = [["country": "United States", "countryCode": "us"],
                       ["country": "Great Britain", "countryCode": "gb"],
                       ["country": "Germany", "countryCode": "de"],
                       ["country": "Italy", "countryCode": "it"],
                       ["country": "France", "countryCode": "fr"],
                       ["country": "Netherlands", "countryCode": "nl"],
                       ["country": "Sweden", "countryCode": "se"],
                       ["country": "Denmark", "countryCode": "dk"],
                       ["country": "Finland", "countryCode": "fi"],
                       ["country": "Hungary", "countryCode": "hu"],
                       ["country": "Norway", "countryCode": "no"],
                       ["country": "Portugal", "countryCode": "pl"],
                       ["country": "Russia", "countryCode": "ru"],
                       ["country": "Ukraine", "countryCode": "ua"],
                       ["country": "Switzerland", "countryCode": "ch"],
                       ["country": "Brazil", "countryCode": "br"],
                       ["country": "New Zealand", "countryCode": "nz"],
                       ["country": "Mexico", "countryCode": "mx"],
                       ["country": "Australia", "countryCode": "au"]]
    
    let filterLanguageArray = ["en", "de", "it", "fr", "nl", "sv", "da", "fi", "hu", "no", "pl", "ru", "uk", "pt", "es"]

    //MARK: - Properties
    
    private var country = ""
    private var language = ""
    
    private var filterType: FilterType
    
    //MARK: - Public methods
    
    func numbersOfRows() -> Int {
        
        switch filterType {
        case .country:
            return filterCountryArray.count
        case .language:
            return filterLanguageArray.count
        }
    }
    
    func retriveFilterOptions() {

        switch filterType {
        case .country:
            country = defaults.string(forKey: countryCodeKey)!
        case .language:
            language = defaults.string(forKey: langCodeKey)!
        }
    }
    
    func saveFilterOption(by indexPathRow: Int) {
  
        switch filterType {
        case .country:
            let coutryItem = filterCountryArray[indexPathRow]
            defaults.set(coutryItem[countryCodeKey], forKey: countryCodeKey)
            country = coutryItem[countryCodeKey]!
            
        case .language:
            defaults.set(filterLanguageArray[indexPathRow], forKey: langCodeKey)
            language = filterLanguageArray[indexPathRow]
        }
    }
    
    func checkIfCellSelected(by indexPathRow: Int) -> Bool {

        switch filterType {
        case .country:
            let coutryItem = filterCountryArray[indexPathRow]
            return coutryItem[countryCodeKey] == country
            
        case .language:
            return filterLanguageArray[indexPathRow] == language
        }
    }
    
    func textForCell(at indexPathRow: Int) -> String {
        
        switch filterType {
        case .country:
            let coutryItem = filterCountryArray[indexPathRow]
            return coutryItem["country"]!
            
        case .language:
            return filterLanguageArray[indexPathRow]
        }
    }
    
    //MARK: - Init
    
    init(_ filterType: FilterType) {
        self.filterType = filterType
    }
}
