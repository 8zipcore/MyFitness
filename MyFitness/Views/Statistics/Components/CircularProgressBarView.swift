//
//  CircularProgressView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct CircularProgressBarView: View {
    var category: Category
    var progress: Double = 0.0
    var count: Int = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(category.color.opacity(0.4))
            
            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(category.color)
                .rotationEffect(.degrees(-90))

            Text("\(count)건")
                .font(.title2)
                .bold()
        }
        .frame(width: 100, height: 100)
    }
}
