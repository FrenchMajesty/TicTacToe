//
//  main.swift
//  TicTacToe2.0
//
//  Created by Verdi.K on 5/1/17.
//  Copyright © 2017 Verdi.K. All rights reserved.
//

import Foundation

func welcomeMessage() -> Void {
    print("Welcome to my Tic Tac Toe Game, in Swift!")
}

func printMainMenu() -> Void {
    print("1) Press 1 to play a game Player vs. Player")
    print("2) Press 2 to play a game Player vs. AI")
}

func clearScreen() -> Void {
    print("\n\n\n\n\n\n\n\n")
}





//// ********************** ////

welcomeMessage()

var gameToPlay: Int?
var playAgain: Bool = true

while(playAgain) {
    
    // Selection of Main Menu
    repeat {
        printMainMenu()
        gameToPlay = Int(readLine()!)
    
    }while(gameToPlay != 1 && gameToPlay != 2)

    if gameToPlay == 1 {
        // Player vs. Player
    
        var Game = GameEngine()
    
        while(!Game.isGameOver) {
        
            Game.refreshFrame()
            Game.getPlayerMove()
            
            if(Game.thereIsAWinner()) {
                
                Game.isGameOver = true
                Game.refreshFrame()
                Game.anounceWinner()
            }
            
            if(Game.isBoardFull()) {
                
                Game.isGameOver = true
                Game.refreshFrame()
                print("The board is full, it's a draw.")
            }

            Game.changePlayerTurn()
        }
        
    }else if gameToPlay == 2 {
        // Player vs. AI
        print("Our engineers are still working on this...")
    }
    
    // Exit condition
    print("Would you like to play again? (Y) for yes or anything else to exit")
    let input: String! = readLine()
    if(input.lowercased() != "y") { playAgain = false }
}
