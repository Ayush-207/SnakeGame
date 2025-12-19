//
//  SnakeGameModels.swift
//  MeeshoPractice
//
//  Created by Ayush Goyal on 19/12/25.
//
import UIKit

struct SnakeGameCellData {
    enum CellType {
        case snake
        case food
        case empty
        
        var color: UIColor {
            switch self {
            case .snake:
                return .green
            case .food:
                return .red
            case .empty:
                return .gray
            }
        }
    }
    
    var cellType: CellType = .empty
    
    static var snake: SnakeGameCellData {
        return .init(cellType: .snake)
    }
    
    static var food: SnakeGameCellData {
        return .init(cellType: .food)
    }
    
    static var empty: SnakeGameCellData {
        return .init(cellType: .empty)
    }
}

enum Direction {
    case up
    case down
    case left
    case right

    var valueChange: (Int, Int) {
        switch self {
        case .up:
            return (-1, 0)
        case .down:
            return (1, 0)
        case .left:
            return (0, -1)
        case .right:
            return (0, 1)
        }
    }
}
