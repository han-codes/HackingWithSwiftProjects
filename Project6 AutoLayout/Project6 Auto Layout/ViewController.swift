//
//  ViewController.swift
//  Project2 Guess the Flag
//
//  Created by Hannie Kim on 8/9/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    @IBOutlet weak var button1: UIButton!    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        askQuestion()
    }

    // set 3 country images to the buttons
    // need the UIAlertAction parameter to the handler parameter we use when setting up UIAlertController below
    // default parameter of nil since we don't need a UIAlertAction parameter when we call it in viewDidLoad()
    func askQuestion(action: UIAlertAction! = nil) {
        // use GameplayKit to shuffle the array
        // will randomize the flag images that are set to the buttons
        countries = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: countries) as! [String]
        
        // set image to buttons
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        // generate a random # between 0 and 2
        correctAnswer = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        
        // set title of nav bar to be the uppercased item in countries array with the index of random correctAnswer
        title = countries[correctAnswer].uppercased()
        
        // add a border to buttons
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // add border color to buttons
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == correctAnswer {
            title = "Correct!"
            score += 1
        } else {
            title = "Incorrect!"
            score -= 1
        }
        
//        let alert = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (alert) in
//            self.askQuestion()
//        }))
//        present(alert, animated: true, completion: nil)
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        present(ac, animated: true)

        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

