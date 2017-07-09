//
//  ImageListController.swift
//  TestImageApp
//
//  Created by Виталий Антипов on 08.07.17.
//  Copyright © 2017 Виталий Антипов. All rights reserved.
//

import UIKit

class ImageListController: UITableViewController {

  struct CONST {
    static let IMAGE_LIST_CELL = "image list cell"
  }

  fileprivate let presenter = ImageListPresenter()

  private let searchController = UISearchController(searchResultsController: nil)
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    start()
  }

  private func setupUI() {
    tableView.rowHeight = 76
    refreshControl?.addTarget(self, action: #selector(start), for: .valueChanged)
    self.splitViewController?.delegate = self
    title = "Image list"
    searchController.searchResultsUpdater = self
    tableView.tableHeaderView = searchController.searchBar
    searchController.dimsBackgroundDuringPresentation = false
    definesPresentationContext = true

  }

  @objc private func start() {
    refreshControl?.beginRefreshing()
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      do {
        try self?.presenter.loadImageInfo()
        DispatchQueue.main.async {
          self?.tableView.reloadData()
          self?.refreshControl?.endRefreshing()
        }
      } catch {
        DispatchQueue.main.async { [weak self] in
          self?.refreshControl?.endRefreshing()
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

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return presenter.imageInfos.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CONST.IMAGE_LIST_CELL, for: indexPath) as! ImageListItemCell
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      if let (name, image) = self?.loadImage(for: indexPath.row) {
        DispatchQueue.main.async {
          cell.setup(name: name, image: image)
        }
      }
    }
    return cell
  }

  private func loadImage(for index: Int) -> (String, UIImage)? {
    do {
      return try presenter.loadImageTn(for: index)
    } catch {
      DispatchQueue.main.async { [weak self] in

        let alert = UIAlertController(title: "Error",
                                      message: "Some problems on loading images.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self?.present(alert, animated: true, completion: nil)
        print(error)
      }
    }
    return nil
  }

    
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let nav = segue.destination as? UINavigationController else {
      return
    }
    
    guard let pic = nav.visibleViewController as? PreviewImageController else {
      return
    }
    guard let selectedIndex = self.tableView.indexPath(for: sender as! ImageListItemCell) else {
      return
    }
    pic.setup(with: presenter.imageInfos[selectedIndex.row]) {
      [weak self] name, image in
      self?.presenter.setImageInfo(name: name, image: image)
    }
  }

}

extension ImageListController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    presenter.filterForSearch(text: searchController.searchBar.text!)
    tableView.reloadData()
  }
}

extension ImageListController: UISplitViewControllerDelegate {
  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    return true
  }

}
