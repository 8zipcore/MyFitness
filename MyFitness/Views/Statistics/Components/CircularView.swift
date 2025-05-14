//
//  CircularView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI

struct CircularView: View {
    var category: Category
    var count: Int
    
    var body: some View {
        VStack {
            Text(category.rawValue)
                .bold()
                .padding(.bottom, 10)
            CircularProgressBarView(category: category, progress: Double(count) / 10.0, count: count)
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.black.opacity(0.04))
        }
    }
}
