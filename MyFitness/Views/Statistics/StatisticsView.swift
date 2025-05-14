import SwiftUI
import SwiftData
import Charts

// 통계뷰

enum WeekOrMonth: String, CaseIterable, Identifiable {
    case week = "7일"
    case month = "30일"
    
    var id: String { self.rawValue }
}

struct StatisticsView: View {
    
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var statisticsVM = StatisticsViewModel()

    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    private var retrospects: [Retrospect]

    @State private var selected: CategoryCount? = nil
    @State private var weekOrMonth: WeekOrMonth = .week
    @State private var showAnaerobicAll: Bool = false
    @State private var showCardioAll: Bool = false

    init() {
        // 어떻게 처음을 세팅할까?
        // 경고나서 일단 주석처리 해두었습니다
//        statisticsVM.setData(retrospects: exampleList)
    }
    
    let exampleList = DummyData().exampleList
    
    var body: some View {
        let counts: [CategoryCount] = exampleList.categoryCounts
        
        let isLight = colorScheme == .light
        let primaryColor: Color = isLight ? .black : .white
        
        NavigationStack {
            Picker("기간", selection: $weekOrMonth) {
                ForEach(WeekOrMonth.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            HStack(spacing: 0) {
                Button {
                    statisticsVM.changeDate(type: weekOrMonth, direction: .previous)
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(primaryColor)
                        .frame(width: 15, height: 15)
                }
                
                Text(statisticsVM.dateToString(type: weekOrMonth))
                    .font(.title3)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                
                if !statisticsVM.isCurrent(type: weekOrMonth) { // 현재 날짜 이후는 데이터 조회 불가
                    Button {
                        statisticsVM.changeDate(type: weekOrMonth, direction: .next)
                    } label: {
                        Image(systemName: "chevron.forward")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(primaryColor)
                            .frame(width: 15, height: 15)
                    }
                } else {
                    Spacer()
                        .frame(width: 20, height: 20)
                }
            }
            .padding(.horizontal, 30)
            
            Form {
                Section {
                    WorkoutPeriodChartView(statisticsVM: statisticsVM)
                }
                
                Section {
                    CategoryChartView(
                        statisticsVM: statisticsVM,
                        retrospects: retrospects
                    )
                }
                
                Section {
                    AnaerobicChartView(
                        statisticsVM: statisticsVM,
                        showAnaerobicAll: $showAnaerobicAll
                    )
                }
                
                Section {
                    CardioChartView(
                        statisticsVM: statisticsVM,
                        showCardioAll: $showCardioAll
                    )
                }
                
                Section {
                    WorkoutTimeChartView(
                        statisticsVM: statisticsVM,
                        retrospects: exampleList,
                        weekOrMonth: weekOrMonth
                    )
                }
                
                // Pie Chart
                /*
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
                .frame(height: 300)
                 */
            }
        }
        // TODO: 문제는 처음 화면이 뜰 때 데이터를 받지 못함
        // TODO: 날짜를 넘겨줘야 할수도??
        .onChange(of: weekOrMonth) {
            statisticsVM.setData(retrospects: exampleList)
            showCardioAll = false
            showAnaerobicAll = false
        }
        .navigationTitle("통계")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    NavigationStack {
        StatisticsView()
    }
}

struct DummyData {
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
}
