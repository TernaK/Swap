//
//  Grid.swift
//  Swap
//
//  Created by Terna Kpamber on 8/15/15.
//  Copyright © 2015 Terna Kpamber. All rights reserved.
//

import SpriteKit
import Foundation


class Grid {
    
    
    private var size: Point!
    private var grid: [[CellType]]!
    private var correct_cell: Point!
    private var easy: Bool!
    
    private func test(){
        
        print("Starting: \(grid)")
        print(correct_cell)
        swapCell(true)
        print("Current: \(grid)")
        print(correct_cell)
        
        swapCell()
        print("Current: \(grid)")
        print(correct_cell)
        
        swapCell()
        print("Final: \(grid)")
        print(correct_cell)
    }
    
    init(level: Int, easy: Bool = true){
        
        self.easy = easy
        
        let levelFilePath = NSBundle.mainBundle().pathForResource("Levels", ofType: "plist")
        let levels = NSArray(contentsOfFile: levelFilePath!)
        
        if let levelItem = levels?.objectAtIndex(level) as? NSDictionary {
            let layout_string_array = levelItem["layout"] as! [String]
            
            size = setSize(levelItem)
            populateCells(layout_string_array)
            correct_cell = pickCell()
            setCorrectCell()
            
//            test()
            
        }
        else{
            print("No Such Level!")
            abort()
        }
    }
    
    func getGrid() -> [[CellType]]{
        return grid
    }
    func getSize() -> Point{
        return size
    }
    func getCorrectCell() -> Point{
        return correct_cell
    }
    
    private func setSize(levelItem: NSDictionary) -> Point{
        
        let col_len = (levelItem["cols"]?.integerValue)!
        let row_len = (levelItem["rows"]?.integerValue)!
        return Point(row: row_len, col: col_len)
    }
    
    private func pickCell() -> Point{
        
        var closed = true
        var point: Point
        
        repeat {
            
            let col = Int(arc4random() % UInt32(size.col))
            let row = Int(arc4random() % UInt32(size.row))
            point = Point(row: row, col: col)
            
            closed = valueAtPoint(point) == .Closed
        } while(closed)
        
        return point
    }
    
    func setCorrectCell(){
        
        grid[Int(correct_cell.row)][Int(correct_cell.col)] = CellType.Correct
    }
    
    func valueAtPoint(point: Point) -> CellType{
        return grid[point.row][point.col]
    }
    
    private func populateCells(layout_string_array: [String]) {
        
        grid = []
        
        for row in layout_string_array {
            
            var row_array = [CellType]()
            
            
            for cell in row.characters {
                
                switch cell {
                case CellType.Open.rawValue:
                    row_array.append(CellType.Open)
                    break
                case CellType.Closed.rawValue:
                    row_array.append(CellType.Closed)
                    break
                default:
                    print("invalid state")
                    abort()
                    break
                }
            }
            
            grid.append(row_array)
        }
        
    }
    
    
    /**
    *   Swap cells
    *   If swapCorrect is true, the correct cell is graranteed to be swapped
    */
    func swapCell(swapCorrect: Bool = false, perRound: Int = 2) -> [[Point]] {
        
        var swapTracker = [[Point]]()
        
        
        var loc: Point
        var neighbour: Point
        
        
        loc = swapCorrect == true ? correct_cell.copy() : pickCell()
        neighbour = getNeighbour(loc)
        
        if loc.equals(correct_cell) {
            correct_cell = neighbour.copy()
        }else if neighbour.equals(correct_cell){
            correct_cell = loc.copy()
        }
        
        //randomiser
        let random = Int( arc4random() % 2 )
        if random == 0{
            swap(&loc, &neighbour)
        }
        
        swap(&grid[loc.row][loc.col], &grid[neighbour.row][neighbour.col])
        
        swapTracker.append([loc, neighbour])
//        print("neighbour: \(neighbour)\n\n")
        
        return swapTracker
    }
    
    /**
    *  Return count of all neightbours
    */
    private func countAllNeighbours(){
        
    }
    
    /**
    *  Return a neightbour L R U or D
    */
    private func getNeighbour(loc: Point) -> Point {
        
        var neighbours = [Point]()
        
        let loc_x = loc.col
        let loc_y = loc.row
        let size_x = size.col
        let size_y = size.row
        
        //L
        if loc_x - 1 >= 0{
            neighbours.append(Point(row: loc_y, col: loc_x - 1))
        }
        //U
        if loc_y + 1 < size_y {
            neighbours.append(Point(row: loc_y + 1, col: loc_x))
        }
        //R
        if loc_x + 1 < size_x{
            neighbours.append(Point(row: loc_y, col: loc_x + 1))
        }
        //D
        if loc_y - 1 >= 0 {
            neighbours.append(Point(row: loc_y - 1, col: loc_x))
        }
        
        if !easy {
            
            // Corner hard mode
            //DL
            if loc_x - 1 >= 0 && loc_y - 1 >= 0 {
                neighbours.append(Point(row: loc_y - 1, col: loc_x - 1))
            }
            //DR
            if loc_x + 1 < size_x && loc_y - 1 >= 0 {
                neighbours.append(Point(row: loc_y - 1, col: loc_x + 1))
            }
            
            //UL
            if loc_x - 1 >= 0 && loc_y + 1 < size_y {
                neighbours.append(Point(row: loc_y + 1, col: loc_x - 1))
            }
            //UR
            if loc_x + 1 < size_x && loc_y + 1 < size_y {
                neighbours.append(Point(row: loc_y + 1, col: loc_x + 1))
            }

        }
        
        
//        print("loc: \(loc)")
//        print("neigh: \(neighbours[random_index])")
//        print("neighbour count: \(neighbours.count)")
        
        var availableNeighbours = [Point]()
        
        for point in neighbours {
            if valueAtPoint(point) != .Closed {
                availableNeighbours.append(point)
            }
        }
        
//        print("loc: \(loc)")
//        print(availableNeighbours)
        
        let random_index = Int(arc4random() % UInt32(availableNeighbours.count))
        return availableNeighbours[random_index]
    }
}
