//
//  SatisfactionAverageView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

struct SatisfactionAverageView: View {
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack {
            Text("이번 \(viewModel.weekOrMonth == .week ? "주" : "달") 운동 만족도")
                .font(.title3)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            ZStack {
                /// 배경 반원
                SemiCircleShape()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 20)

                /// 진행 반원
                SemiCircleShape()
                    .trim(from: 0, to: viewModel.totalSatisfaction / 100)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .animation(.easeInOut, value: viewModel.totalSatisfaction / 100)

                Text("\(Int(viewModel.totalSatisfaction))%")
                    .font(.title)
                    .bold()
                    .offset(y: 20)
            }
            .frame(width: 200, height: 100)
            .padding()
        }
    }
}

struct SemiCircleShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY),
                    radius: rect.width / 2,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: false)
        return path
    }
}

#Preview {
    SatisfactionAverageView(viewModel: StatisticsViewModel())
}
