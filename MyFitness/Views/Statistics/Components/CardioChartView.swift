//
//  CardioChartView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI

/// 유산소 세부 운동 컴포넌트
struct CardioChartView: View {
    
    @ObservedObject var statisticsVM: StatisticsViewModel
    @Binding var showCardioAll: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("유산소 운동")
                .font(.title3)
                .foregroundStyle(.gray)
            
            Text("\(statisticsVM.cardioTotalCount)번")
                .font(.title)
                .bold()
        }
        List(showCardioAll ? statisticsVM.cardioCounts : Array(statisticsVM.cardioCounts.prefix(5)), id: \.name) { exercise in
            HStack {
                NavigationLink {
                    
                } label: {
                    VStack(alignment: .leading) {
                        Text("\(exercise.name)")
                            .font(.callout)
                        HStack {
                            ProgressView(value: Double(exercise.count), total: 2)
                                .accentColor(.blue)
                                .background(.clear)
                                .frame(maxWidth: 200)
                            Text("\(exercise.count)번")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                }
            }
        }
        if !showCardioAll && statisticsVM.cardioCounts.count > 5 {
            Button {
                showCardioAll = true
            } label: {
                Label("더보기", systemImage: "plus")
            }
        }
    }
}

#Preview {
    CardioChartView(statisticsVM: StatisticsViewModel(), showCardioAll: .constant(true))
}
