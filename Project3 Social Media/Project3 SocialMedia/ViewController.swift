//
//  ViewController.swift
//  Project1 StormViewer
//
//  Created by Hannie Kim on 8/8/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    // holds the image filenames
    var pictures = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"    
        
        // use the file system to look for files
        let fm = FileManager.default
        
        // finding where we can find the files we need
        let path = Bundle.main.resourcePath!
        
        // the contents of the path we just specified with let path
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        // executes for every item we find in the app bundle
        for item in items {
            // if the item has nssl as the prefix in the string, execute
            if item.hasPrefix("nssl") {
                // this is a picture to load
                pictures.append(item)
            }
        }
        // prints the names of the image files that start w/ nssl
        print(pictures)
    }
    
    // # of rows in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // # of pictures images will be the # of rows in the section
        return pictures.count
    }

    // what will the cells display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for the cells display the filename index inside of pictures array
        // saves thw row in the reuse queue so it doesn't create new table cells but reuses ones we have
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            
            // 2: success! Set its selectedImage property
            // selectedImage is a property in DetailViewController
            // it'll contain the filename of the row we choose
            vc.selectedImage = pictures[indexPath.row]
            
            // 3: push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

