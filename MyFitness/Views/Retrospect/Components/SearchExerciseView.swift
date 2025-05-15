//
//  SearchExerciseView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI
import SwiftData

/// 유저가 세부 운동을 검색할 수 있는 화면
struct SearchExerciseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)])
    var exercises: [Exercise]

    @State var keyword: String = ""
    @Binding var name: String

    let exerciseType: ExerciseType

    var filteredExercise: [Exercise] {
        if keyword.isEmpty {
            return exercises.filter { $0.exerciseType == exerciseType }
        }

        return exercises.filter {
            $0.exerciseType == exerciseType && $0.name.lowercased().contains(keyword.lowercased())
        }
    }

    var body: some View {
        List {
            Section {
                InsertCustomExerciseView(exerciseType: exerciseType)
            }

            ForEach(filteredExercise) { exercise in
                HStack {
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
                .onTapGesture {
                    name = exercise.name
                    dismiss()
                }
            }
            .onDelete { indexSet in
                // MARK: Exercise 데이터 Delete
                for index in indexSet {
                    context.delete(exercises[index])
                }
            }
        }
        .navigationTitle("운동 검색")
        .searchable(text: $keyword, prompt: "\(exerciseType == .cardio ? "유산소" : "무산소") 운동을 검색하세요")
    }
}

#Preview {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Exercise.self, configurations: config)

        let exercise1 = Exercise(name: "벤치 프레스", exerciseType: .anaerobic)
        let exercise2 = Exercise(name: "데드 리프트", exerciseType: .anaerobic)
        let exercise3 = Exercise(name: "스쿼트", exerciseType: .anaerobic)

        container.mainContext.insert(exercise1)
        container.mainContext.insert(exercise2)
        container.mainContext.insert(exercise3)

        return container
    }()

    NavigationStack {
        SearchExerciseView(name: .constant("테스트"), exerciseType: .cardio)
    }
}
