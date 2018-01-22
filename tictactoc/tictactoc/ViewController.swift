//
//  ViewController.swift
//  tictactoc
//
//  Created by manoj karki on 1/17/18.
//  Copyright © 2018 manoj karki. All rights reserved.
//

import UIKit
enum GameType : String {
    case singleplayer
    case multiplayer
}


class ViewController: UIViewController {
    @IBOutlet weak var gameStatusLbl: UILabel!
    var totalBtnArray: [UIButton] = []
    @IBOutlet weak var resetBtn: UIButton!
    var gameState = [0,0,0,0,0,0,0,0,0]
var winningCombination = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
var activePlayer = 1
var gameIsActive = true
var gameType = GameType.multiplayer
 
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    @IBOutlet weak var button5: UIButton!
    @IBOutlet weak var button6: UIButton!
    @IBOutlet weak var button7: UIButton!
    @IBOutlet weak var button8: UIButton!
    @IBOutlet weak var button9: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        gameStatusLbl.text = "Player \(activePlayer) turn"
        resetBtn.isHidden = true
        resetBtn.layer.backgroundColor = UIColor.clear.cgColor
        resetBtn.layer.cornerRadius = resetBtn.frame.width/2
        resetBtn.backgroundColor = .clear
        totalBtnArray = []
        totalBtnArray.append(button1)
        totalBtnArray.append(button2)
        totalBtnArray.append(button3)
        totalBtnArray.append(button4)
        totalBtnArray.append(button5)
        totalBtnArray.append(button6)
        totalBtnArray.append(button7)
        totalBtnArray.append(button8)
        totalBtnArray.append(button9)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func buttonClicked(_ sender: UIButton) {
        let tag = sender.tag
        if gameState[tag - 1] == 0 && gameIsActive {
            gameState[tag - 1] = activePlayer
            if activePlayer == 1 {
              sender.setImage(UIImage(named: "cross"), for: UIControlState())
              activePlayer = 2
            }else {
             sender.setImage(UIImage(named: "circleIcon"), for: UIControlState())
              activePlayer = 1
            }
             gameStatusLbl.text = "Player \(activePlayer) turn"
           
            for combination in winningCombination {
                if gameState[combination[0]] != 0 && gameState[combination[0]] ==   gameState[combination[1]]  && gameState[combination[1]] ==   gameState[combination[2]]  {
                    gameIsActive = false
                    let playerwon = activePlayer == 1 ? 2 : 1
                    gameStatusLbl.text = "player \(playerwon) win"
                    resetBtn.isHidden = false
                   
                    break
                }
            }
            
            if !gameState.contains(0) && gameIsActive{
                gameIsActive = false
                gameStatusLbl.text = "game draw"
                resetBtn.isHidden = false
            }
            
            if gameType == GameType.singleplayer && gameIsActive{
                if activePlayer == 2 {
                    let when = DispatchTime.now() + 0.5
                    DispatchQueue.main.asyncAfter(deadline: when) {
                        self.PlayByComputer()
                    }
                }
            }
            
            
        }
    }
    
    func PlayByComputer() {
        gameIsActive = false
        var playerOneSelectedIndex: [Int] = []
        var playerTwoSelectedIndex: [Int] = []
        var i = 0
        for index in gameState {
            if index == 1 {
                playerOneSelectedIndex.append(i)
            }else if index == 2 {
                playerTwoSelectedIndex.append(i)
            }
            i = i + 1
        }
        
        var selectedIndex = -1
        //first check if computer can win or not
        for combination in winningCombination {
            if (playerTwoSelectedIndex.contains(combination[0]) && playerTwoSelectedIndex.contains(combination[1]) &&  !playerOneSelectedIndex.contains(combination[2])) {
                selectedIndex = combination[2]
            } else if (playerTwoSelectedIndex.contains(combination[2]) && playerTwoSelectedIndex.contains(combination[1]) &&  !playerOneSelectedIndex.contains(combination[0])) {
                selectedIndex = combination[0]
            }else if (playerTwoSelectedIndex.contains(combination[0]) && playerTwoSelectedIndex.contains(combination[2]) &&  !playerOneSelectedIndex.contains(combination[1])) {
                selectedIndex = combination[1]
            }
            
            if selectedIndex != -1 {
                break
            }
            
        }
        
        //if win for computer is not possible then else case is executed
         if selectedIndex != -1 {
            gameIsActive = true
            totalBtnArray[selectedIndex].sendActions(for: .touchUpInside)
         }
         else {
        //if computer cannot win then find possible win for user and try to avoid win situation
        let filteredPossible = winningCombination.filter({
            (playerOneSelectedIndex.contains($0[0]) &&  playerOneSelectedIndex.contains($0[1]) && !playerTwoSelectedIndex.contains($0[2])) || (playerOneSelectedIndex.contains($0[2]) &&  playerOneSelectedIndex.contains($0[1]) && !playerTwoSelectedIndex.contains($0[0])) || (playerOneSelectedIndex.contains($0[2]) &&  playerOneSelectedIndex.contains($0[0]) && !playerTwoSelectedIndex.contains($0[1]))
        })

        if filteredPossible.count > 0 {
            var possibleSelectionIndexForUser: [Int] = []
            for combination in filteredPossible {
                let notSelectedInCombination = combination.filter({
                    !(playerOneSelectedIndex.contains($0))
                })
                for notSelectedItem in notSelectedInCombination {
                    if !possibleSelectionIndexForUser.contains(notSelectedItem) {
                        possibleSelectionIndexForUser.append(notSelectedItem)
                    }
                }


            }

            let randomIndex = Int(arc4random_uniform(UInt32(possibleSelectionIndexForUser.count)))
            let selectedCircleForComputer = possibleSelectionIndexForUser[randomIndex]
            gameIsActive = true
            totalBtnArray[selectedCircleForComputer].sendActions(for: .touchUpInside)

        }else {
            let filteredPossibleWin = winningCombination.filter({
                (playerOneSelectedIndex.contains($0[0]) && !(playerTwoSelectedIndex.contains($0[1]) || playerTwoSelectedIndex.contains($0[2]))) ||  (playerOneSelectedIndex.contains($0[1]) && !(playerTwoSelectedIndex.contains($0[0]) || playerTwoSelectedIndex.contains($0[2]))) || (playerOneSelectedIndex.contains($0[2]) && !(playerTwoSelectedIndex.contains($0[1]) || playerTwoSelectedIndex.contains($0[0])))
            })

            var possibleSelectionIndexForUser: [Int] = []
            for combination in filteredPossibleWin {
                let notSelectedInCombination = combination.filter({
                    !(playerOneSelectedIndex.contains($0))
                })
                for notSelectedItem in notSelectedInCombination {
                    if !possibleSelectionIndexForUser.contains(notSelectedItem) {
                        possibleSelectionIndexForUser.append(notSelectedItem)
                    }
                }
            }

            let randomIndex = Int(arc4random_uniform(UInt32(possibleSelectionIndexForUser.count)))
            let selectedCircleForComputer = possibleSelectionIndexForUser[randomIndex]
            gameIsActive = true
            totalBtnArray[selectedCircleForComputer].sendActions(for: .touchUpInside)
        }
        }
    
        
     
        
      
    }
    
    @IBAction func closeGame(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        gameIsActive = true
        gameState = [0,0,0,0,0,0,0,0,0]
        sender.isHidden = true
        activePlayer = 1
        gameStatusLbl.text = "Player \(activePlayer) turn"
        
        for btn in totalBtnArray {
            btn.setImage(nil, for: UIControlState())
        }
        
    }
    
}

