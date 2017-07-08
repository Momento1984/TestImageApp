//
//  ImageListPresenter.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import UIKit
final class ImageListPresenter {
  private(set) var imageInfos = [ImageInfo]()
  
  struct CONST {
    static let JSON_URL = "http://www.xiag.ch/share/testtask/list.json"
  }
  
  func loadImageTn(for index: Int) throws -> (String, UIImage) {
    assert(index < imageInfos.count)
    guard let url = URL(string: imageInfos[index].urlTn) else {
      throw ImageLoadError.incorrectURL
    }
    let data = try Data(contentsOf: url)
    guard let image = UIImage(data: data) else {
      throw ImageLoadError.noImage
    }
    return (imageInfos[index].name, image)
  }
  
  func loadImageInfo() throws {
    guard let url = URL(string: CONST.JSON_URL) else {
      throw ImageLoadError.incorrectURL
    }
    let data = try Data(contentsOf: url)
    guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
      throw ImageLoadError.incorrectJSONData
    }
    imageInfos = try json.map { try ImageInfo(dict: $0) }
    //print(imageInfos)
  }
  
}
