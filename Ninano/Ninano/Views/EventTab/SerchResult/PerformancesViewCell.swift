//
//  PerformancesViewCell.swift
//  Ninano
//
//  Created by 이가은 on 2022/07/16.
//

import UIKit

final class PerformancesViewCell: UICollectionViewCell {
    
    @IBOutlet var performanceImage: UIImageView!
    
    var imageName: String = "" {
        didSet {
            performanceImage.layer.cornerRadius = 10
            performanceImage.contentMode = .scaleAspectFill
            self.performanceImage.image = UIImage(named: imageName)
        }
    }
//    private var isHeartedSelected = false
//    @IBAction func clickedHeart(_ sender: UIButton) {
//        if isHeartedSelected {
//            let config = UIImage.SymbolConfiguration(paletteColors: [.systemGray5, .systemGray, .darkGray])
//            let image = UIImage(systemName: "heart.circle.fill", withConfiguration: config)
//            sender.setImage(image, for: .normal)
//            isHeartedSelected = false
//        } else {
//            let config = UIImage.SymbolConfiguration(paletteColors: [.red, .systemGray, .darkGray])
//            let image = UIImage(systemName: "heart.circle.fill", withConfiguration: config)
//            sender.setImage(image, for: .normal)
//            isHeartedSelected = true
//        }
//    }
    
}
