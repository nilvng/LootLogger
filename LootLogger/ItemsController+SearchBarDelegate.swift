//
//  ItemController+SearchBarDelegate.swift
//  LootLogger
//
//  Created by Nil Nguyen on 6/13/21.
//

import UIKit
// MARK: - UISearchBarDelegate

extension ItemsViewController: UISearchBarDelegate {
    func setToSuggestedSearches(){
        // We are no longer interested in cell navigating, since we are now showing the suggested searches.
        resultsTableController.tableView.delegate = resultsTableController
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text!.isEmpty {
            // Text is empty, show suggested searches again.
            setToSuggestedSearches()
        } else {
//            resultsTableController.showSuggestedSearches = false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /* User tapped the Done button in the keyboard. */
        // MARK: Bug! should direct to result table
        searchController.dismiss(animated: true, completion: nil)
        searchBar.text = ""
    }

}
