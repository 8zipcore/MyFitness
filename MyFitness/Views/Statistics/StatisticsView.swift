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
    @Query
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
    @State private var selected: CategoryCount? = nil
    @State var weekOrMonth: WeekOrMonth = .week
    
    var exampleList: [Retrospect] = [
        
        Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(name: "레그 익스텐션", weight: 50, count: 12, set: 4)], cardios: [Cardio(name: "러닝머신", minutes: 20)], startTime: .now, finishTime: .now + 1200, satisfaction: 80, writing: "팔 운동 집중!", bookMark: false),
        
        Retrospect(date: .now - 86400, category: [.arms], anaerobics: [Anaerobic(name: "스쿼트", weight: 80, count: 10, set: 5)], cardios: [Cardio(name: "사이클", minutes: 15)], startTime: .now - 86400, finishTime: .now - 86400 + 1800, satisfaction: 75, writing: "하체 불태움", bookMark: true),
        
        Retrospect(date: .now - 172800, category: [.chest], anaerobics: [Anaerobic(name: "벤치프레스", weight: 70, count: 8, set: 4)], cardios: [], startTime: .now - 172800, finishTime: .now - 172800 + 1500, satisfaction: 85, writing: "가슴 펌핑 제대로!", bookMark: false),
        
        Retrospect(date: .now - 259200, category: [.chest], anaerobics: [Anaerobic(name: "랫풀다운", weight: 55, count: 10, set: 4)], cardios: [Cardio(name: "걷기", minutes: 30)], startTime: .now - 259200, finishTime: .now - 259200 + 2400, satisfaction: 90, writing: "등운동은 역시 기분좋아", bookMark: true),
        
        Retrospect(date: .now - 345600, category: [.chest], anaerobics: [Anaerobic(name: "플랭크", weight: 0, count: 1, set: 3)], cardios: [Cardio(name: "점핑잭", minutes: 10)], startTime: .now - 345600, finishTime: .now - 345600 + 1200, satisfaction: 65, writing: "복근 타격감 최고", bookMark: false),
        
        Retrospect(date: .now - 432000, category: [.chest], anaerobics: [Anaerobic(name: "숄더프레스", weight: 40, count: 10, set: 4)], cardios: [], startTime: .now - 432000, finishTime: .now - 432000 + 1600, satisfaction: 70, writing: "어깨에 불 들어옴", bookMark: true),
        
        Retrospect(date: .now - 518400, category: [.legs], anaerobics: [Anaerobic(name: "딥스", weight: 0, count: 12, set: 4)], cardios: [Cardio(name: "로잉머신", minutes: 25)], startTime: .now - 518400, finishTime: .now - 518400 + 2100, satisfaction: 78, writing: "가슴+팔 조합 굿", bookMark: false),
        
        Retrospect(date: .now - 604800, category: [.legs], anaerobics: [Anaerobic(name: "런지", weight: 20, count: 10, set: 3)], cardios: [Cardio(name: "스텝퍼", minutes: 20)], startTime: .now - 604800, finishTime: .now - 604800 + 1800, satisfaction: 82, writing: "균형감각 좋아짐", bookMark: true),
        
        Retrospect(date: .now - 691200, category: [.legs], anaerobics: [Anaerobic(name: "데드리프트", weight: 100, count: 5, set: 4)], cardios: [], startTime: .now - 691200, finishTime: .now - 691200 + 2000, satisfaction: 88, writing: "오늘의 하이라이트", bookMark: false),
        
        Retrospect(date: .now - 777600, category: [.legs], anaerobics: [Anaerobic(name: "바벨 컬", weight: 30, count: 10, set: 3)], cardios: [Cardio(name: "줄넘기", minutes: 10)], startTime: .now - 777600, finishTime: .now - 777600 + 1300, satisfaction: 72, writing: "팔 힘이 많이 늘었음", bookMark: true)
    ]
    
    
    var body: some View {
        let counts: [CategoryCount] = exampleList.categoryCounts
        
        NavigationStack {
            VStack {
                Picker("기간", selection: $weekOrMonth) {
                    ForEach(WeekOrMonth.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                Chart(counts) { entry in
                    SectorMark(angle: .value("횟수", entry.categoryCount), innerRadius: .ratio(0.6), angularInset: 4)
                        .foregroundStyle(by: .value("Category", entry.categoryName))
                        .annotation(position: .overlay, alignment: .center) {
                            //                            Text(/*entry.categoryName*/ /*+ " \(entry.categoryCount) 회"*/)
                            //                                .foregroundStyle(./*primary*/)
                        }
                }
                .chartBackground { chartProxy in
                    GeometryReader { geomtry in
                        let frame = geomtry[chartProxy.plotFrame!]
                        VStack {
                            Text("자주 운동한 시간")
                                .font(.title2)
                            if let mostFrequent = counts.max(by: { $0.categoryCount < $1.categoryCount }) {
                                Text("\(mostFrequent.categoryName) \(mostFrequent.categoryCount) 회")
                            }
                            
                        }
                        .position(x: frame.midX, y: frame.midY)
                    }
                }
                .padding()
                .chartLegend(.visible)
                .chartLegend(position: .bottom, alignment: .center)
                .animation(.easeOut(duration: 0.8), value: exampleList.count)
                
                
                
            }
            .navigationTitle("통계")
        }
        
    }
}

#Preview {
    StatisticsView()
}

struct CategoryCount: Identifiable {
    let id = UUID()
    let categoryName: String
    let categoryCount: Int
}

extension Array where Element == Retrospect {
    var categoryCounts: [CategoryCount] {
        // 1. allCategories: 모든 Retrospect의 category 배열을 flatMap으로 합치기
        let allCategories = self.flatMap { $0.category }
        
        // 2. rawValue별로 count 계산
        let countsByName = allCategories
            .map(\.rawValue)
            .reduce(into: [String: Int]()) { acc, name in
                acc[name, default: 0] += 1
            }
        
        // 3. CategoryCount로 변환 (원하는 순서로 정렬 가능)
        return countsByName
            .map { CategoryCount(categoryName: $0.key, categoryCount: $0.value) }
            .sorted { $0.categoryCount > $1.categoryCount }
    }
}
