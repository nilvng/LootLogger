//
//  ItemStore.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/18/21.
//

import UIKit

class ItemStore {
    var items : [[Item]] = [[], []]
        
    @discardableResult func createItem() -> Item {
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
