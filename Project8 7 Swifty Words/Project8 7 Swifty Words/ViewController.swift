//
//  ViewController.swift
//  Project 8: 7 Swifty Words
//
//  Created by Hannie Kim on 8/24/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {

    @IBOutlet weak var cluesLabel: UILabel!             // to hold the clues
    @IBOutlet weak var answersLabel: UILabel!           // the # of letters of the answer
    @IBOutlet weak var currentAnswer: UITextField!      // the grouped letters user has tapped to guess
    @IBOutlet weak var scoreLabel: UILabel!             // keep track of user's score
    
    var letterButtons = [UIButton]()        // buttons that hold the groups of letters
    var activatedButtons = [UIButton]()     // the buttons user has tapped before submitting their answer
    var solutions = [String]()              // array of solutions
    
    // execute the code in didSet when score property is changed
    var score = 0 {
        didSet {
            scoreLabel.text = "Score \(score)"
        }
    }
    
    var level = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to reference the 20 UIButtons w/ out individual @IBActions
        for subview in view.subviews where subview.tag == 1001 {        // for subviews that have a tag of 1001
            let btn = subview as! UIButton                              // subview is a UIButton and set to btn constant
            letterButtons.append(btn)                                   // add the UIButton to letterButtons UIButton array
            btn.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)       // add target (like an @IBAction) to the UIButton subview. letterTapped method
        }
        
        loadLevel()
    }
    
    // MARK: Load and Parse Level Text File/Randomly Assign Letter Groups to Buttons
    func loadLevel() {
        var clueString = ""             // holds all the level's clues
        var solutionString = ""         // how many letters each answer is
        var letterBits = [String]()     // array to store all letter groups
        
        if let levelFilePath = Bundle.main.path(forResource: "level\(level)", ofType: ".txt") {   // gets the file path of the txt file
            if let levelContents = try? String(contentsOfFile: levelFilePath) {         // have contents of the file be String
                var lines = levelContents.components(separatedBy: "\n")
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]       // shuffles the lines in level txt file
                
                // loop through array
                for (index, line) in lines.enumerated() {   // tells us where each item was in the array (index), the data (line)
                    let parts = line.components(separatedBy: ": ")      // separate the already shuffled lines by semi colon. Left part and Right part of the string
                    let answer = parts[0]       // first half of the separated text line. the letter groups
                    let clue = parts[1]         // second half of the separated text line. the clue string
                    
                    // Numbers the clues and displays them on a new line
                    clueString += "\(index + 1). \(clue)\n"
                    
                    // remove the | from the letter groups
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"         // counts the # of letters in solutionWord
                    solutions.append(solutionWord)          // add the correct word to solutions array
                    
                    // separate the groups of letters in each line
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits          // add the groups of letters to [String]
                }
            }
        }
        
        // Now configure the buttons and labels
        // remove leading and trailing white spaces
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // the groups of letters to form the correct words are shuffled
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: letterBits) as! [String]
        
        // if the # of shuffled groups of letters equal the # of buttons, which is 20
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)      // set title of button to the group of letters
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // @objc since it's used w/ a UI item
    @objc func letterTapped(btn: UIButton) {
        currentAnswer.text = currentAnswer.text! + btn.titleLabel!.text!
        activatedButtons.append(btn)
        btn.isHidden = true
    }

    // the submit button
    @IBAction func submitTapped(_ sender: UIButton) {
        if let solutionPosition = solutions.index(of: currentAnswer.text!) { // return index of solution that has currentAnswer.text string
            activatedButtons.removeAll()
            
            // take the splitAnswers string and turns it into an array
            var splitAnswers = answersLabel.text!.components(separatedBy: "\n")
            splitAnswers[solutionPosition] = currentAnswer.text!        // sets correct answers w/ the answer text
            answersLabel.text = splitAnswers.joined(separator: "\n")    // join the answers label back together
            
            currentAnswer.text = ""
            score += 1
            
            // if they've scored all 7 times, alert them about next level
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true, completion: nil)
            }
        }
    }
    
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    
    // the clear button
    @IBAction func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""         // clears out the text field
        
        // for all the buttons that are activated (the buttons user has tapped before submitting)
        for btn in activatedButtons {
            btn.isHidden = false        // the activated buttons are hidden, so this unhides them 
        }
        
        // removes all items in activatedButtons array
        // the buttons user has pressed before the submit button
        activatedButtons.removeAll()
    }
}

