//
//  CategoryPerCountView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct CategoryPerCountView: View {
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        Text("카테고리별 운동 횟수")
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Category.allCases, id: \.self) { category in
                    let count = viewModel.getCategoryCount(retrospects: exampleList, category: category)
                    // TODO: 최대 개수 구해서 하기, 정렬
                    CircularView(category: category, count: count)
                }
            }
        }
    }
}


