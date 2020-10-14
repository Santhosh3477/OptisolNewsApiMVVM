//
//  ViewModel.swift
//  OptisolTask
//
//  Created by Santhosh on 13/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import Foundation
import UIKit

// API Method type
enum HttpType : String {
    case GET
}

// API Details
enum APIDetails : String {
    case BaseUrl = "https://newsapi.org/v2/everything"
    case apiKey = "7757ce30edda4e1c9df237717f71dbbd"
}

// View Model class for Newslist controller
class NewsViewModel {
    
    // Array to maintain the news data fetched
    var newsListArray = [articleArr]()
    
    // Method to return the data from array at particular index
    func newsList(at index: Int) -> articleArr {
      return newsListArray[index]
    }

    
    // API request to fetch data for the requested page number and save the first record of each page in array
    func loadRequest(pageNumber: Int, onCompletion:@escaping (articleArr?, Error?) -> ()) {
                
        let urlstring : String = "\(APIDetails.BaseUrl.rawValue)?q=\(pageNumber)&apiKey=\(APIDetails.apiKey.rawValue)"
        let url : URL = URL.init(string: urlstring)!
        var request = URLRequest(url: url)
        request.httpMethod = HttpType.GET.rawValue

        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request, completionHandler: { [weak self] (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if let error = error {
                onCompletion(nil, error)
                return
            }
            guard let self = self else {
                return;
            }
            if data != nil  {
                let decodedData = self.decode(data!)
                if (decodedData.1 == nil) {
                    // Saving the first record of each page in array
                    self.newsListArray.append(decodedData.0!.articles[0])
                    onCompletion(decodedData.0!.articles[0], decodedData.1)
                } else {
                    print("Maximum api hits exceeded")
                }
            }
        })
        dataTask.resume()
    }
    
    
    // Method to decode the fetched api response with Model object
    func decode(_ data: Data) -> (NewsResponse?, Error?) {
        let jsonDecoder = JSONDecoder()
        do {
            let values = try jsonDecoder.decode(NewsResponse?.self, from: data)
            return (values, nil)
        }catch (let error) {
            return (nil, error)
        }
    }
    
    // Method to download image content from image url fetched from api response
     func downloadImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        print("Download Started")
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
        
}

