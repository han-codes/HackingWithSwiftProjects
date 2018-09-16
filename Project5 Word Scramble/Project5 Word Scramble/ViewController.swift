//
//  ViewController.swift
//  Project5 Word Scramble
//
//  Created by Hannie Kim on 8/16/18.
//  Copyright © 2018 Hannie Kim. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UITableViewController {
    
    var allWords = [String]()   // holds all words in the input file start.txt
    var usedWords = [String]()  // holds all words player has used in the game
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // sets a right bar button that calls promptForAnswer method
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
            , target: self, action: #selector(promptForAnswer))
        
        // finds file path of start.txt
        if let startWordsPath = Bundle.main.path(forResource: "start", ofType: "txt") {
            // Loads contents of startWordsPath into a String
            // using try? if it doesn't load contents into a String, it'll return nil
            if let startWords = try? String(contentsOfFile: startWordsPath) {
                // startWords which is a String now, is separated by new lines and appended to allWords array
                allWords = startWords.components(separatedBy: "\n")
            }
        } else {
            // if the file path of start.txt couldn't be found at the beginning, append "silkworm" to allWords array
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        // shuffles order of allWords array
        allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
        title = allWords[0]
        // removes all itmes in usedWords array
        usedWords.removeAll(keepingCapacity: true)
        // reloads all the data
        tableView.reloadData()
    }
    
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
        // adds a text field for the user to input answers
        ac.addTextField()
        
        // code will use self and ac so we declare them as unowned so Swift doesn't create a strong reference cycle
        // closure takes a UIAlertAction as a parameter
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [unowned self, ac] (action: UIAlertAction) in
            let answer = ac.textFields![0]
            self.submit(answer: answer.text!)   // calls the submit method
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    // called in promptForAnswer() submitAction closure
    func submit(answer: String){
        // lowercase when checking the string, since strings are case-sensitive
        let lowerAnswer = answer.lowercased()
        
        // will contain the error title and message for UIAlertController
        let errorTitle: String
        let errorMessage: String
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    // insert the answer at the beginning of usedWords to display on top of view controller
                    usedWords.insert(answer, at: 0)
                    
                    // insert a new row into table view
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    
                    // exit the method when table has been updated with correct rows
                    return
                } else {
                    errorTitle = "Word not recognized"
                    errorMessage = "You can't just make up word!"
                }
            } else {
                errorTitle = "Word has already been used"
                errorMessage = "Be more original!"
            }
        } else {
            errorTitle = "Word is not possible"
            errorMessage = "You can't spell that word from '\(title!.lowercased())'!"
        }
        
        // prompt user that their input is incorrect
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    // if answer can be made into the player's word
    func isPossible(word: String) -> Bool {
        // the given word
        var tempWord = title!.lowercased()
        
        // loop through the user input
        for letter in word {
            // pulls out every letter of the String as a new data type of Character
            // but range(of:) expects a String so create a string from the character
            if let pos = tempWord.range(of: String(letter)) {
                // if letter wasn't found in the string, remove the used letter
                tempWord.remove(at: pos.lowerBound)
            } else {
                return false
            }
        }
        
        return true
    }
    
    // if answer hasn't been reused
    func isOriginal(word: String) -> Bool {
        // return true if word is not in usedWords array
        return !usedWords.contains(word)
    }
    
    // if the answer is an actual English word
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()   // checks the text for spelling errors
        let range = NSMakeRange(0, word.utf16.count)    // make a string range, that holds position and length
        // returns a NSRange, which tells us where the misspelling is found
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        // if misspellings are not found from NSRange, it will have a location of NSNotFound
        // saying the word is spelled correctly, that it is a legit english word
        return misspelledRange.location == NSNotFound
    }
    
    // # of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    // what the cells display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

