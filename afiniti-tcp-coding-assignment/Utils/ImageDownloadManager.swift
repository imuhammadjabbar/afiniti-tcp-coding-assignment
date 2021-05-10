//
//  ImageDownloadManager.swift
//  afiniti-tcp-coding-assignment
//
//  Created by Emerald MacPro on 10/05/2021.
//

import Foundation
import UIKit


class ImageDownloadManager {

    //
    // MARK: - Singleton
    //
    static let shared = ImageDownloadManager()

    //
    // MARK: - Properties
    //
    private var cachedImages: [String: UIImage]
    private var imagesDownloadTasks: [String: URLSessionDataTask]
    // Queue to Write the Non Thread Safe Dict
    let queueForImages = DispatchQueue(label: "imagesQueue", attributes: .concurrent)
    let queueForDataTasks = DispatchQueue(label: "dataTasksQueue", attributes: .concurrent)

    //
    // MARK: Private init - Singleton
    //
    private init() {
        cachedImages = [:]
        imagesDownloadTasks = [:]
    }

    //
    // MARK: - Download Image
    //
    func download(url: String?, completionHandler: @escaping (UIImage?, Bool) -> Void, placeholderImage: UIImage?) {

        guard let imageUrl = url else {
            completionHandler(placeholderImage, true)
            return
        }

        if let image = getCachedImage(url: imageUrl) {
            completionHandler(image, true)
        } else {
            guard let url = URL(string: imageUrl) else {
                completionHandler(placeholderImage, true)
                return
            }

            if let _ = getDataTask(url: imageUrl) {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

                guard let data = data else {
                    return
                }

                if let _ = error {
                    DispatchQueue.main.async {
                        completionHandler(placeholderImage, true)
                    }
                    return
                }

                let image = UIImage(data: data)
                self.queueForImages.async(flags: .barrier) {
                    self.cachedImages[imageUrl] = image
                }

                _ = self.queueForDataTasks.sync(flags: .barrier) {
                    self.imagesDownloadTasks.removeValue(forKey: imageUrl)
                }

                DispatchQueue.main.async {
                    completionHandler(image, false)
                }
            }
            
            // In case dict/array is beign access by multiple threads
            self.queueForDataTasks.async(flags: .barrier) {
                self.imagesDownloadTasks[imageUrl] = task
            }

            task.resume()
        }
    }

    //
    // MARK: - Cancel Previous Task
    //
    private func cancelTask(url: String?) {
        if let url = url, let task = getDataTask(url: url) {
            task.cancel()
            // Because dict/arrays in swift are not thread safe, so we have to set the barrier to error in case mutliple thread try to access it at the same time
            _ = queueForDataTasks.sync(flags: .barrier) {
                imagesDownloadTasks.removeValue(forKey: url)
            }
        }
    }

    //
    // MARK: - Get Cache Image
    //
    private func getCachedImage(url: String) -> UIImage? {
        // Thread Safe Dict Reading
        self.queueForImages.sync {
            return cachedImages[url]
        }
    }

    //
    // MARK: - Get Data Task
    //
    private func getDataTask(url: String) -> URLSessionTask? {
        // Thread Safe Dict Reading
        self.queueForDataTasks.sync {
            return imagesDownloadTasks[url]
        }
    }
    
}

