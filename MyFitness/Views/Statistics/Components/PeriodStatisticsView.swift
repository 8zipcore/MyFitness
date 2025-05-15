//
//  PeriodStatisticsView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI
import Charts

struct PeriodStatisticsView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    var body: some View {
        Text("운동한 시간대 통계")
            .font(.title3)
            .foregroundStyle(.gray)
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



