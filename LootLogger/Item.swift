//
//  Item.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/18/21.
//

import UIKit

class Item : Equatable, Codable{
    static func == (lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name &&
            lhs.serialNumber == rhs.serialNumber &&
            lhs.dateCreated == rhs.dateCreated &&
            lhs.valueDollars == rhs.valueDollars
    }
    
    var name : String
    var valueDollars : Double
    var serialNumber : String?
    var dateCreated : Date
    
    init(name : String, value : Double, serialNumber : String?) {
        self.name = name
        self.valueDollars = value
        self.serialNumber = serialNumber
        self.dateCreated = Date()
    }
    
    convenience init(random : Bool = false) {
        if random{
            let names = ["Valk 3M Angtrom", "Bell Pyraminx", "Qiyi Skewb"]
            let randomName = names.randomElement()!
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            let randomValue = Double.random(in: 0..<100)
            
            self.init(name: randomName, value: randomValue, serialNumber: randomSerialNumber)
        } else {
            self.init(name: "", value: 0, serialNumber: nil)
        }
    }
}
