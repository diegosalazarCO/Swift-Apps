//
//  History.swift
//  SmashTag
//
//  Created by Diego Salazar on 8/31/15.
//  Copyright (c) 2015 Diego Salazar. All rights reserved.
//

import Foundation

class RecentSearches {
    fileprivate struct Const {
        static let ValuesKey = "RecentSearches.Values"
        static let NumberOfSearches = 100
    }
    
    func add(_ search: String) {
        var currentSearches = values
        if let index = currentSearches.index(of: search) {
            currentSearches.remove(at: index)
        }
        currentSearches.insert(search, at: 0)
        while currentSearches.count > Const.NumberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
    
    fileprivate let defaults = UserDefaults.standard
    var values: [String] {
        get { return defaults.object(forKey: Const.ValuesKey) as? [String] ?? [] }
        set { defaults.set(newValue, forKey: Const.ValuesKey) }
    }
    
    func removeAtIndex(_ index: Int) {
        var currentSearches = values
        currentSearches.remove(at: index)
        values = currentSearches
    }
}
