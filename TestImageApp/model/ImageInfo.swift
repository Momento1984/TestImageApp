//
//  ImageInfo.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

struct ImageInfo {
  let name: String
  let url: String
  let urlTn: String
  
  var largeImage: UIImage?
  var tinyImage: UIImage?
  
  init(dict: [String: String]) throws {
    guard let name = dict["name"], let url = dict["url"], let urlTn = dict["url_tn"] else {
      throw ImageLoadError.incorrectJSONData
    }
    self.name = name
    self.url = url
    self.urlTn = urlTn
    largeImage = nil
    tinyImage = nil
  }
}
