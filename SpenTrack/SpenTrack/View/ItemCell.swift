//
//  ItemCell.swift
//  SpenTrack
//
//  Created by Kendrew Chan on 3/3/18.
//  Copyright © 2018 KCStudios. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var cellDate: UILabel!
    @IBOutlet weak var cellCost: UILabel!
    @IBOutlet weak var spentTextLabel: UILabel!
        
    func configureCell(item: Item) {

//        cellDate.text = item.edited
        cellCost.text = "$" + String(format: "%.2f", item.dailySpending)
        cellCost.font = UIFont.boldSystemFont(ofSize: 20)
        spentTextLabel.text = item.spentText
        
        
    }
    
}
