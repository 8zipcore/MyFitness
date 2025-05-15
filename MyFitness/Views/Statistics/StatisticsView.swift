import SwiftUI
import SwiftData
import Charts

// 통계뷰
struct StatisticsView: View {
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var viewModel = StatisticsViewModel()

    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    private var retrospects: [Retrospect]
    let backgroundColor: Color

    var body: some View {
        VStack(spacing: 0) {
            TitleView(viewModel: viewModel)
            
            Form {
                Picker("기간", selection: $viewModel.weekOrMonth) {
                    ForEach(WeekOrMonth.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical)
                
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
        }
        .navigationTitle("통계")
        .navigationBarTitleDisplayMode(.inline)
        .background(backgroundColor)
    }
}


#Preview {
    NavigationStack {
        StatisticsView(backgroundColor: .white)
    }
}
