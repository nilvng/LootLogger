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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
                
        navigationItem.backButtonTitle = "Log"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //MARK: Button Actions
    // add button
    @IBAction func addItem(_ sender: UIBarButtonItem){
        let item = itemStore.createItem()

        for sectionNum in 0..<itemStore.items.count{
            if let row = itemStore.items[sectionNum].firstIndex(where: {$0 == item}){
                let index = IndexPath(row: row, section: sectionNum) //TODO: add item at section? done
                tableView.performBatchUpdates({
                    if row == 0{
                        tableView.deleteRows(at: [index], with: .automatic)
                    }
                    tableView.insertRows(at: [index], with: .automatic)

                })
                
                break
            } // if find row
        }
    }
    //MARK: TableDataSource methods
    
    // number of sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemStore.items.count
    }
    
    // number of row in section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard !itemStore.items[section].isEmpty else {
            return 1
        }
        return itemStore.items[section].count
    }
    
    // title for section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "More than $50"
        default:
            return "Others"
        }
    }
    
    // style a row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        // case for No items
        guard !itemStore.items[indexPath.section].isEmpty else {
            cell.nameLabel?.text = "No item!"
            cell.valueLabel?.text = ""
            cell.serialNumberLabel?.text = ""
            cell.selectionStyle = .none
            return cell
        }
        
        let item = itemStore.items[indexPath.section][indexPath.row]
        cell.nameLabel?.text = item.name
        cell.serialNumberLabel?.text = item.serialNumber
        cell.valueLabel?.text = String(format:"%.2f", item.valueDollars)
        return cell
    }
    
    // edit mode disabled for No Items cell
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if itemStore.items[indexPath.section].isEmpty {
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
            let item = itemStore.items[indexPath.section][indexPath.row]
            // remove item from the item store
            itemStore.removeItem(item)
            // remove item's photo from the image store
            imageStore.deleteImage(forKey: item.itemKey)
            
            tableView.performBatchUpdates({
                tableView.deleteRows(at: [indexPath], with: .automatic)
                if indexPath.row == 0{
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }

            }, completion: {_ in print("done add row, delete constant row")})

        }
    }
    // Allow select a row
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if itemStore.items[indexPath.section].isEmpty {
            return nil
        }
        return indexPath
    }
    
    //MARK: Animation
    // passing data to detailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showItem": // identifier name of transition to next view declared in Storyboard
            if let indexPath = tableView.indexPathForSelectedRow{
                let item = itemStore.items[indexPath.section][indexPath.row]
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
    
}
