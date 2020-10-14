//
//  CustomTableViewCell.swift
//  OptisolTask
//
//  Created by Santhosh on 13/10/20.
//  Copyright © 2020 Contus. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // News View model instance
    var newsViewModel = NewsViewModel()
    // News title label outlet
    @IBOutlet weak var titleLabel: UILabel!
    // News Description label outlet
    @IBOutlet weak var descLabel: UILabel!
    // UTC date format label
    @IBOutlet weak var utcdateLabel: UILabel!
    // Local time date format label
    @IBOutlet weak var localdateLabel: UILabel!
    // News channel name outlet label
    @IBOutlet weak var nameLabel: UILabel!
    // Preview image view outlet
    @IBOutlet weak var previewImage : UIImageView!
    // Indicator view to display while api is in fetching state
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    
    // Method to configure cell UI elements based on data
    func configure(with articles: articleArr?) {
      if let response = articles {
        self.titleLabel.text = response.title
        self.descLabel.text = response.description
        self.nameLabel.text = response.source.name
        if (response.imageUrl != nil) {
            newsViewModel.downloadImage(from: response.imageUrl!) { (data, response, error) in
                guard let imagedata = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.previewImage.image = UIImage(data: imagedata)
                }
            }
        }
        if (response.publishedAt!.count > 0) {
            utcdateLabel.text = getUTCDateFormat(publishedDate: response.publishedAt ?? "")
            localdateLabel.text = getLocalDateFormat(publishedDate: response.publishedAt ?? "")
        }
        self.indicatorView.stopAnimating()
        self.setFieldAlphaValue(value: 1)
      } else {
        self.setFieldAlphaValue(value: 0)
        self.indicatorView.startAnimating()
      }
    }
    
    // Method to vary the field alpha values to hide/show based on data availability
    func setFieldAlphaValue(value : CGFloat) {
        self.titleLabel.alpha = value
        self.nameLabel.alpha = value
        self.utcdateLabel.alpha = value
        self.localdateLabel.alpha = value
        self.descLabel.alpha = value
        self.previewImage.alpha = value
    }
}

// MARK: Date formatting methods
extension CustomTableViewCell {
    
    // UTC Date and time
    func getUTCDateFormat(publishedDate: String) -> String {
        let utcdateFormatter = DateFormatter()
        utcdateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        utcdateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = utcdateFormatter.date(from: publishedDate)
        utcdateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return utcdateFormatter.string(from: date!)
    }
    
    // Local date and time from UTC
    func getLocalDateFormat(publishedDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let date = dateFormatter.date(from: publishedDate)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date!)
    }
}

