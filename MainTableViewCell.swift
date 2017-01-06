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
    @IBOutlet weak var starsView: StarsView!
    
    var beer: GBBeer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        starsView.setFrame()
        starsView.editable = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setup() {
        if let rating = beer.rating {
            starsView.set(rating: rating)
        }
        
        beerNameLabel.text = beer.name
        beerNameLabel.sizeToFit()
        
        if let image = beer.image {
            beerImageView.image = image
        } else {
            beerImageView.image = App.icon
        }
    }
}
