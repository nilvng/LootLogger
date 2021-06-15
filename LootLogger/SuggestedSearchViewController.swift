//
//  ResultsTableController.swift
//  LootLogger
//
//  Created by Nil Nguyen on 6/13/21.
//

import UIKit

// This protocol helps inform MainTableViewController that a suggested search or product was selected.
protocol SuggestedSearchDelegate: AnyObject {
    // A suggested search was selected; inform our delegate that the selected search token was selected.
    func didSelectSuggestedSearch(token: UISearchToken)
    
    // A product was selected; inform our delgeate that a product was selected to view.
    func didSelectItem(item: Item)
}

class SuggestedSearchViewController: UITableViewController {

    var filteredItems : [Item] = []
    var suggestedSearchDelegate : SuggestedSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of row in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !filteredItems.isEmpty else {
            return 1
        }
        return filteredItems.count
    }
    // style a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell =  tableView.dequeueReusableCell(withIdentifier: ItemsViewController.itemCellIdentifier, for: indexPath) as! ItemCell
        let cell = UITableViewCell(style: .value1, reuseIdentifier:ItemsViewController.itemCellIdentifier)

        // case for No items
        guard !filteredItems.isEmpty else {
            cell.textLabel?.text = "Not found"
            return cell
        }
        
        let item = filteredItems[indexPath.row]
        cell.textLabel?.text = item.name
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let searchDelegate = suggestedSearchDelegate else {
            return
        }
        print("ResultVC: did select row")
        // if a item is selected we will redirect to detail so we should inform mainController about that, which is our searchDelegate
       searchDelegate.didSelectItem(item: filteredItems[indexPath.row])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // redirect to detail page
        if let destinationViewController = segue.destination as? DetailViewController {
            print("ResultVC: prepare")
                destinationViewController.item = filteredItems[tableView.indexPathForSelectedRow!.row]
            }

    }
    

}
