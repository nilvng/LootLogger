//
//  ItemStore.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/18/21.
//

import UIKit

class ItemStore {
    var items : [[Item]] = [[], []]
    let itemArchiveURL : URL = {
        
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent("items.plist")
    }()
        
    @objc func saveChanges() -> Bool {
        do {
            let encoder = PropertyListEncoder()

            let data = try encoder.encode(items)
            try data.write(to: itemArchiveURL, options: [.atomic])
            print("Saved all items")
            return true

        } catch let encodingError { // explicit error name
            print("Error coding item \(encodingError)")
            return false
        }
    }
    
    init() {
        // retrieve saved data
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([[Item]].self, from: data)
            self.items = items
        } catch {
            print("Error in retrieve data: \(error)")
        }
        // observe for scene sent to the background (app is closed) to save data
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        // create random item and put it into 2 categories for 2 table sections: >$50 or other
        let item = Item(random: true)
        var section = 0
        switch item.valueDollars {
        case 0..<50:
            section = 1
        default:
            section = 0
        }
        items[section].append(item)
        return item
    }
    
    func removeItem(_ item: Item){
        for section in 0..<items.count{
            if let row = items[section].firstIndex(where: {$0 == item}){
                items[section].remove(at: row)
                break
            }
        }
    }
    
    func moveItem(fromIndex: IndexPath, toIndex: IndexPath){
        if fromIndex == toIndex {
            return
        }
        let movedItem = items[fromIndex.section][fromIndex.row]
        items[fromIndex.section].remove(at: fromIndex.row)
        items[toIndex.section].insert(movedItem, at: toIndex.row)
    }
    
    
}
