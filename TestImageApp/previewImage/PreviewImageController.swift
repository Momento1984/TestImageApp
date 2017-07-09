//
//  PreviewImageController.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit
import MessageUI

class PreviewImageController: UIViewController {

  @IBOutlet private var previewImageView: UIImageView!
  @IBOutlet var activityIndicator: UIActivityIndicatorView!
  
  @IBOutlet var selectImageLbl: UILabel!
  var isSelectedImage = false
  
  private var presenter = PreviewImagePresenter()
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    if isSelectedImage {
      start()
    }
  }

  private func setupUI() {
    activityIndicator.stopAnimating()
    selectImageLbl.isHidden = false

    
  }

  func setup(with info: ImageInfo) {
    presenter.imageInfo = info
    self.title = presenter.imageInfo?.name
    self.navigationItem.rightBarButtonItems = []
    isSelectedImage = true
  }

  private func start() {

    activityIndicator.startAnimating()
    selectImageLbl.isHidden = true

    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      do {
        if let image = try self?.presenter.loadImage() {
          DispatchQueue.main.async {
            if let strong = self {
              strong.activityIndicator.stopAnimating()
              strong.previewImageView.image = image
              strong.navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Send", style: .plain, target: strong, action: #selector(strong.shareOnEmail))]
            }
          }
        }
      } catch {
        print(error)
        DispatchQueue.main.async { [weak self] in
          self?.activityIndicator.stopAnimating()
          let alert = UIAlertController(title: "Error",
                                        message: "Some problems on loading images.",
                                        preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
          self?.present(alert, animated: true, completion: nil)
          print(error)
         
        }
      }
    }
  }

  @objc func shareOnEmail() {
    guard MFMailComposeViewController.canSendMail() else {
      let alert = UIAlertController(title: "Error",
                                    message: "Can't send email. Please, check your mail account settings",
                                    preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients([])
    mailComposerVC.setSubject(presenter.imageInfo!.name)
    mailComposerVC.setMessageBody("Only for you", isHTML: false)

    //Add Image as Attachment
    if let image = previewImageView.image {
      let data = UIImageJPEGRepresentation(image, 1.0)
      mailComposerVC.addAttachmentData(data!, mimeType: "png", fileName: "image")
    }

    present(mailComposerVC, animated: true, completion: nil)
  }
}

extension PreviewImageController: MFMailComposeViewControllerDelegate {
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    self.dismiss(animated: true, completion: nil)
  }
}
