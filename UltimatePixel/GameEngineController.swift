//
//  GameEngineController.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 30/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import Foundation
import UIKit

enum PixelColor: UInt32 {
    case white = 255
    case red = 0
    case green = 1
    case blue = 2
}

typealias UpdateUIPixel = (_ atIndex: Int, _ withColor: UIColor) -> Void

class GameEngineController {
    
    let rows: Int
    let cols: Int
    let colors: UInt32
    var target: PixelColor
    fileprivate let targetChangeRatePerCent: UInt32
    fileprivate var pixels: [PixelColor]

    init() {
        rows = 6
        cols = 6
        colors = 3
        target = .white
        targetChangeRatePerCent = 25
        pixels = Array(repeating: PixelColor.white, count: rows*cols)
    }
    
    func newPixel() -> PixelColor {
        return PixelColor(rawValue: arc4random_uniform(colors))!
    }
    
    func newUIPixel(_ atIndex: Int) -> UIColor {
        let newPixel: PixelColor = self.newPixel()
        pixels[atIndex] = newPixel
        return convertToUIColor(newPixel)
    }
    
    func intentToChangeTarget(updateUIPixel: UpdateUIPixel) {
        guard (arc4random_uniform(100)+1 <= targetChangeRatePerCent) else {
            return
        }
        target = newPixel()
        updateUIPixel(-1, convertToUIColor(target))
    }
    
    func initTarget(updateUIPixel: UpdateUIPixel) {
        target = newPixel()
        updateUIPixel(-1, convertToUIColor(target))
    }
    
    func convertToUIColor(_ pixelColor: PixelColor) -> UIColor {
        switch pixelColor {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .blue:
            return UIColor.blue
        default:
            return UIColor.white
        }
    }
    
    func didSelectPixel(_ atIndex: Int, updateUIPixel: UpdateUIPixel) -> Bool {
        guard pixels[atIndex] == target else {
            return false
        }
        
        let newPixel = self.newPixel()
        pixels[atIndex] = newPixel
        updateUIPixel(atIndex, convertToUIColor(newPixel))
        return true
    }
}
