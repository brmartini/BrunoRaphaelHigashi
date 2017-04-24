//
//  ProductTableViewCell.swift
//  BrunoRaphaelHigashi
//
//  Created by Bruno  Juliano Fernandes Martini on 20/04/17.
//  Copyright © 2017 Bruno  Juliano Fernandes Martini. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    @IBOutlet weak var ivProdPic: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
