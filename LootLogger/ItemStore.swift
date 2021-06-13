//
//  ItemStore.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/18/21.
//

import UIKit

class ItemStore {
    var items = [Item]()
    let itemArchiveURL : URL = {
        
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent("items.plist")
    }()

        
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL)")
        
        do{
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(items)
            try data.write(to: itemArchiveURL)
            print("Saved all items")
            return true
        } catch let encodingError{
            print("Error encoding items: \(encodingError)")
            return false
        }
    }
    
    init() {
        // retrieve saved data
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            self.items = items
            
        } catch let error {
            print("Error reading in save file: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        // auto save the list of items whenever users turn off the app
        notificationCenter.addObserver(self,
                                       selector:#selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    @discardableResult func createItem() -> Item {
        // create random item and put it into 2 categories for 2 table sections: >$50 or other
        let item = Item(random: true)
        items.append(item)
        return item
    }
    
    func removeItem(_ item: Item){
        if let row = items.firstIndex(where: {$0 == item}){
            items.remove(at: row)
        }
    }
    
    func moveItem(fromIndex: IndexPath, toIndex: IndexPath){
        if fromIndex == toIndex {
            return
        }
        let movedItem = items[fromIndex.row]
        items.remove(at: fromIndex.row)
        items.insert(movedItem, at: toIndex.row)
    }
    
    
}

