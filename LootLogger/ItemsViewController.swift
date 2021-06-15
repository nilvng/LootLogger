//
//  ItemsViewController.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/18/21.
//

import UIKit

class ItemsViewController : UITableViewController{
    
    //MARK: Properties
    var itemStore : ItemStore!
    var imageStore : ImageStore!
    static var itemCellIdentifier = "ItemCell"
    
    var searchController : UISearchController!
    var resultsTableController : SuggestedSearchViewController!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
                
        navigationItem.backButtonTitle = "Log"
        
        // Insert Search bar
        resultsTableController = SuggestedSearchViewController()
        resultsTableController.suggestedSearchDelegate = self // So we can be notified when a suggested search token is selected.
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("Enter a search term", comment: "")
        searchController.searchBar.returnKeyType = .done

        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
            
        // Make the search bar always visible.
        navigationItem.hidesSearchBarWhenScrolling = false
     
        // Monitor when the search controller is presented and dismissed.
        searchController.delegate = self

        // Monitor when the search button is tapped, and start/end editing.
        searchController.searchBar.delegate = self
        
        /** Specify that this view controller determines how the search controller is presented.
            The search controller should be presented modally and match the physical size of this view controller.
        */
        definesPresentationContext = true
    }

    // passing data to detailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem": // identifier name of transition to next view declared in Storyboard
            if let indexPath = tableView.indexPathForSelectedRow{
                let item = itemStore.items[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    // update the table as an item may get updated from their detail page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    //MARK: Button Actions
    // add button
    @IBAction func addItem(_ sender: UIBarButtonItem){
        let item = itemStore.createItem()

        for sectionNum in 0..<itemStore.items.count{
            if let row = itemStore.items.firstIndex(where: {$0 == item}){
                let index = IndexPath(row: row, section: sectionNum) //TODO: add item at section? done
                tableView.performBatchUpdates({
                    if row == 0{
                        tableView.deleteRows(at: [index], with: .automatic) // delete row "No Item", which is not in the itemStore so the target row is still 0
                    }
                    tableView.insertRows(at: [index], with: .automatic)

                })
                
                break
            } // if find row
        }
    }
    //MARK: TableDataSource
    
    // number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // number of row in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !itemStore.items.isEmpty else {
            return 1
        }
        return itemStore.items.count
    }
    // style a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: ItemsViewController.itemCellIdentifier, for: indexPath) as! ItemCell
        
        // case for No items
        guard !itemStore.items.isEmpty else {
            cell.nameLabel?.text = "No item!"
            cell.valueLabel?.text = ""
            cell.serialNumberLabel?.text = ""
            cell.selectionStyle = .none
            return cell
        }
        
        let item = itemStore.items[indexPath.row]
        cell.nameLabel?.text = item.name
        cell.serialNumberLabel?.text = item.serialNumber
        cell.valueLabel?.text = String(format:"%.2f", item.valueDollars)
        return cell
    }
    
    // edit mode disabled for No Items cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if itemStore.items.isEmpty {
            return false
        }
        return true
    }

    // Reorder items of the table
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItem(fromIndex: sourceIndexPath, toIndex: destinationIndexPath)
    }
    // delete item
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let item = itemStore.items[indexPath.row]
            // remove item from the item store
            itemStore.removeItem(item)
            // remove item's photo from the image store
            imageStore.deleteImage(forKey: item.itemKey)
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if indexPath.row == 0{
                    tableView.insertRows(at: [indexPath], with: .automatic) // insert "No item" row for displaying
                }

            }, completion: {_ in print("done add row, delete constant row")})

        }
    }
    // Allow select a row
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if itemStore.items.isEmpty {
            return nil
        }
        return indexPath
    }
    
}

