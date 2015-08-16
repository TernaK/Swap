//
//  Utils.swift
//  Swap
//
//  Created by Terna Kpamber on 8/15/15.
//  Copyright © 2015 Terna Kpamber. All rights reserved.
//

import Foundation



enum CellType: Character {
    case Open = "1"
    case Closed = "0"
    case Correct = "X"
}

struct Point {
    var row: Int
    var col: Int
    
    func equals(otherPoint: Point) -> Bool{
        return self.row == otherPoint.row && self.col == otherPoint.col
    }
    
    func copy() -> Point {
        return Point(row: self.row, col: self.col)
    }
}