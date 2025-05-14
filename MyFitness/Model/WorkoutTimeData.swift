//
//  WorkoutTimeData.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import Foundation

struct WorkoutTimeData: Identifiable {
    var id = UUID()
    var week: String
    var time: Int
}
