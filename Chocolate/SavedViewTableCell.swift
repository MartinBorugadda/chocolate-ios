//
//  SavedViewTableCell.swift
//  Chocolate
//
//  Created by AT on 12/6/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit

class SavedViewTableCell: UITableViewCell {
    
    @IBOutlet weak var NameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
