//
//  CitiesCell.swift
//  WeatherApp
//
//  Created by Melih Yuvacı on 30.04.2023.
//

import UIKit

class CitiesCell: UITableViewCell {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
