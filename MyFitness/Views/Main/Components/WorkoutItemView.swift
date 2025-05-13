//
//  WorkoutItemView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/13/25.
//

import SwiftUI

struct WorkoutItemView: View {
    
    let workoutItems: [WorkoutItem]
    let textColor: Color
    
    var body: some View {
        VStack(spacing: 15) {
            ForEach(0..<workoutItems.count, id: \.self) { index in
                let workoutItem = workoutItems[index]
                
                HStack {
                    Text(workoutItem.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(textColor)
                    
                    Spacer()
                    
                    Text(workoutItem.contents)
                        .font(.headline)
                        .fontWeight(.regular)
                        .foregroundStyle(textColor)
                }
            }
        }
    }
}

#Preview {
    WorkoutItemView(workoutItems: [], textColor: .black)
}
