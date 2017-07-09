//
//  ImageLoadError.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import Foundation

enum ImageLoadError: Error {
  case incorrectJSONData
  case incorrectURL
  case noImage
}
