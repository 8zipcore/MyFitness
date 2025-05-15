//
//  CategoryPerCountView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

/// 카테고리별 횟수 컴포넌트
struct CategoryPerCountView: View {
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack(spacing: 10) {
            Text("카테고리별 운동 횟수")
                .font(.title3)
                .foregroundStyle(.gray)
            
            Divider()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.getSortedCategoryList(), id: \.0) { item in
                        CircularView(category: item.0, count: item.1, totalCount: Double(viewModel.totalCategoryCount))
                    }
                }
            }
        }
    }
}

/// 하나의 카테고리 컴포넌트
struct CircularView: View {
    @Environment(\.colorScheme) var colorScheme

    var category: Category
    var count: Int
    var totalCount: Double

    var body: some View {
        VStack {
            Text(category.rawValue)
                .bold()
                .padding(.bottom, 10)
            CircularProgressBarView(category: category, progress: Double(count) / totalCount, count: count)
        }
        .padding(15)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(colorScheme == .light ? .black.opacity(0.04) : .white.opacity(0.04))
        }
    }
}

/// 원형 프로그레스바를 그려주는 컴포넌트
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

#Preview {
    CategoryPerCountView(viewModel: StatisticsViewModel())
}
