//
//  GameEngineController.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 30/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

enum PixelColor: UInt32 {
    case white = 255
    case red = 0
    case green = 1
    case blue = 2
}

typealias UpdatePixelUI = (_ withColor: UIColor?, _ score: Int) -> Void
typealias UpdateTargetUI = (_ withColor: UIColor) -> Void

class GameEngineController {
    
    var started: Bool
    var ended: Bool
    var itemPerLine: Int
    var line: Int
    let timerInterval: Double
    var time: Double
    fileprivate var timer: Timer?
    fileprivate var score: Int
    fileprivate let colors: UInt32
    fileprivate var target: PixelColor
    fileprivate let targetChangeRatePerCent: UInt32
    fileprivate var pixels: [PixelColor]
    fileprivate var updateTimerUI: ()->()

    init() {
        started = false
        ended = false
        itemPerLine = 5  // small 3x3, medium 4x5, big 5x7
        line = 7
        timerInterval = 0.1
        time = 20.0
        score = 0
        colors = 3
        target = .white
        targetChangeRatePerCent = 30
        pixels = Array(repeating: PixelColor.white, count: itemPerLine*line)
        updateTimerUI = {}
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
            return UIColor.redPixel
        case .green:
            return UIColor.greenPixel
        case .blue:
            return UIColor.bluePixel
        default:
            return UIColor.white
        }
    }
    
    //************************ Public API ************************//
    
    func startGame(_ updateTimer: @escaping () -> ()) {
        updateTimerUI = updateTimer
        timer = Timer.scheduledTimer(timeInterval: timerInterval,
                                     target: self,
                                     selector: #selector(updateTimerSelector),
                                     userInfo: nil,
                                     repeats: true)
        started = true
    }
    
    @objc func updateTimerSelector() {
        updateTimerUI()
    }
    
    func stopGame() {
        timer?.invalidate()
        ended = true
    }
    
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
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            time -= 1.0
            return false
        }
        time += 0.25
        score += 1
        updatePixelUI(newPixel(atIndex), score)
        return true
    }
}

extension UIColor {
    open static var redPixel: UIColor {
        get{ return UIColor(red: 0.8, green: 0.15, blue: 0.15, alpha: 1.0)}
    }
    open static var greenPixel: UIColor {
        get{ return UIColor(red: 0.12, green: 0.8, blue: 0.12, alpha: 1.0)}
    }
    open static var bluePixel: UIColor {
        get{ return UIColor(red: 0.12, green: 0.12, blue: 0.9, alpha: 1.0)}
    }
}
