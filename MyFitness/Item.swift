//
//  Item.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
