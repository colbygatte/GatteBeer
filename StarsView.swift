//
//  StarsView.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/3/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

class StarsView: UIView {
    @IBOutlet weak var starsView: UIView!
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var imageViews: [UIImageView]!
    var rating: Int!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("StarsView", owner: self, options: nil)
        starsView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        addSubview(starsView)
        imageViews = [star1ImageView, star2ImageView, star3ImageView, star4ImageView, star5ImageView]
        
        for imageView in imageViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
            imageView.addGestureRecognizer(tap)
            print("yeah")
        }
        
        rating = 0
    }
    
    func tapped(recognizer: UITapGestureRecognizer) {
        
        if let imageView = recognizer.view as? UIImageView {
            switch imageView {
            case star1ImageView:
                set(rating: 1)
                break
            case star2ImageView:
                set(rating: 2)
            case star3ImageView:
                set(rating: 3)
                break
            case star4ImageView:
                set(rating: 4)
                break
            case star5ImageView:
                set(rating: 5)
                break
            default:
                print("error")
            }
        }
    }
    
    func set(rating: Int) {
        self.rating = rating
        for i in 0...4 {
            if rating > i {
                imageViews[i].image = App.starRed
            } else {
                imageViews[i].image = App.starGray
            }
        }
    }
}
