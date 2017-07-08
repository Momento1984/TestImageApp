//
//  PreviewImageController.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class PreviewImageController: UIViewController {

  @IBOutlet private var previewImageView: UIImageView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  private var presenter = PreviewImagePresenter()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    start()
  }
  
  private func setupUI() {
    self.title = presenter.imageInfo.name
    activityIndicator.startAnimating()

  }
  
  func setup(with info: ImageInfo) {
    presenter.imageInfo = info
  }
  
  private func start() {
    activityIndicator.startAnimating()
    
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      do {
        let image = try self?.presenter.loadImage()
        DispatchQueue.main.async {
          self?.activityIndicator.stopAnimating()
          self?.previewImageView.image = image
        }
      } catch {
        print(error)
        DispatchQueue.main.async { [weak self] in
          self?.activityIndicator.stopAnimating()
        }
      }
    }
  }
  
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
