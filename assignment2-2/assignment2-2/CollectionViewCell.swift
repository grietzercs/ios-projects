//
//  CollectionViewCell.swift
//  assignment2-2
//
//  Created by Colden on 3/6/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var recentOrdersLabel: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    @IBOutlet weak var selectionButton: UIButton!
    
    func configure(with categoryChoice: String, with image: UIImage) {
        if (categoryChoice == "Cart") {
            self.selectionButton.tag = 1
        }
        if (categoryChoice == "Recent Orders") {
            self.selectionButton.tag = 2
        }
        else {
            self.selectionButton.tag = 0
        }
        recentOrdersLabel.text = categoryChoice
        categoryImage.image = image
    }
    
    
}
