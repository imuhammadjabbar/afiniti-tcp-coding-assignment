//
//  ImageCC.swift
//  afiniti-tcp-coding-assignment
//
//  Created by Emerald MacPro on 10/05/2021.
//

import UIKit

class ImageCC: UITableViewCell {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var randomImage: UIImageView!
    
    //
    // MARK: - Properties
    //
    // A previous URL temporarily stored to keep track of previous URL vs. current URL since cells are being reused
    var previousImageUrl: String?
    
    //
    // MARK: - Cell LifeCycle
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //
    // MARK: - Download Image
    //
    func downloadImage(url: String) {
        // randomImage.image = UIImage(named: "placeholderImage");
        
        ImageDownloadManager.shared.download(url: url, completionHandler: { (image, cached) in
            // We will use two conditions here. Their description is as follows,
            // Either image is cached, in which case it is returned synchronously. If image is not cached, it will be returned asynchronously, in which case we want to store the previous image URL and compare it against the most recent value represented by fullImageUrlString property associated with Movie object. If they do not match, do not apply the image since it now belongs to previous cell which has since been reused.
            if cached || (url == self.previousImageUrl) {
                self.randomImage.image = image;
            }
        }, placeholderImage: UIImage(named: "placeholderImage"))
        
        previousImageUrl = url;
    }
    
}
