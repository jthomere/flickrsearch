//
//  PhotosViewController.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var client = APIClient()
    var photos = [Photo]()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        searchPhotos(with: "dogs")
    }

    func searchPhotos(with text: String) {
        client.getPhotos(searchText: text) { (photosFound, initialText, error) in
            self.photos = photosFound
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
        let photo = photos[indexPath.row]
        cell.textLabel?.text = photo.title
        cell.imageView?.sizeToFit()
        if let image = photo.image {
            cell.imageView?.image = image
        } else {
            client.loadImage(for: photo) { (error) in
                DispatchQueue.main.async {
                    cell.imageView?.image = photo.image
                    tableView.reloadData()
                }
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

}

