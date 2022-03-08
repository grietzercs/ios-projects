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
    
    var labelText = ""
    
    func configure(with categoryChoice: String, with image: UIImage, with index: Int) {
        self.tag = index
        selectionButton.tag = index
        recentOrdersLabel.text = categoryChoice
        categoryImage.image = image
        labelText = categoryChoice
    }
    
//    class func getLabel() -> String {
//        let test = labelTex
//        return test
//    }
    
    
}
