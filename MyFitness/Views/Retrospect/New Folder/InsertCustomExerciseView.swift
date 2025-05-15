//
//  addCustomExerciseView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

/// 유저가 직접 운동을 추가할 수 있는 화면
struct InsertCustomExerciseView: View {
    @Environment(\.modelContext) var context
    @State private var exerciseLabel: String = ""
    let exerciseType: ExerciseType

    var body: some View {
        HStack {
            TextField("원하시는 운동을 추가 하세요", text: $exerciseLabel)
            Spacer()
            Button {
                // MARK: Exercise 데이터 Insert
                guard !exerciseLabel.isEmpty else { return }
                let exercise = Exercise(name: exerciseLabel, exerciseType: exerciseType)
                context.insert(exercise)
                exerciseLabel = ""
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

#Preview {
    InsertCustomExerciseView(exerciseType: .anaerobic)
}
