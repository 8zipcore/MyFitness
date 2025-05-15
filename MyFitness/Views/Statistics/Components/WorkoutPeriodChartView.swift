//
//  WorkoutPeriodChartView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI
import Charts

/// 운동한 시간대를 Bar Chart로 보여주는 컴포넌트
struct WorkoutPeriodChartView: View {
    @ObservedObject var statisticsVM: StatisticsViewModel
    
    var body: some View {
        Text("운동한 시간대 통계")
        VStack {
            Chart(statisticsVM.periodTimes, id: \.period) { element in
                BarMark(x: .value("Count", element.count), stacking: .normalized)
                    .foregroundStyle(by: .value("Period", element.period.rawValue))
                    .cornerRadius(10)
            }
        }
        .padding()
        
        List(statisticsVM.periodTimes, id: \.period) { element in
            HStack {
                Text(element.period.rawValue)
                Text(element.period.timeRange)
                    .font(.callout)
                    .foregroundStyle(.gray)
                Spacer()
                Text("\(element.count)")
                    .bold()
            }
        }
    }
}

#Preview {
    WorkoutPeriodChartView(statisticsVM: StatisticsViewModel())
}
