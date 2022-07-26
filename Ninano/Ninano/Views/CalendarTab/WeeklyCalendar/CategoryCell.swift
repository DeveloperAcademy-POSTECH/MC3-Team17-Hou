//
//  CategoryCell.swift
//  Ninano
//
//  Created by Eunbee Kang on 2022/07/17.
//

import UIKit

class CategoryCell: UITableViewCell {
    var viewModels: [SearchEventCellViewModel] = [] {
        // MARK: fetchTopStories()에서 viewModels를 가져오는데 시간이 걸리므로 가져온 후 eventCollectionView를 reload 함.
        didSet {
            eventCollectionView.reloadData()
        }
    }
    @IBOutlet weak var categoryName: UIButton!
    @IBOutlet weak var categoryChevron: UIButton!
    @IBOutlet weak var eventCollectionView: UICollectionView!
}

extension CategoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "eventCell", for: indexPath) as? EventCell else {
            return UICollectionViewCell()
        }
        cell.contentView.layer.cornerRadius = 10
        cell.configure(with: viewModels[indexPath.row])
        
        return cell
    }
}
