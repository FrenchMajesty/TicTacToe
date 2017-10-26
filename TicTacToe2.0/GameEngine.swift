//
//  GameEngine.swift
//  TicTacToe2.0
//
//  Created by Verdi.K on 5/1/17.
//  Copyright © 2017 Verdi.K. All rights reserved.
//

import Foundation

enum GridValue: String {
    case x = "X",
        o = "O",
        empty = " "
}

protocol Grid {
    var id: Int { get }
    var matrix: (Int, Int)! { get }
    func isEmpty() -> Bool
    func set(value: GridValue) -> Void
    func getValue() -> String
    func clear() -> Void
}

class GridSquare: Grid {
    static var counter: Int = 0
    private var content: GridValue
    var matrix: (Int, Int)!
    var id: Int
    
    init() {
        GridSquare.counter += 1
        self.content = .empty
        self.id = GridSquare.counter
        self.matrix = getMatrixCoordinates()
    }
    
    internal func set(value: GridValue) -> Void {
        self.content = value
    }
    
    internal func getValue() -> String {
        return content.rawValue
    }
    
    internal func clear() -> Void {
        self.content = .empty
    }
    
    internal func isEmpty() -> Bool {
        if self.content == .empty {
            return true
        } else {
            return false
        }
    }
    
    internal func getMatrixCoordinates() -> (Int, Int) {
        var coord: (x: Int, y: Int) = (0,0)
        
        if(id == 1 || id == 4 || id == 7) {
            coord.x = 0
        }else if(id == 2 || id == 5 || id == 8) {
            coord.x = 1
        }else if(id == 3 || id == 6 || id == 9) {
            coord.x = 2
        }
        
        if(id >= 1 && id <= 3) {
            coord.y = 0
        }else if(id >= 4 && id <= 6 ) {
            coord.y = 1
        }else if(id >= 7 && id <= 9) {
            coord.y = 2
        }
        
        return coord
    }
}

protocol GameInterface {
    var isGameOver: Bool { get set }
    func refreshFrame() -> Void
    func getPlayerMove() -> Void
    func thereIsAWinner() -> Bool
    func anounceWinner() -> Void
    func isBoardFull() -> Bool
    func changePlayerTurn() -> Void
}

class GameEngine : GameInterface {
    private var board : [[GridSquare]] = []
    private var userPlaying: Int?
    private var lastPlayedGrid: GridSquare?
    var isGameOver: Bool = false
    
    init() {
        // Create board
        for _ in 1 ... 3 {
            var innerArr: [GridSquare] = []
            for _ in 1 ... 3 {
                innerArr.append(GridSquare())
            }
            self.board.append(innerArr)
        }
    }
    
    func refreshFrame() -> Void {
        clearScreen()
        for row in board {
            
            var line: String = ""
            for square in row {
                line += "| " + square.getValue() + " |"
            }
            print(line)
            print("---------------")
        }
    }
    
    func anounceWinner() {
        print("Well played! Player \(userPlaying!) won!")
    }
    
    func thereIsAWinner() -> Bool {
        // Check if ^
        
        // Algorithm to get near-by squares of same value
        if let neighborGrids: [GridSquare] = getSimilarGrid(around: lastPlayedGrid!) {
            for grid in neighborGrids {
                // Find the 'last' square and verify if it's the same value
                if let foundGrid = findLastMatchingGrid(first: lastPlayedGrid!, second: grid) {
                    if(foundGrid.getValue() == lastPlayedGrid?.getValue()) {
                        return true
                    }
                }
            }
        }
        
        return false
    }
    
    func isBoardFull() -> Bool {
        for row in board {
            for square in row {
                if(square.isEmpty()) { return false }
            }
        }
        
        return true
    }
    
    func getPlayerMove() -> Void {
        if userPlaying == nil {
            userPlaying = 1 // Initialize
        }
        
        var square: GridSquare! = selectSquare(number: getSelectedGridSquare())
        
        while(!square.isEmpty()) {
            print("Sorry this case selected is already taken.")
            square = selectSquare(number: getSelectedGridSquare())
        }
        
        // Conquer the grid
        if(userPlaying == 1) {
            square.set(value: .x)
        }else {
            square.set(value: .o)
        }
        
        lastPlayedGrid = square
    }
    
    internal func getSimilarGrid(around grid: GridSquare) -> [GridSquare]? {
        
        let squarePosition: (Int, Int)! = grid.matrix,
            cordinalDirections: [(Int, Int)] = [
                (0,-1), // N
                (1,-1), // NE
                (1,0), // E
                (1,1), // SE
                (0,1), // S
                (-1,1), // SW
                (-1,0), // W
                (-1,-1) // NW
            ]
        
         // Get all grid squares around with same value
        var result: [GridSquare] = []
        for values in cordinalDirections {
            let potential: (y: Int, x: Int) = ( squarePosition.1 + values.1, squarePosition.0 + values.0)
            
            if(isWithinBonds(matrix: potential)) {
                let thisGrid = board[potential.y][potential.x]
                if(thisGrid.getValue() == grid.getValue()) { // Same value
                    result.append(thisGrid)
                }
            }
        }
        
        return result
    }
    
    internal func isWithinBonds(matrix: (y: Int, x: Int)) -> Bool {
        
        if(matrix.x >= 0 && matrix.x <= 2 && matrix.y >= 0 && matrix.y <= 2) {
            return true
        }
        
        return false
    }
    
    internal func findLastMatchingGrid(first grid1: GridSquare, second grid2: GridSquare) -> GridSquare? {
        let matrix1: (Int, Int) = grid1.getMatrixCoordinates(),
            matrix2: (Int, Int) = grid2.getMatrixCoordinates()

        let firstSlope = (matrix1.0 - matrix2.0, matrix1.1 - matrix2.1),
            lastSlope = (matrix2.0 - matrix1.0, matrix2.1 - matrix1.1)
        
        let newestGrid = grid1.getMatrixCoordinates(),
            olderGrid = grid2.getMatrixCoordinates()
        

        let firstSquare = (newestGrid.1 + firstSlope.1, newestGrid.0 + firstSlope.0),
            secondSquare = ( olderGrid.1 + lastSlope.1, olderGrid.0 + lastSlope.0)
        
        if(isWithinBonds(matrix: firstSquare)) {
            return board[firstSquare.0][firstSquare.1]
        }
        if(isWithinBonds(matrix: secondSquare)){
            return board[secondSquare.0][secondSquare.1]
        }
        
        return nil
    }
    
    internal func selectSquare(number: Int) -> GridSquare? {
        for row in board {
            for square in row {
                if(square.id == number) { return square }
            }
        }
        return nil
    }
    
    internal func getSelectedGridSquare() -> Int {
        var move: Int!
        
        repeat {
            print("It is Player \(userPlaying!)'s turn to play. Select a case between 1 - 9:")
            
            // Input validaiton
            let cin: String! = readLine()
            if let input = Int(cin) {
                move = input
            }else {
                move = 0
            }
        }while(move < 1 || move > 9)
        return move;
    }
    
    internal func changePlayerTurn() -> Void {
        if (userPlaying == 1) {
            userPlaying = 2
            
        }else {
            userPlaying = 1
        }
    }
}
