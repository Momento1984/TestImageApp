//
//  ImageListItemCell.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class ImageListItemCell: UITableViewCell {

  @IBOutlet var myImageView: UIImageView!
  
  @IBOutlet var nameLbl: UILabel!
  func setup(name: String, image: UIImage) {
    myImageView.image = image
    nameLbl.text = name
  }

}
