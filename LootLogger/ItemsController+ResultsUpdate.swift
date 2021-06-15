//
//  ItemsController+ResultsUpdate.swift
//  LootLogger
//
//  Created by Nil Nguyen on 6/13/21.
//

import UIKit

extension ItemsViewController : UISearchResultsUpdating{
    // Called with the search bar is tapped (become first responder) or text has changed
    func updateSearchResults(for searchController: UISearchController) {
        
        // Preprocess user input
        ///strip out leading and trailing spaces
        let whitespaceCharSet = CharacterSet.whitespaces
        let trimmedInput = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharSet)
        /// break input string by space
        let searchKeywords = trimmedInput.components(separatedBy: " ") as[String]
        /// apply the processed input to filter out the item
        var filtered = itemStore.items
        var curStr = searchKeywords[0]
        var idx = 0
        while curStr != "" {
            filtered = filtered.filter{
                $0.name.lowercased().contains(curStr)}
            idx += 1
            curStr = (idx < searchKeywords.count) ? searchKeywords[idx] : ""
        }
        // Search based on search token
        if !searchController.searchBar.searchTextField.tokens.isEmpty{
            print("search based on token")
        }
        
        // Apply the filter results to the result table
        if let resultController = searchController.searchResultsController as? SuggestedSearchViewController{
            resultController.filteredItems = filtered
            resultController.tableView.reloadData()
        }
    }
}
