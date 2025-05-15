//
//  CardioCreateView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

/// 유산소 운동을 추가할 때 나타나는 화면
struct CardioCreateView: View {
    @Binding var cardio: Cardio
    @State private var showSearchView: Bool = false

    var body: some View {
        HStack {
            Text(cardio.name == "" ? "운동명" : cardio.name)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    showSearchView = true
                }
            Spacer()
            Picker("", selection: $cardio.minutes) {
                ForEach(0..<201, id: \.self) { number in
                    Text("\(number)")
                }
            }
            .labelsHidden()
            .clipped()
            Text("분")
        }
        .sheet(isPresented: $showSearchView) {
            NavigationStack {
                SearchExerciseView(name: $cardio.name, exerciseType: .cardio)
            }
        }
    }
}

#Preview {
    CardioCreateView(cardio: .constant(Cardio(name: "런닝머신", minutes: 90)))
}
