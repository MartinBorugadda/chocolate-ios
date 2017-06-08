//
//  DestinationInfoCell.swift
//  Chocolate
//
//  Created by AT on 11/27/16.
//  Copyright © 2016 Marnit. All rights reserved.
//

import UIKit

class WeatherInfoCell: UITableViewCell {

    @IBOutlet weak var CityName: UILabel!
    @IBOutlet weak var Temperature: UILabel!
    @IBOutlet weak var WeatherType: UILabel!
    
    func setTemperature(inTemperature:String){
        Temperature.text = inTemperature
    }
    
    var weatherGetter = WeatherGetter()
    
    @IBAction func refreshClick(_ sender: UIButton) {
        print(weatherGetter.getWeatherForCity(cityName: "syracuse"))
    }
    func updateLabels() {
        _ = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

   
}
