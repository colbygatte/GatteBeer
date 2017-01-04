//
//  MainTableViewCell.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/3/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerRatingLabel: UILabel!
    
    var beer: GBBeer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    
    func setup() {
        if let rating = beer.rating {
            beerRatingLabel.text = "Rating: " + String(rating + 1)
            beerRatingLabel.sizeToFit()
        }
        
        beerNameLabel.text = beer.name
        beerNameLabel.sizeToFit()
        
        if let image = beer.image {
            beerImageView.image = beer.image
        } else {
            beerImageView.image = App.icon
        }
    }
}
