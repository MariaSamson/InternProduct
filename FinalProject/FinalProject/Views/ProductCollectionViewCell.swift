//
//  ProductCollectionViewCell.swift
//  FinalProject
//
//  Created by Maria Andreea on 17.03.2022.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell{

    @IBOutlet weak var collectionImage: UIImageView!
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var collectionDescription: UILabel!
    @IBOutlet weak var tagsCollection: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
