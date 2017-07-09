//
//  previewImagePresenter.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

final class PreviewImagePresenter {
  var imageInfo: ImageInfo?

  
  func loadImage() throws -> UIImage? {
    guard let imageInfo = imageInfo else {
      return nil
    }
    if let image = imageInfo.largeImage {
      return image
    } else {
      guard let url = URL(string: imageInfo.url) else {
        throw ImageLoadError.incorrectURL
      }
      let data = try Data(contentsOf: url)
      guard let image = UIImage(data: data) else {
        throw ImageLoadError.noImage
      }
      return image
    }
  }
}
