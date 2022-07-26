//
//  EventCell.swift
//  Ninano
//
//  Created by Eunbee Kang on 2022/07/17.
//

import UIKit

class SearchEventCellViewModel {
    let imageURL: URL?
    var imageData: Data?

    init(
        imageURL: URL?
    ) {
        self.imageURL = imageURL
    }
}

class EventCell: UICollectionViewCell {
    @IBOutlet weak var posterImage: UIImageView!
    
    func configure(with viewModel: SearchEventCellViewModel) {
        if let data = viewModel.imageData {
            posterImage.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            // fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.posterImage.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
