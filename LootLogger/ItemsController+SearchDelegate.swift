//
//  ItemsController+SearchDelegate.swift
//  LootLogger
//
//  Created by Nil Nguyen on 6/13/21.
//

import UIKit
// Use these delegate functions for additional control over the search controller.

extension ItemsViewController: UISearchControllerDelegate {
    
    // We are being asked to present the search controller, so from the start - show suggested searches.
    func presentSearchController(_ searchController: UISearchController) {
        searchController.showsSearchResultsController = true
        setToSuggestedSearches()
    }
}
