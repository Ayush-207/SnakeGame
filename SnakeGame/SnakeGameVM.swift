//
//  SnakeGameVM.swift
//  MeeshoPractice
//
//  Created by Ayush Goyal on 19/12/25.
//
import Foundation

protocol SnakeGameVMProtocol {
    var maxRows: Int {get}
    var maxColumns: Int {get}
    func updateSnakePositionOnTimer()
    func updateDirection(with direction: Direction)
    func getCellData(for indexPath: IndexPath) -> SnakeGameCellData?
    func getCellSize() -> CGSize
    func getCollectionViewSize() -> CGSize
    func resetGame()
}

protocol SnakeGameVMDelegate: AnyObject {
    func updateGrid(with indexPaths: [IndexPath])
    func resetGame()
    func finishGame(score: Int)
    func updateScore(score: Int)
}

class SnakeGameVM: SnakeGameVMProtocol {
    
    private(set) var maxRows: Int
    private(set) var maxColumns: Int
    
    private var score: Int = 0
    private var snakeCoordinates: [(Int, Int)] = []
    private var foodCoordinates: (Int, Int)
    private var currentDirection: Direction?
    weak var delegate: SnakeGameVMDelegate?
    
    init(maxRows: Int, maxColumns: Int) {
        self.maxRows = maxRows
        self.maxColumns = maxColumns
        let randRow = Int.random(in: 0..<maxRows)
        let randCol = Int.random(in: 0..<maxColumns)
        self.snakeCoordinates.append((randRow, randCol))
        if randRow == 0 && randCol == 0 {
            self.foodCoordinates = (randRow*2, randCol*2)
        } else {
            self.foodCoordinates = (randRow/2, randCol/2)
        }
    }
    
    func updateSnakePositionOnTimer() {
        print("\(#function)")
        guard let valueChange = currentDirection?.valueChange else { return }
        print("value change: \(valueChange)")
        var prevCoordinate: (Int, Int)?
        var isIncreaseLength: Bool = false
        for (idx, coordinate) in snakeCoordinates.enumerated() {
            if let prevCoord = prevCoordinate {
                if checkAndFinishGame(for: prevCoord) {
                    return
                }
                snakeCoordinates[idx] = prevCoord
                prevCoordinate = coordinate
            } else {
                print("x: \(coordinate.0), y: \(coordinate.1)")
                let newX = coordinate.0 + valueChange.0
                let newY = coordinate.1 + valueChange.1
                print("newX: \(newX), newY: \(newY)")
                if checkAndFinishGame(for: (newX, newY)) {
                    delegate?.finishGame(score: score)
                    return
                }
                snakeCoordinates[idx] = (newX, newY)
                prevCoordinate = coordinate
                
                if snakeCoordinates[idx] == foodCoordinates {
                    score += 1
                    isIncreaseLength = true
                    delegate?.updateScore(score: score)
                }
            }
        }
        
        var indexPaths: [IndexPath] = []
        if let prevCoordinate = prevCoordinate {
            var foodCoordList = [foodCoordinates]
            if isIncreaseLength {
                snakeCoordinates.append(prevCoordinate)
                generateRandomFoodCoordinates()
                foodCoordList.append(foodCoordinates)
            }
            indexPaths = snakeCoordinates.map { IndexPath(item: $0.1, section: $0.0)
            }
            indexPaths.append(IndexPath(item: prevCoordinate.1, section: prevCoordinate.0))
            indexPaths.append(contentsOf: foodCoordList.map {IndexPath(item: $0.1, section: $0.0)})
        }
        
        print("indexPaths: \(indexPaths)")
        delegate?.updateGrid(with: indexPaths)
    }
    
    private func isChangingDirectionAllowed(to direction: Direction) -> Bool {
        if snakeCoordinates.count == 1 { return true }
        if currentDirection == .up && direction == .down { return false }
        if currentDirection == .down && direction == .up { return false }
        if currentDirection == .left && direction == .right { return false }
        if currentDirection == .right && direction == .left { return false }
        return true
    }
    
    private func checkAndFinishGame(for coordinate: (Int, Int)) -> Bool {
        guard isOutsideBounds(coordinate: coordinate) || isTouchingSnakeBody(newCoordinate: coordinate) else { return false }
        
        snakeCoordinates = []
        foodCoordinates = (0, 0)
        delegate?.finishGame(score: score)
        return true
    }
    
    private func isTouchingSnakeBody(newCoordinate: (Int, Int)) -> Bool {
        for coordinate in snakeCoordinates {
            if newCoordinate.0 == coordinate.0 && newCoordinate.1 == coordinate.1 {
                return true
            }
        }
        return false
    }
    
    private func generateRandomFoodCoordinates() {
        var tempArr: [(Int, Int)] = []
        for row in 0..<maxRows {
            for col in 0..<maxColumns {
                if snakeCoordinates.contains(where: { $0.0 == row && $0.1 == col }) {
                    continue
                }
                tempArr.append((row, col))
            }
        }
        
        guard let randomCoord = tempArr.randomElement() else { return }
        
        foodCoordinates = randomCoord
    }
    
    private func isOutsideBounds(coordinate: (Int, Int)) -> Bool {
        if coordinate.0 < 0 || coordinate.0 >= maxRows || coordinate.1 < 0 || coordinate.1 >= maxColumns {
            return true
        }
        return false
    }
    
    func updateDirection(with direction: Direction) {
        guard isChangingDirectionAllowed(to: direction) else { return }
        currentDirection = direction
    }
    
    func getCellData(for indexPath: IndexPath) -> SnakeGameCellData? {
        print("\(#function): indexPath: \(indexPath)")
        if isSnakeCell(at: indexPath) {
            print("snake")
            return .snake
        } else if isFoodCell(at: indexPath) {
            print("food")
            return .food
        } else {
            print("empty")
            return .empty
        }
    }
    
    private func isSnakeCell(at indexPath: IndexPath) -> Bool {
        for coordinate in snakeCoordinates {
            if coordinate.1 == indexPath.item, coordinate.0 == indexPath.section {
                return true
            }
        }
        return false
    }
    
    private func isFoodCell(at indexPath: IndexPath) -> Bool {
        return foodCoordinates.0 == indexPath.section && foodCoordinates.1 == indexPath.item
    }
    
    func getCellSize() -> CGSize {
        let width = getCollectionViewSize().width - 3*(CGFloat(maxColumns) - 1)
        let height = getCollectionViewSize().height - 3*(CGFloat(maxRows) - 1)
        return .init(width: width/CGFloat(maxColumns), height: height/CGFloat(maxRows))
    }
    
    func getCollectionViewSize() -> CGSize {
        return .init(width: 300, height: 300)
    }
    
    func resetGame() {
        let randRow = Int.random(in: 0..<maxRows)
        let randCol = Int.random(in: 0..<maxColumns)
        self.snakeCoordinates.append((randRow, randCol))
        if randRow == 0 && randCol == 0 {
            self.foodCoordinates = (randRow*2, randCol*2)
        } else {
            self.foodCoordinates = (randRow/2, randCol/2)
        }
        score = 0
        currentDirection = nil
        delegate?.updateScore(score: 0)
        delegate?.resetGame()
    }
}
