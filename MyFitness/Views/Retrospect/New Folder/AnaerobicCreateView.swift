//
//  AnaerobicCreateView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct AnaerobicCreateView: View {
    @Binding var anaerobic: Anaerobic
    @State private var showSearchView: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(anaerobic.name == "" ? "운동명" : anaerobic.name)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .contentShape(Rectangle()) // 제스쳐 범위 늘리기
            .onTapGesture {
                showSearchView = true
            }

            Divider()

            HStack {
                Picker("", selection: $anaerobic.weight) {
                    ForEach(Array(stride(from: 0, through: 200, by: 5)), id: \.self) { number in
                        Text("\(number)")
                    }
                }

                Text("Kg")

                Picker("", selection: $anaerobic.set) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }

                }

                Text("세트")

                Picker("", selection: $anaerobic.count) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                Text("회")

                Spacer()
            }
        }
        .sheet(isPresented: $showSearchView) {
            NavigationStack {
                SearchExerciseView(name: $anaerobic.name, exerciseType: .anaerobic)
            }
        }
    }
}

#Preview {
    AnaerobicCreateView(anaerobic: .constant(Anaerobic(name: "스쿼트", weight: 100, count: 10, set: 4)))
        .padding()
}
