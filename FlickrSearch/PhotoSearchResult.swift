//
//  PhotoSearchResult.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

class PhotoSearchResult: NSObject, Decodable {
    var photos: SearchPage?

}
class SearchPage: NSObject, Decodable {
    var page: Int?
    var photo: [Photo]?

}
