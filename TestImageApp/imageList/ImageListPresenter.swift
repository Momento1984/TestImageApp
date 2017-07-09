//
//  ImageListPresenter.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//
import UIKit
final class ImageListPresenter {
  private var allImageInfos = [ImageInfo]()
  private(set) var imageInfos = [ImageInfo]()

  struct CONST {
    static let JSON_URL = "http://www.xiag.ch/share/testtask/list.json"
  }
  
  func loadImageTn(for index: Int) throws -> (String, UIImage) {
    assert(index < imageInfos.count)
    let name = imageInfos[index].name
    if let image = imageInfos[index].tinyImage {
      return (name, image)
    }
    guard let url = URL(string: imageInfos[index].urlTn) else {
      throw ImageLoadError.incorrectURL
    }
    let data = try Data(contentsOf: url)
    guard let image = UIImage(data: data) else {
      throw ImageLoadError.noImage
    }
    return (name, image)
  }
  
  func loadImageInfo() throws {
    guard let url = URL(string: CONST.JSON_URL) else {
      throw ImageLoadError.incorrectURL
    }
    let data = try Data(contentsOf: url)
    guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
      throw ImageLoadError.incorrectJSONData
    }
    allImageInfos = try json.map { try ImageInfo(dict: $0) }
    imageInfos = allImageInfos
    //print(imageInfos)
  }
  
  func setImageInfo(name: String, image: UIImage) {
    if let index = allImageInfos.index(where: {$0.name == name}) {
      allImageInfos[index].largeImage = image
    }
    if let index = imageInfos.index(where: {$0.name == name}) {
      imageInfos[index].largeImage = image
    }

  }
  
  func filterForSearch(text: String) {
    if text != "" {
      imageInfos = allImageInfos.filter { $0.name.lowercased().contains(text.lowercased()) }
    } else {
      imageInfos = allImageInfos
    }
  }
  
}
