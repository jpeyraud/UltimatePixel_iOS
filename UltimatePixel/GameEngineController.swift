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

typealias UpdatePixelUI = (_ withColor: UIColor?, _ score: Int) -> Void
typealias UpdateTargetUI = (_ withColor: UIColor) -> Void

class GameEngineController {
    
    let itemPerLine: Int
    let line: Int
    fileprivate var score: Int
    fileprivate var time: Int
    fileprivate let colors: UInt32
    fileprivate var target: PixelColor
    fileprivate let targetChangeRatePerCent: UInt32
    fileprivate var pixels: [PixelColor]

    init() {
        itemPerLine = 4
        line = 5
        score = 0
        time = 0
        colors = 3
        target = .white
        targetChangeRatePerCent = 30
        pixels = Array(repeating: PixelColor.white, count: itemPerLine*line)
    }
    
    fileprivate func createPixel() -> PixelColor {
        return PixelColor(rawValue: arc4random_uniform(colors))!
    }
    
    fileprivate func createPixelDifferentFromTarget() -> PixelColor {
        var randomPixel = PixelColor(rawValue: arc4random_uniform(colors))
        while randomPixel == target {
            randomPixel = PixelColor(rawValue: arc4random_uniform(colors))
        }
        return randomPixel!
    }
    
    // create a random pixel color which is in the pixel list
    fileprivate func createExistingPixel() -> PixelColor {
        var newPixel = createPixel()
        while !pixels.contains(newPixel) {
            newPixel = createPixel()
        }
        return newPixel
    }
    
    fileprivate func convertToUIColor(_ pixelColor: PixelColor) -> UIColor {
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
    
    //************************ Public API ************************//
    
    func newPixel(_ atIndex: Int) -> UIColor {
        let newPixel: PixelColor = self.createPixelDifferentFromTarget()
        pixels[atIndex] = newPixel
        return convertToUIColor(newPixel)
    }
    
    func intentToChangeTarget(updateTargetUI: UpdateTargetUI) {
        guard arc4random_uniform(100)+1 <= targetChangeRatePerCent || !pixels.contains(target) else {
            return
        }
        target = createExistingPixel()
        updateTargetUI(convertToUIColor(target))
    }
    
    func initTarget(updateTargetUI: UpdateTargetUI) {
        target = createExistingPixel()
        updateTargetUI(convertToUIColor(target))
    }
    
    func didSelectPixel(_ atIndex: Int, updatePixelUI: UpdatePixelUI) -> Bool {
        guard pixels[atIndex] == target else {
            score -= 1
            updatePixelUI(nil, score)
            return false
        }
        score += 1
        updatePixelUI(newPixel(atIndex), score)
        return true
    }
}
