//
//  CategoryChartView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI
import Charts

struct CategoryChartView: View {
    
    @ObservedObject var statisticsVM: StatisticsViewModel
    let retrospects: [Retrospect]
    
    var body: some View {
        // MARK: - 원형 프로그레스바 완성
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(Category.allCases, id: \.self) { category in
                    let count = statisticsVM.getCategoryCount(retrospects: retrospects, category: category)
                    // TODO: 최대 개수 구해서 하기, 정렬
                    CircularView(category: category, count: count)
                }
            }
        }
    }
}

#Preview {
    CategoryChartView(statisticsVM: StatisticsViewModel(), retrospects: exampleList)
}
