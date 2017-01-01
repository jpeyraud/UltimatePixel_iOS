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
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK: - Actions
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// UICollectionViewDataSource
extension PlayViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameEngine.cols * gameEngine.rows
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseCellIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = gameEngine.newUIPixel(indexPath.item)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableHeaderView: UICollectionReusableView
        reusableHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: reuseHeaderIdentifier,
                                                                             for: indexPath)
        playHeader = reusableHeaderView as? PlayHeader
        gameEngine.initTarget {
            _ , withColor in
            playHeader?.target.backgroundColor = withColor
        }
        return reusableHeaderView;
    }
    
}

// UICollectionViewDelegate
extension PlayViewController {
    override func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let matchTarget: Bool = gameEngine.didSelectPixel(indexPath.item) {
            atIndex, withColor in
            collectionView.cellForItem(at: indexPath)?.backgroundColor = withColor
        }
        guard matchTarget else {
            return
        }
        gameEngine.intentToChangeTarget() {
            _ , withColor in
            playHeader?.target.backgroundColor = withColor
        }
        //collectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.gray
    }
    
    override func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        //collectionView.cellForItem(at: indexPath)?.backgroundColor =
    }
}








