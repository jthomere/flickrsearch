//
//  APIClient.swift
//  FlickrSearch
//
//  Created by Jerome Thomere on 5/22/18.
//  Copyright © 2018 Jerome Thomere. All rights reserved.
//

import UIKit

struct APIClient {

    let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&extras=url_s&format=json&nojsoncallback=1"

    func getPhotos(searchText: String, page: Int, completion: @escaping (([Photo], Int?, String, Error?) -> Void)) {
        let session = URLSession(configuration: .default)
        let urlSearchString = urlString + "&page=\(page)&text=\(searchText)"
        guard let url = URL(string: urlSearchString) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion([], nil, searchText, error)
                return
            }
            if let data = data {
                let (photos, pages) = self.parsePhotos(from: data)
                completion(photos, pages, searchText, nil)
            } else {
                completion([], nil, searchText, error)
            }
        }
        task.resume()
    }

    func parsePhotos(from data: Data) -> ([Photo],Int?) {
        do {
            let decoder = JSONDecoder()
            let result = try decoder.decode(PhotoSearchResult.self, from: data)
            let pages = result.photos?.pages
            guard let page = result.photos,
                let photos = page.photo else {
                    return ([], nil)
            }
            return (photos, pages)
        }
        catch {
            print(error)
        }
        return ([], nil)
    }

    func loadImage(for photo: Photo, completion: @escaping ((Error?) -> Void)) {
        if let urlString = photo.urlString,
            let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                if let data = data {
                    photo.image = UIImage(data: data)
                    completion(nil)
                } else {
                    completion(error)
                }
            }
            task.resume()
        }
    }

}
