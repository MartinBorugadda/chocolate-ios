//
//  YelpItemCell.swift
//  YelpApiProject
//
//  Created by AT on 12/2/16.
//  Copyright © 2016 Martin. All rights reserved.
//

import UIKit

class PlaceItemCell: UITableViewCell {
    
    @IBOutlet weak var PlaceName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
