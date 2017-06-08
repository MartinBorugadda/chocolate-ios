//
//  DistanceTimeCell.swift
//  Chocolate
//
//  Created by AT on 11/27/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit

class DistanceTimeCell: UITableViewCell {

    @IBOutlet weak var RemainingTime: UILabel!
    @IBOutlet weak var RemainingDistance: UILabel!
    @IBOutlet weak var CurrentSpeed: UILabel!
    
    func updateLabels() {
        _ = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
    }
    
}
