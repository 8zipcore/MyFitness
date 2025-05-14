//
//  WorkoutTimeChartView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI
import Charts

struct WorkoutTimeChartView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var statisticsVM: StatisticsViewModel
    let retrospects: [Retrospect]
    let weekOrMonth: WeekOrMonth
    
    var body: some View {
        let isLight = colorScheme == .light
        
        Text("운동 시간")
            .font(.title3)
            .foregroundStyle(.gray)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        Chart(statisticsVM.workoutTimes(from: retrospects, type: weekOrMonth)) { item in
            BarMark(
                x: .value("주", item.week),
                y: .value("시간", item.time)
            )
            .foregroundStyle(isLight ? RGB(r: 255, g: 46, b: 0) : RGB(r: 255, g: 68, b: 9))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .annotation {
                if item.time > 0 {
                    Text("\(item.time)분")
                        .font(.caption2)
                        .foregroundStyle(isLight ? .black.opacity(0.4) : .white.opacity(0.4))
                }
            }
        }
        .chartYAxis(.hidden)
        .foregroundStyle(.green)
    }
}

#Preview {
    WorkoutTimeChartView(statisticsVM: StatisticsViewModel(), retrospects: DummyData().exampleList, weekOrMonth: .month)
}
