//
//  PhotoDetailViewController.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {


    var photo: Photo?

    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var textView: UITextView!



    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = photo {
            photoImageView.image = photo.image
            textView.text = photo.title
        }
        // Do any additional setup after loading the view.
    }


}
