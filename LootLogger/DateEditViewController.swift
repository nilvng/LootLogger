//
//  DateEditViewController.swift
//  LootLogger
//
//  Created by Nil Nguyen on 2/26/21.
//

import UIKit

class DateEditViewController: UIViewController {

    var item : Item!
    
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var dateLabel: UILabel!
    
    var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    @IBAction
    func chooseDate(_ sender: UIDatePicker) {
        let strDate = dateFormatter.string(from: sender.date)
        dateLabel.text = strDate
        item.dateCreated = sender.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker.date = item.dateCreated
        
    }
    

}
