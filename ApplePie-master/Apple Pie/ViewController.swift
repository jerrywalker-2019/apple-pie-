//
//  ViewController.swift
//  Apple Pie
//
//  Created by Sterre Smit on 07/11/2018.
//  Copyright © 2018 Sterre Smit. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    // Outlets for the indicators, letterbuttons and the image
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // List of guessable words and allowed incorrect moves before game over
    var listOfWords = ["sterre", "studio",  "app", "appel", "boom"]
    var incorrectMovesAllowed = 7
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newRound()
    }
    
    // Indicator values of game statistics
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    
    // Action function whenever a button is pressed
    @IBAction func buttonPressed(_ sender: UIButton) {
        // whenever pressed, it turns gray
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    // whenever one button is pressed
    func updateGameState() {
        // when there is no turn left, total losses increases
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
            // whenever one word is guessed, total wins increases
        } else if currentGame.word == currentGame.formattedWord {
            totalWins += 1
            // alternatively, call updateUI to continue
        } else { updateUI()
        }
    }
    
    
    var currentGame: Game!
    
    // When a new round starts
    func newRound() {
        // whenever there are any wordes left, the game moves on to the next
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            // incorrect moves are set to the correct state, guessed letters are cleared
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [] )
            enableLetterButtons(true)
            updateUI()
        } else {
            // when no words left, go to play again screen
            enableLetterButtons(false)
            performSegue(withIdentifier: "Finished", sender: nil)
        }
        
    }
    // letters enabling function
    func enableLetterButtons (_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
    
    
    func updateUI() {
        var letters = [String]()
        for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }
        // spaced between dashes
        let wordWithSpacing = letters.joined(separator:" ")
        correctWordLabel.text = wordWithSpacing
        // scoring indicators
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        
    }
    // When the player chooses to start over, the inital word list is returned and all scores reset
    func startOver() {
        listOfWords = ["sterre", "studio",  "app", "appel", "boom"]
        incorrectMovesAllowed = 7
        totalWins = 0
        totalLosses = 0
        
        enableLetterButtons(true)
        treeImageView.image = UIImage(named: "Tree 7")
        updateGameState()
        updateUI()
    }
    
    // when play again button is pressed, game starts over blanc
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue){
        if segue.identifier == "Dismiss" {
            startOver()
            
            
            
            
        }
    }
    
}


