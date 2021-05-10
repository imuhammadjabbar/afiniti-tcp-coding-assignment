//
//  ImagesViewController.swift
//  afiniti-tcp-coding-assignment
//
//  Created by Emerald MacPro on 10/05/2021.
//

import UIKit

class ImagesViewController: UIViewController {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var tableViewImages: UITableView!
    
    //
    // MARK: - View LifeCycle
    //
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    //
    // MARK: - Navigation
    //
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//
// MARK: - TableView DataSource & Delegates
//
extension ImagesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.images.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCC", for: indexPath) as! ImageCC;
        cell.downloadImage(url: Constants.images[indexPath.row]);
        
        return cell;
    }
}
