import SwiftUI
import SwiftData
import Charts

var exampleList: [Retrospect] = [
    Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(name: "레그 익스텐션", weight: 50, count: 12, set: 4)], cardios: [Cardio(name: "러닝머신", minutes: 20)], startTime: .now, finishTime: .now + 1200, satisfaction: 80, writing: "팔 운동 집중!", bookMark: false),

    Retrospect(date: .now - 86400, category: [.legs], anaerobics: [Anaerobic(name: "스쿼트", weight: 80, count: 10, set: 5)], cardios: [Cardio(name: "사이클", minutes: 15)], startTime: .now - 86400, finishTime: .now - 86400 + 1800, satisfaction: 75, writing: "하체 불태움", bookMark: true),

    Retrospect(date: .now - 172800, category: [.chest], anaerobics: [Anaerobic(name: "벤치프레스", weight: 70, count: 8, set: 4)], cardios: [], startTime: .now - 172800, finishTime: .now - 172800 + 1500, satisfaction: 85, writing: "가슴 펌핑 제대로!", bookMark: false),

    Retrospect(date: .now - 259200, category: [.back], anaerobics: [Anaerobic(name: "랫풀다운", weight: 55, count: 10, set: 4)], cardios: [Cardio(name: "걷기", minutes: 30)], startTime: .now - 259200, finishTime: .now - 259200 + 2400, satisfaction: 90, writing: "등운동은 역시 기분좋아", bookMark: true),

    Retrospect(date: .now - 345600, category: [.back], anaerobics: [Anaerobic(name: "플랭크", weight: 0, count: 1, set: 3)], cardios: [Cardio(name: "점핑잭", minutes: 10)], startTime: .now - 345600, finishTime: .now - 345600 + 1200, satisfaction: 65, writing: "복근 타격감 최고", bookMark: false),

    Retrospect(date: .now - 432000, category: [.shoulders], anaerobics: [Anaerobic(name: "숄더프레스", weight: 40, count: 10, set: 4)], cardios: [], startTime: .now - 432000, finishTime: .now - 432000 + 1600, satisfaction: 70, writing: "어깨에 불 들어옴", bookMark: true),

    Retrospect(date: .now - 518400, category: [.arms, .chest], anaerobics: [Anaerobic(name: "딥스", weight: 0, count: 12, set: 4)], cardios: [Cardio(name: "로잉머신", minutes: 25)], startTime: .now - 518400, finishTime: .now - 518400 + 2100, satisfaction: 78, writing: "가슴+팔 조합 굿", bookMark: false),

    Retrospect(date: .now - 604800, category: [.legs], anaerobics: [Anaerobic(name: "런지", weight: 20, count: 10, set: 3)], cardios: [Cardio(name: "스텝퍼", minutes: 20)], startTime: .now - 604800, finishTime: .now - 604800 + 1800, satisfaction: 82, writing: "균형감각 좋아짐", bookMark: true),

    Retrospect(date: .now - 691200, category: [.back, .shoulders], anaerobics: [Anaerobic(name: "데드리프트", weight: 100, count: 5, set: 4)], cardios: [], startTime: .now - 691200, finishTime: .now - 691200 + 2000, satisfaction: 88, writing: "오늘의 하이라이트", bookMark: false),

    Retrospect(date: .now - 777600, category: [.arms], anaerobics: [Anaerobic(name: "바벨 컬", weight: 30, count: 10, set: 3)], cardios: [Cardio(name: "줄넘기", minutes: 10)], startTime: .now - 777600, finishTime: .now - 777600 + 1300, satisfaction: 72, writing: "팔 힘이 많이 늘었음", bookMark: true)
]

enum WeekOrMonth: String, CaseIterable, Identifiable {
    case week = "주간"
    case month = "월간"

    var id: String { self.rawValue }
}

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()

    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    private var retrospects: [Retrospect]

    @State private var weekOrMonth: WeekOrMonth = .week
    @State private var showAnaerobicAll: Bool = false
    @State private var showCardioAll: Bool = false

    init() {
        // 어떻게 처음을 세팅할까?
        viewModel.setData(retrospects: exampleList)
    }

    var body: some View {
        Form {
            Picker("기간", selection: $weekOrMonth) {
                ForEach(WeekOrMonth.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Section {
                VStack(alignment: .leading) {
                    Text("이번 \(weekOrMonth == .week ? "주" : "달") 운동한 날")
                        .font(.title3)
                        .foregroundStyle(.gray)

                    Text("5번")
                        .font(.title)
                        .bold()
                }
            }

            Section {
                Text("운동한 시간대 통계")
                VStack {
                    Chart(viewModel.periodTimes, id: \.period) { element in
                        BarMark(x: .value("Count", element.count), stacking: .normalized)
                            .foregroundStyle(by: .value("Period", element.period.rawValue))
                            .cornerRadius(10)
                    }
                }
                .padding()

                List(viewModel.periodTimes, id: \.period) { element in
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

            Section {
                // MARK: - 원형 프로그레스바 완성
                Text("카테고리별 운동 횟수")
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(Category.allCases, id: \.self) { category in
                            let count = viewModel.getCategoryCount(retrospects: exampleList, category: category)
                            // TODO: 최대 개수 구해서 하기, 정렬
                            CircularView(category: category, count: count)
                        }
                    }
                }
            }

            Section {
                VStack(alignment: .leading) {
                    Text("무산소 운동")
                        .font(.title3)
                        .foregroundStyle(.gray)

                    Text("\(viewModel.anaerobicTotalCount)번")
                        .font(.title)
                        .bold()
                }
                List(showAnaerobicAll ? viewModel.anaerobicCounts : Array(viewModel.anaerobicCounts.prefix(5)), id: \.name) { exercise in // 무산소 세부 운동 이름과, 횟수를 가져와야 합니당
                    NavigationLink {

                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(exercise.name)")
                                    .font(.callout)
                                HStack {
                                    ProgressView(value: Double(exercise.count), total: Double(viewModel.anaerobicMaxCount))
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
                if !showAnaerobicAll && viewModel.anaerobicCounts.count > 5 {
                    Button {
                        showAnaerobicAll = true
                    } label: {
                        if !showAnaerobicAll {
                            Label("더보기", systemImage: "plus")
                        }
                    }
                }
            }

            Section {
                VStack(alignment: .leading) {
                    Text("유산소 운동")
                        .font(.title3)
                        .foregroundStyle(.gray)

                    Text("\(viewModel.cardioTotalCount)번")
                        .font(.title)
                        .bold()
                }
                List(showCardioAll ? viewModel.cardioCounts : Array(viewModel.cardioCounts.prefix(5)), id: \.name) { exercise in
                    HStack {
                        NavigationLink {

                        } label: {
                            VStack(alignment: .leading) {
                                Text("\(exercise.name)")
                                    .font(.callout)
                                HStack {
                                    ProgressView(value: Double(exercise.count), total: Double(viewModel.cardioMaxCount))
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
                if !showCardioAll && viewModel.cardioCounts.count > 5 {
                    Button {
                        showCardioAll = true
                    } label: {
                            Label("더보기", systemImage: "plus")
                    }
                }
            }
        }
        // TODO: 문제는 처음 화면이 뜰 때 데이터를 받지 못함
        // TODO: 날짜를 넘겨줘야 할수도??
        .onChange(of: weekOrMonth) {
            viewModel.setData(retrospects: exampleList)
            showCardioAll = false
            showAnaerobicAll = false
        }
        .navigationTitle("통계")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CircularView: View {
    var category: Category
    var count: Int

    var body: some View {
        VStack {
            Text(category.rawValue)
                .bold()
                .padding(.bottom, 10)
            CircularProgressBarView(category: category, progress: Double(count) / 10.0, count: count)
        }
        .padding(30)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.black.opacity(0.04))
        }
    }
}

struct CircularProgressBarView: View {
    var category: Category
    var progress: Double = 0.0
    var count: Int = 0

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 12)
                .opacity(0.2)
                .foregroundColor(category.color.opacity(0.4))

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .foregroundColor(category.color)
                .rotationEffect(.degrees(-90))

            Text("\(count)건")
                .font(.title2)
                .bold()
        }
        .frame(width: 100, height: 100)
    }
}

#Preview {
    NavigationStack {
        StatisticsView()
    }
}
