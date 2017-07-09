//
//  ImageInfo.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

struct ImageInfo {
  let name: String
  let url: String
  let urlTn: String
  
  init(dict: [String: String]) throws {
    guard let name = dict["name"], let url = dict["url"], let urlTn = dict["url_tn"] else {
      throw ImageLoadError.incorrectJSONData
    }
    self.name = name
    self.url = url
    self.urlTn = urlTn
  }
}
