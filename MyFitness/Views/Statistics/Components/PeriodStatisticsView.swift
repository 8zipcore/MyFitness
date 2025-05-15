//
//  PeriodStatisticsView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI
import Charts

/// 운동 시간 분석 컴포넌트
struct PeriodStatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    var body: some View {
        VStack(spacing: 10) {
            Text("운동한 시간대 통계")
                .font(.title3)
                .foregroundStyle(.gray)
            
            Divider()
            
            VStack {
                Chart(viewModel.periodTimes, id: \.period) { element in
                    BarMark(x: .value("Count", element.count), stacking: .normalized)
                        .foregroundStyle(by: .value("Period", element.period.rawValue))
                        .cornerRadius(10)
                }
            }
            .padding()
            
            List(viewModel.periodTimes, id: \.period) { element in
                HStack {
                    Text(element.period.rawValue)
                    Text(element.period.timeRange)
                        .font(.callout)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text("\(element.count)번")
                        .bold()
                }
            }
        }
    }
}



