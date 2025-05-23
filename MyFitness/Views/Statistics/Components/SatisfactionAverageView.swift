//
//  SatisfactionAverageView.swift
//  MyFitness
//
//  Created by 강대훈 on 5/15/25.
//

import SwiftUI

/// 만족도 평균 컴포넌트
struct SatisfactionAverageView: View {
    @ObservedObject var viewModel: StatisticsViewModel

    var body: some View {
        VStack(spacing: 10) {
            Text("이번 \(viewModel.weekOrMonth == .week ? "주" : "달") 운동 만족도")
                .font(.title3)
                .foregroundStyle(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            ZStack {
                /// 배경 반원
                SemiCircleShape()
                    .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 20, lineCap: .round))

                /// 진행 반원
                SemiCircleShape()
                    .trim(from: 0, to: viewModel.totalSatisfaction.isNaN ? 0.0 : viewModel.totalSatisfaction / 100)
                    .stroke(viewModel.satisfactionColor, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .animation(.easeInOut, value: viewModel.totalSatisfaction / 100)

                Text("\(viewModel.totalSatisfaction.isNaN ? 0 : Int(viewModel.totalSatisfaction))%")
                    .font(.title)
                    .bold()
                    .offset(y: 20)
            }
            .frame(width: 200, height: 100)
            .padding()
        }
    }
}

/// 반원형 크기의 Shape
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
