//
//  CityCollectionViewCell.swift
//  Cloudy
//
//  Created by Орлов Максим on 01.08.2018.
//  Copyright © 2018 Орлов Максим. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 15
    }
    
    func configureSelf(withModel model: City) {
        cityNameLabel.text = model.name
    }
}
