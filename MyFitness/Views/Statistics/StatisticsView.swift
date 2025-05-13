//
//  StatisticsView.swift
//  MyFitness
//
//  Created by 하재준 on 5/12/25.
//

import SwiftUI
import SwiftData
import Charts

// 통계뷰
struct StatisticsView: View {
    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    private var retrospects: [Retrospect]
    
//    private var categoryStats: [Category: Int] {
//        var result: [Category: Int] = [:]
//
//        for retrospect in retrospects {
//            for cat in retrospect.category {
//                if let category = Category(rawValue: cat.rawValue) {
//                    result[category, default: 0] += 1
//                }
//            }
//        }
//
//        return result
//    }
    enum WeekOrMonth: String, CaseIterable, Identifiable {
        case week = "7일"
        case month = "30일"
        
        var id: String { self.rawValue }
    }
    @State var weekOrMonth: WeekOrMonth = .week
    
    var exampleList: [Retrospect] = [
        
        Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(exercise: Exercise(name: "레그 익스프레스"), weight: 50, count: 3, set: 10)], cardios: [Cardio(exercise: Exercise(name: "달리기"), minutes: 30)], startTime: .now, finishTime: .now + 1800, satisfaction: 70, writing: "오늘 화이팅", bookMark: true),
        
        Retrospect(date: .now - 86400, category: [.chest], anaerobics: [Anaerobic(exercise: Exercise(name: "벤치 프레스"), weight: 80, count: 8, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2400, satisfaction: 85, writing: "가슴 운동 느낌 좋음", bookMark: true),
        
        Retrospect(date: .now - 2 * 86400, category: [.back], anaerobics: [Anaerobic(exercise: Exercise(name: "랫풀다운"), weight: 60, count: 12, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2100, satisfaction: 65, writing: "등이 땡긴다", bookMark: false),
        
        Retrospect(date: .now - 3 * 86400, category: [.cardio], anaerobics: [], cardios: [Cardio(exercise: Exercise(name: "러닝머신"), minutes: 40)], startTime: .now, finishTime: .now + 2400, satisfaction: 50, writing: "지루했지만 끝냈다", bookMark: false),
        
        Retrospect(date: .now - 4 * 86400, category: [.legs], anaerobics: [Anaerobic(exercise: Exercise(name: "스쿼트"), weight: 90, count: 6, set: 4)], cardios: [], startTime: .now, finishTime: .now + 2700, satisfaction: 90, writing: "하체 힘들지만 보람있음", bookMark: true),
        
        Retrospect(date: .now - 5 * 86400, category: [.shoulders], anaerobics: [Anaerobic(exercise: Exercise(name: "숄더 프레스"), weight: 35, count: 10, set: 3)], cardios: [], startTime: .now, finishTime: .now + 1800, satisfaction: 75, writing: "어깨 불타는 느낌", bookMark: false),
        
        Retrospect(date: .now - 6 * 86400, category: [.butt], anaerobics: [Anaerobic(exercise: Exercise(name: "힙 쓰러스트"), weight: 70, count: 10, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2000, satisfaction: 85, writing: "엉덩이 자극 굿", bookMark: true),
        
        Retrospect(date: .now - 7 * 86400, category: [.arms, .chest], anaerobics: [Anaerobic(exercise: Exercise(name: "푸쉬업"), weight: 0, count: 15, set: 3)], cardios: [], startTime: .now, finishTime: .now + 1500, satisfaction: 60, writing: "간단한 운동", bookMark: false),
        
        Retrospect(date: .now - 8 * 86400, category: [.cardio], anaerobics: [], cardios: [Cardio(exercise: Exercise(name: "자전거 타기"), minutes: 50)], startTime: .now, finishTime: .now + 3000, satisfaction: 55, writing: "날씨 좋아서 좋았음", bookMark: false),
        
        Retrospect(date: .now - 9 * 86400, category: [.legs], anaerobics: [Anaerobic(exercise: Exercise(name: "레그 프레스"), weight: 100, count: 8, set: 4)], cardios: [], startTime: .now, finishTime: .now + 2500, satisfaction: 95, writing: "기록 경신!", bookMark: true)
    ]
    

    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("기간", selection: $weekOrMonth) {
                    ForEach(WeekOrMonth.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()

                
                Chart(exampleList) { entry in
                    SectorMark(angle: .value("Count", entry.category.count), innerRadius: .ratio(0.6), angularInset: 3)
                        .foregroundStyle(by: .value("Category", entry.category[0].rawValue))
                }
                .chartBackground { chartProxy in
                    GeometryReader { geomtry in
                        let frame = geomtry[chartProxy.plotFrame!]
                        VStack {
                            Text("가장 많이 한 운동")
                                .font(.title2)
                            Text("팔 1 회") // TODO: - 데이터 바인딩
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                    
                }
                .padding()
                

            }
            .navigationTitle("통계")
        }
        
    }
}

#Preview {
    StatisticsView()
}
