//
//  ProductTableViewCell.swift
//  FinalProject
//
//  Created by Maria Andreea on 11.03.2022.
//

import UIKit

class ProductTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productTag: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
