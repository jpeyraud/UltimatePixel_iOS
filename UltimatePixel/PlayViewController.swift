//
//  PlayViewController.swift
//  UltimatePixel
//
//  Created by JeremyX Peyraud on 28/12/2016.
//  Copyright © 2016 Altarrys. All rights reserved.
//

import UIKit

class PlayViewController: UICollectionViewController {
    
    var gameEngine: GameEngineController = GameEngineController()

    fileprivate weak var playHeader: PlayHeader?
    
    // MARK: - Properties
    fileprivate let reuseCellIdentifier = "PixelCell"
    fileprivate let reuseHeaderIdentifier = "PlayHeader"
    fileprivate let minItemSpacing: CGFloat = 5
    fileprivate let minLineSpacing: CGFloat = 5
    fileprivate let contentInset: UIEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    fileprivate var optimalItemSize: Int = 0

    // MARK: - Actions
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flow: UICollectionViewFlowLayout = self.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = minItemSpacing
        flow.minimumLineSpacing = minLineSpacing
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let screenWidth: Int = Int(UIScreen.main.bounds.width)
        let availableScreenWidth: Int = screenWidth - (gameEngine.itemPerLine-1) * Int(minItemSpacing) - Int(contentInset.left) - Int(contentInset.right)
        optimalItemSize = availableScreenWidth / gameEngine.itemPerLine
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameEngine.stopGame()
    }
    
    func startGameEngine() {
        gameEngine.startGame { [weak self] in
            if let timeInterval = self?.gameEngine.timerInterval {
                self?.gameEngine.time -= timeInterval
            }
            
            if let time = self?.gameEngine.time {
                var formatedTime = round(time*10.0)/10.0
                self?.gameEngine.time = formatedTime
                
                if formatedTime <= 0.0 {
                    formatedTime = 0.0
                    self?.playHeader?.time.borderColor = UIColor.red
                    self?.gameEngine.stopGame()
                }
                
                self?.playHeader?.time.text = "\(formatedTime)"
            }
        }
        playHeader?.targetLabel.alpha = 0.0
        playHeader?.instructionLabel.alpha = 0.0
    }
    
    func handlePlayerTouch(at: IndexPath, onCell: UICollectionViewCell?) {
        let rightPixel = gameEngine.didSelectPixel(at.item) {
            if let bg = $0 {
                onCell?.backgroundColor = bg
            }
            playHeader?.score.text = "\($1)"
        }
        
        if rightPixel {
            gameEngine.intentToChangeTarget() { playHeader?.target.backgroundColor = $0 }
        }
        else {
            wrongTarget(true)
        }
    }
    
    func wrongTarget(_ wrong: Bool) {
        if wrong {
            //playHeader?.backgroundColor = UIColor.red
            //if playHeader?.target.backgroundColor != UIColor.red {
                playHeader?.target.borderColor = UIColor.red
            playHeader?.target.borderWidth = 3
            /*}
            else {
                playHeader?.target.borderColor = UIColor.red
            }*/
        }
        else {
            playHeader?.target.borderColor = UIColor.darkGray
            playHeader?.target.borderWidth = 0
            //playHeader?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        }
        
    }
}

// MARK: - UICollectionViewDataSource
extension PlayViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameEngine.itemPerLine * gameEngine.line
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = gameEngine.newPixel(indexPath.item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableHeaderView: UICollectionReusableView
        reusableHeaderView = collectionView.dequeueReusableSupplementaryView(
                                                            ofKind: kind,
                                                            withReuseIdentifier: reuseHeaderIdentifier,
                                                            for: indexPath)
        playHeader = reusableHeaderView as? PlayHeader
        gameEngine.initTarget { playHeader?.target.backgroundColor = $0 }
        return reusableHeaderView;
    }
}

// MARK: - UICollectionViewDelegate
extension PlayViewController {
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.shadowOpacity = 0.0
        cell?.layer.borderWidth = 1
        
        if !gameEngine.started {
            startGameEngine()
        }
        
        if !gameEngine.ended {
            handlePlayerTouch(at: indexPath, onCell: cell)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.shadowOpacity = 1.0
        cell?.layer.borderWidth = 0
        
        wrongTarget(false)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlayViewController: UICollectionViewDelegateFlowLayout{

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: optimalItemSize, height: optimalItemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return contentInset
    }
}








