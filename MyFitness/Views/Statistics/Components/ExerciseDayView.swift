//
//  ExerciseDay.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct ExerciseDayView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    var body: some View {
        Text("이번 \(viewModel.weekOrMonth == .week ? "주" : "달") 운동한 날")
            .font(.title3)
            .foregroundStyle(.gray)

        Text("\(viewModel.exerciseDayCount)번")
            .font(.title)
            .bold()
    }
}


