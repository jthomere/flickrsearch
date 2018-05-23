//
//  Photo.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

class Photo: NSObject, Decodable {

    var remoteId: String?
    var height: String?
    var width: String?
    var title: String?
    var urlString: String?
    var image: UIImage?

    private enum CodingKeys: String, CodingKey {
        case remoteId = "id"
        case height = "height_s"
        case width = "width_s"
        case title
        case urlString = "url_s"
    }


}
