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

// 통계뷰
struct StatisticsView: View {
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var viewModel = StatisticsViewModel()

    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    private var retrospects: [Retrospect]

    var body: some View {
        TitleView(viewModel: viewModel)

        Form {
            Picker("기간", selection: $viewModel.weekOrMonth) {
                ForEach(WeekOrMonth.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Section {
                ExerciseDayView(viewModel: viewModel)
            }

            Section {
                WorkoutTimeChartView(
                    viewModel: viewModel,
                    retrospects: retrospects,
                    weekOrMonth: viewModel.weekOrMonth
                )
            }

            Section {
                PeriodStatisticsView(viewModel: viewModel)
            }

            Section {
                HStack {
                    Spacer()
                    SatisfactionAverageView(viewModel: viewModel)
                    Spacer()
                }
            }

            Section {
                CategoryPerCountView(viewModel: viewModel)
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
                List(viewModel.showAnaerobicAll ? viewModel.anaerobicCounts : Array(viewModel.anaerobicCounts.prefix(5)), id: \.name) { exercise in // 무산소 세부 운동 이름과, 횟수를 가져와야 합니당

                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(exercise.name)")
                                .font(.callout)
                            HStack {
                                ProgressView(value: Double(exercise.count), total: Double(viewModel.anaerobicMaxCount))
                                    .accentColor(.green)
                                    .background(.clear)
                                Text("\(exercise.count)번")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }

                        }

                    }
                }
                if !viewModel.showAnaerobicAll && viewModel.anaerobicCounts.count > 5 {
                    Button {
                        viewModel.showAnaerobicAll = true
                    } label: {
                        if !viewModel.showAnaerobicAll {
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
                List(viewModel.showCardioAll ? viewModel.cardioCounts : Array(viewModel.cardioCounts.prefix(5)), id: \.name) { exercise in
                    HStack {

                        VStack(alignment: .leading) {
                            Text("\(exercise.name)")
                                .font(.callout)
                            HStack {
                                ProgressView(value: Double(exercise.count), total: Double(viewModel.cardioMaxCount))
                                    .accentColor(.green)
                                    .background(.clear)
                                Text("\(exercise.count)번")
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }

                        }
                    }
                }
                if !viewModel.showCardioAll && viewModel.cardioCounts.count > 5 {
                    Button {
                        viewModel.showCardioAll = true
                    } label: {
                        Label("더보기", systemImage: "plus")
                    }
                }
            }
        }
        .onChange(of: viewModel.selectedDate) {
            viewModel.setData(retrospects: retrospects)
        }
        .onChange(of: viewModel.weekOrMonth) {
            viewModel.setData(retrospects: retrospects)
        }
        .onAppear {
            viewModel.setData(retrospects: retrospects)
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
