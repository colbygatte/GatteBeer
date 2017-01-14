//
//  SortView.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/7/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

protocol SortViewDelegate {
    func sortOptions(sort: GBSortOptions)
}

class SortView: UIView {
    @IBOutlet weak var best: UIImageView!
    @IBOutlet weak var worst: UIImageView!
    @IBOutlet weak var newest: UIImageView!
    @IBOutlet weak var oldest: UIImageView!
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    var delegate: SortViewDelegate?
    var imageViews: [UIImageView]!

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    func setup() {
        Bundle.main.loadNibNamed("SortView", owner: self, options: nil)
        
        addSubview(alphaView)
        addSubview(sortView)
        bringSubview(toFront: sortView)
        
        imageViews = [best, worst, newest, oldest]
        for imageView in imageViews {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
            imageView.addGestureRecognizer(tap)
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(resign(recognizer:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(resign(recognizer:)))
        topView.addGestureRecognizer(tap1)
        bottomView.addGestureRecognizer(tap2)
    }
    
    func setFrame() {
        sortView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        alphaView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func tapped(recognizer: UITapGestureRecognizer) {
        if let imageView = recognizer.view as? UIImageView {
            let sort = GBSortOptions(rawValue: imageView.restorationIdentifier!)
            delegate?.sortOptions(sort: sort!)
        }
        removeFromSuperview()
    }
    
    func resign(recognizer: UITapGestureRecognizer) {
        removeFromSuperview()
    }
    
    override func removeFromSuperview() {
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.alpha = 0.0
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
            super.removeFromSuperview()
        })
    }
}
