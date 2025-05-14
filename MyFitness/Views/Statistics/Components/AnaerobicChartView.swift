//
//  AnaerobicChartView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI

struct AnaerobicChartView: View {
    
    @ObservedObject var statisticsVM: StatisticsViewModel
    @Binding var showAnaerobicAll: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("무산소 운동")
                .font(.title3)
                .foregroundStyle(.gray)
            
            Text("\(statisticsVM.anaerobicTotalCount)번")
                .font(.title)
                .bold()
        }
        List(showAnaerobicAll ? statisticsVM.anaerobicCounts : Array(statisticsVM.anaerobicCounts.prefix(5)), id: \.name) { exercise in // 무산소 세부 운동 이름과, 횟수를 가져와야 합니당
            NavigationLink {
                
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(exercise.name)")
                            .font(.callout)
                        HStack {
                            // TODO: 최대 개수 구해서 하기, 정렬
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
        if !showAnaerobicAll && statisticsVM.anaerobicCounts.count > 5 {
            Button {
                showAnaerobicAll = true
            } label: {
                if !showAnaerobicAll {
                    Label("더보기", systemImage: "plus")
                }
            }
        }
    }
}

#Preview {
    AnaerobicChartView(statisticsVM: StatisticsViewModel(), showAnaerobicAll: .constant(true))
}
