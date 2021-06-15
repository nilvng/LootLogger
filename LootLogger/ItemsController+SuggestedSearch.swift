//
//  ItemsController+SuggestedSearch.swift
//  LootLogger
//
//  Created by Nil Nguyen on 6/14/21.
//

import UIKit

extension ItemsViewController : SuggestedSearchDelegate{
    func didSelectSuggestedSearch(token: UISearchToken) {
        
    }
    
    func didSelectItem(item: Item) {
        // set up detail view controller to show
        //print("ItemsVC: push view")
        let detailViewController = DetailViewController.detailViewControllerForItem(item, imageStore: imageStore)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
}
