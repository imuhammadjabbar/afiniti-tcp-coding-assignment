//
//  ImageCC.swift
//  afiniti-tcp-coding-assignment
//
//  Created by Emerald MacPro on 10/05/2021.
//

import UIKit
import Socket

class ImageCC: UITableViewCell {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var randomImage: UIImageView!
    
    //
    // MARK: - Properties
    //
    var previousImageUrl: String? // Previous Cell Image URL
    var indexPath: IndexPath? {
        didSet {
            /*
            if let indexPath = indexPath {
                print("Row: \(indexPath.row)");
            }
            */
        }
    }
    
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
    // MARK: - Download Image - Simultaneously
    //
    func downloadImage(url: String) {
        // randomImage.image = UIImage(named: "placeholderImage");
        
        ImageDownloadManager.shared.download(url: url, completionHandler: { (image, cached) in
            // Cehck If Image is Cached or If it is not a Previous Cell Image
            if cached || (url == self.previousImageUrl) {
                self.randomImage.image = image;
                if let indexPath = self.indexPath { // Testing Simultaneous Image Download
                    print("Image Downloaded: \(indexPath.row)");
                }
                
                // Send Images to Packet Sender / Other Phone
                self.send(image: image)
            }
        }, placeholderImage: UIImage(named: "placeholderImage"))
        
        previousImageUrl = url;
    }
    
    //
    // MARK: - Send Image Data to Other Device / Packet Sender
    //
    func send(image: UIImage?) {
        if let image = image {
            do {
                // Creating a Socket
                let socket = try Socket.create();
                
                // Connecting to Packet Sender
                try socket.connect(to: "192.168.10.9", port: 51108);
                
                // Sending Image Data to Socket / Packet Sender
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    if let indexPath = self.indexPath {
                        print("Image \(indexPath.row) - Total Bytes: \(imageData.count)");
                        // try socket.write(from: "Image \(indexPath.row) - Total Bytes: \(imageData.count)");
                    }
                    try socket.write(from: imageData);
                }
                
            } catch {
                print(error.localizedDescription);
            }
        }
    }
    
}
