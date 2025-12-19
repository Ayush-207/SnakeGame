//
//  SnakeGameVC+CV.swift
//  MeeshoPractice
//
//  Created by Ayush Goyal on 19/12/25.
//
import Foundation
import UIKit

extension SnakeGameVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.maxColumns
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = viewModel.getCellData(for: indexPath),
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SnakeGameCell.reuseIdentifier, for: indexPath) as? SnakeGameCell else { return UICollectionViewCell() }
        
        cell.update(with: data)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel.maxRows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.getCellSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 3, left: 0, bottom: 0, right: 0)
    }
}

class SnakeGameCell: UICollectionViewCell {
    
    func update(with data: SnakeGameCellData) {
        self.contentView.backgroundColor = data.cellType.color
    }
}

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
