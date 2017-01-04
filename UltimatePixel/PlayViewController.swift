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
        cell?.layer.borderColor = UIColor.black.cgColor
        
        let rightPixel = gameEngine.didSelectPixel(indexPath.item) {
            if $0 != nil {
                cell?.backgroundColor = $0
            }
            playHeader?.score.text = "\($1)"
        }
        if rightPixel {
            gameEngine.intentToChangeTarget() { playHeader?.target.backgroundColor = $0 }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.layer.shadowOpacity = 1.0
        collectionView.cellForItem(at: indexPath)?.layer.borderColor = UIColor.darkGray.cgColor
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








