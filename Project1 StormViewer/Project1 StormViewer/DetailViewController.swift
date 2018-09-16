//
//  DetailViewController.swift
//  Project1 StormViewer
//
//  Created by Hannie Kim on 8/8/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var selectedImage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = selectedImage
        
        // if selectedImage has a value, set it to imageToLoad
        // then set the imageView outlet to the UIImage with filename of imageToLoad
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
        
        // removes large titles that are inherited from ViewController
        navigationItem.largeTitleDisplayMode = .never
    }
    
    // when the detail view appears, hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    // when view is tapped, it will unhide the nav bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // hides both the home indicator and navigation bar at the same time
    override func prefersHomeIndicatorAutoHidden() -> Bool {
        // if navigation controller is present, it return a true Boolean value for the method
        // so home indicator will be hidden and also nav controller
        return navigationController?.hidesBarsOnTap ?? false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
