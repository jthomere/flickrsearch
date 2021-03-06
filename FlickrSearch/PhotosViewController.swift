//
//  PhotosViewController.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var client = APIClient()
    var photos = [Photo]()
    var photosToUpdate = Set<Photo>()
    var currentPage = 1
    var pages: Int?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }

    func searchPhotos(with text: String) {
        guard !text.isEmpty else {
            self.photos = []
            tableView.reloadData()
            return
        }
        client.getPhotos(searchText: text, page: currentPage) {[weak self](photosFound, pages, initialText, error) in
            DispatchQueue.main.async {
                if let controller = self {
                    guard initialText == controller.searchBar.text else {
                        return
                    }
                    controller.pages = pages
                    controller.photos = controller.photos + photosFound
                    controller.tableView.reloadData()
                }
            }
        }
    }

    //MARK:- UITableViewDelegate, UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath)
        if indexPath.row >= photos.count - 1 {
            if let pages = pages, currentPage < pages {
                currentPage += 1
                searchPhotos(with: searchBar.text ?? "")
            }
        }
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.title
        cell.imageView?.sizeToFit()
        if let image = photo.image {
            cell.imageView?.image = image
        } else {
            photosToUpdate.insert(photo)
            client.loadImage(for: photo) { (error) in
                DispatchQueue.main.async {
                    cell.imageView?.image = photo.image
                    self.photosToUpdate.remove(photo)
                    if self.photosToUpdate.isEmpty {
                        tableView.reloadData()
                    }
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    //MARK:- UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentPage = 1
        photos = []
        searchPhotos(with: searchText)
    }

     // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ShowPhoto") {
            if let viewController = segue.destination as? PhotoDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                    viewController.photo = photos[indexPath.row]
            }
        }
     }


}

