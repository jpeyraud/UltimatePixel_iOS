//
//  PlayHeader.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 01/01/2017.
//  Copyright © 2017 Altarrys. All rights reserved.
//

import Foundation
import UIKit

class PlayHeader: UICollectionReusableView {
    @IBOutlet weak var target: HeaderButton!
    @IBOutlet weak var time: HeaderLabel!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var score: HeaderLabel!
    
    private let gradientLayer = CAGradientLayer()
    
    @IBInspectable var color1: UIColor = UIColor.clear { didSet { updateColors() } }
    @IBInspectable var color2: UIColor = UIColor.clear  { didSet { updateColors() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGradient()
    }
    
    func configureGradient() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        updateColors()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        clipsToBounds = true
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0);
        layer.shadowRadius = 3.0;
        layer.shadowOpacity = 1.0;
        layer.masksToBounds = false;
    }
    
    private func updateColors() {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
}
