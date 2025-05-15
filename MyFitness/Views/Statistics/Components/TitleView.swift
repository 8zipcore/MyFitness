//
//  TitleView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct TitleView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var viewModel: StatisticsViewModel
    
    var body: some View {
        let tintColor: Color = colorScheme == .light ? .black : .white
        
        HStack(spacing: 0) {
            Button {
                viewModel.changeDate(type: viewModel.weekOrMonth, direction: .previous)
            } label: {
                Image(systemName: "chevron.backward")
                    .resizable()
                    .scaledToFit()
                    .tint(tintColor)
                    .frame(width: 16, height: 16)
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
                        .tint(tintColor)
                        .frame(width: 16, height: 16)
                }
            } else {
                Spacer()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}

#Preview {
    TitleView(viewModel: StatisticsViewModel())
}

