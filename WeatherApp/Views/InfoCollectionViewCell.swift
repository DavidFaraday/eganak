//
//  InfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by David Kababyan on 24/12/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weatherInfo: WeatherInfo) {
        
        infoLabel.text = weatherInfo.infoText
        infoLabel.adjustsFontSizeToFitWidth = true

        if weatherInfo.image != nil {
            nameLabel.isHidden = true
            infoImageView.isHidden = false
            infoImageView.image = weatherInfo.image
        } else {
            nameLabel.isHidden = false
            nameLabel.adjustsFontSizeToFitWidth = true
            infoImageView.isHidden = true
            nameLabel.text = weatherInfo.nameText
        }
    }

}
