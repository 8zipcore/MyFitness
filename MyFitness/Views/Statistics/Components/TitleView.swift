//
//  TitleView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct TitleView: View {
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        HStack(spacing: 0) {
            Button {
                viewModel.changeDate(type: viewModel.weekOrMonth, direction: .previous)
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
            }

            Text(viewModel.dateToString(type: viewModel.weekOrMonth))
                .minimumScaleFactor(0.5)
                .frame(maxWidth: .infinity)

            if !viewModel.isCurrent(type: viewModel.weekOrMonth) { // 현재 날짜 이후는 데이터 조회 불가
                Button {
                    viewModel.changeDate(type: viewModel.weekOrMonth, direction: .next)
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12)
                }
            } else {
                Spacer()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    TitleView(viewModel: StatisticsViewModel())
}

