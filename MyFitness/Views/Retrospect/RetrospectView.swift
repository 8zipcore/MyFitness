//
//  Retrospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import SwiftUI
import SwiftData

final class RetrospectWriteViewModel: ObservableObject {
    @Published var retrospect: Retrospect
    @Published var isInvalidDate: Bool = false
    @Published var isInvalidExercise: Bool = false

    /// 최초 생성시에 사용되는 생성자입니다.
    convenience init() {
        self.init(retrospect: Retrospect(
            date: Date.now,
            category: [],
            anaerobics: [],
            cardios: [],
            startTime: Date.now,
            finishTime: Date.now,
            satisfaction: 0,
            writing: "",
            bookMark: false
        ))
    }

    /// 수정시에 사용되는 생성자입니다.
    /// - Parameter retrospect: 기존에 존재하는 회고 데이터를 받아옵니다.
    init(retrospect: Retrospect) {
        self.retrospect = retrospect
    }

    
    /// 오후에서 오전으로 넘어가는 날에 하루가 추가되도록 합니다.
    func checkPMtoAMTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        formatter.locale = Locale(identifier: "ko_kr")
        let startDate = formatter.string(from: retrospect.startTime)
        let finishDate = formatter.string(from: retrospect.finishTime)

        if ((startDate == "오후" && finishDate == "오전") && !isValidDate()) { // startDate가 finishDate보다 큰 경우에만 발생해야 함.
            if let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: retrospect.finishTime) {
                retrospect.finishTime = tomorrow
            }
        }
    }

    /// 날짜 차이에 따라서 Bool값을 반환합니다.
    func isValidDate() -> Bool {
        return retrospect.startTime <= retrospect.finishTime
    }

    /// 운동 입력에서 입력을 하지 않음에 따라서 Bool값을 반환합니다.
    func isValidExercise() -> Bool {
        for anaerobic in retrospect.anaerobics {
            if anaerobic.exercise.name.isEmpty { return false }
        }

        for cardio in retrospect.cardios {
            if cardio.exercise.name.isEmpty { return false }
        }

        return true
    }

    /// 명시적으로 데이터를 저장합니다.
    /// - Parameter context: DB를 조작할 수 있는 객체입니다.
    func save(context: ModelContext) {
        try? context.save()
    }
}

struct RetrospectView: View {
    // MARK: SwiftData Context
    @Environment(\.modelContext) var context

    @StateObject var viewModel: RetrospectWriteViewModel

    @State private var categoryList: [Category] = Category.allCases
    @FocusState private var isFocused: Bool

    let isCreate: Bool

    /// RetrospectView 생성자
    /// - Parameters:
    ///   - isCreated: 최초 생성인지 수정인지 Bool값으로 받습니다.
    ///   - retrospect: 만약 수정이라면 회고 데이터를 전달받습니다.
    init(isCreate: Bool, retrospect: Retrospect? = nil) {
        if let retrospect = retrospect {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel(retrospect: retrospect))
        } else {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel())
        }

        self.isCreate = isCreate
    }

    var body: some View {
        Form {
            Section("카테고리") {
                List($categoryList, id: \.self) { category in
                    HStack {
                        Text(category.wrappedValue.rawValue)
                        Spacer()
                        if viewModel.retrospect.category.contains(category.wrappedValue) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // 제스쳐 범위 늘리기
                    .onTapGesture {
                        if viewModel.retrospect.category.contains(category.wrappedValue) {
                            viewModel.retrospect.category = viewModel.retrospect.category.filter { $0 != category.wrappedValue }
                        } else {
                            viewModel.retrospect.category.append(category.wrappedValue)
                        }
                    }
                }
            }

            Section("무산소 운동") {
                List {
                    ForEach($viewModel.retrospect.anaerobics) { $anaerobic in
                        AnaerobicView(anaerobic: $anaerobic)
                    }
                    .onDelete { indexPath in
                        viewModel.retrospect.anaerobics.remove(atOffsets: indexPath)
                    }
                }

                Button {
                    viewModel.retrospect.anaerobics.append(Anaerobic.emptyData())
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }

            Section("유산소 운동") {
                List {
                    ForEach($viewModel.retrospect.cardios) { $cardio in
                        CardioView(cardio: $cardio)
                    }
                    .onDelete { indexPath in
                        viewModel.retrospect.cardios.remove(atOffsets: indexPath)
                    }
                }
                Button {
                    viewModel.retrospect.cardios.append(Cardio.emptyData())
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }
            Section("성취도") {
                HStack {
                    VStack {
                        HStack {
                            Text("금일 운동은 어땠나요?")
                            Spacer()
                            Text("\(Int(viewModel.retrospect.satisfaction))%")
                        }
                    }
                }
            }

            Section("운동 시간") {
                VStack(spacing: 8) {
                    HStack {
                        Text("시작 시간")
                        Spacer()
                        DatePicker("시간 선택", selection: $viewModel.retrospect.startTime, displayedComponents:
                                .hourAndMinute)
                        	.datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }
                    Divider()
                    HStack {
                        Text("종료 시간")
                        Spacer()
                        DatePicker("시간 선택", selection: $viewModel.retrospect.finishTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }

                }
            }
            Section("회고") {
                TextEditor(text: $viewModel.retrospect.writing)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                    .frame(minHeight: 150)
                    .overlay {
                        if !isFocused && viewModel.retrospect.writing.isEmpty {
                            Text("금일 운동의 회고를 적어주세요!")
                                .foregroundStyle(.gray)
                        }
                    }
            }
        }
        .alert("경고", isPresented: $viewModel.isInvalidDate) {
            Button("확인") {

            }
        } message: {
            Text("운동 시간이 잘못 입력되었습니다.")
        }
        .alert("경고", isPresented: $viewModel.isInvalidExercise) {
            Button("확인") {

            }
        } message: {
            Text("선택되지 않는 운동이 존재합니다.")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.checkPMtoAMTime()

                    guard viewModel.isValidDate() else {
                        viewModel.isInvalidDate = true
                        return
                    }

                    guard viewModel.isValidExercise() else {
                        viewModel.isInvalidExercise = true
                        return
                    }

                    if isCreate {
						// MARK: Retrospect 데이터 Create
                        context.insert(viewModel.retrospect)
                    }

                    viewModel.save(context: context)
                } label: {
                    Text(isCreate == true ? "저장" : "수정")
                }
            }
        }
        .navigationTitle("운동 기록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// 무산소 운동을 추가할 때 나타나는 화면
struct AnaerobicView: View {
    @Binding var anaerobic: Anaerobic
    @State private var showSearchView: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(anaerobic.exercise.name == "" ? "운동명" : anaerobic.exercise.name)
                    .foregroundStyle(.gray)
                Spacer()
            }
            .contentShape(Rectangle()) // 제스쳐 범위 늘리기
            .onTapGesture {
                showSearchView = true
            }

            Divider()

            HStack {
                Picker("", selection: $anaerobic.weight) {
                    ForEach(Array(stride(from: 0, through: 200, by: 5)), id: \.self) { number in
                        Text("\(number)")
                    }
                }

                Text("Kg")

                Picker("", selection: $anaerobic.set) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }

                }

                Text("세트")

                Picker("", selection: $anaerobic.count) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                Text("회")

                Spacer()
            }
        }
        .sheet(isPresented: $showSearchView) {
            NavigationStack {
                SearchExerciseView(name: $anaerobic.exercise.name)
            }
        }
    }
}

/// 유산소 운동을 추가할 때 나타나는 화면
struct CardioView: View {
    @Binding var cardio: Cardio
    @State private var showSearchView: Bool = false

    var body: some View {
        HStack {
            Text(cardio.exercise.name == "" ? "운동명" : cardio.exercise.name)
                .foregroundStyle(.gray)
                .onTapGesture {
                    print("show")
                    showSearchView = true
                }
            Spacer()
            Picker("", selection: $cardio.minutes) {
                ForEach(0..<200, id: \.self) { number in
                    Text("\(number)")
                }
            }
            Text("분")
        }
        .sheet(isPresented: $showSearchView) {
            NavigationStack {
                SearchExerciseView(name: $cardio.exercise.name)
            }
        }
    }
}


/// 유저가 세부 운동을 검색할 수 있는 화면
struct SearchExerciseView: View {
    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)])
    var exercises: [Exercise]

    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @State var keyword: String = ""
    @Binding var name: String

    var filteredExercise: [Exercise] {
        if keyword.isEmpty {
            return exercises
        }

        return exercises.filter {
            $0.name.lowercased().contains(keyword.lowercased())
        }
    }

    var body: some View {
        List {
            Section {
                addCustomExerciseView()
            }

            ForEach(filteredExercise) { exercise in
                Text(exercise.name)
                    .onTapGesture {
                        name = exercise.name
                        dismiss()
                    }
            }
            .onDelete { indexSet in
                // MARK: Exercise 데이터 Delete
                for index in indexSet {
                    context.delete(exercises[index])
                }
            }
        }
        .navigationTitle("운동 검색")
        .searchable(text: $keyword, prompt: "운동을 검색하세요")
    }
}

/// 유저가 직접 운동을 추가할 수 있는 화면
struct addCustomExerciseView: View {
    @State private var exerciseLabel: String = ""
    @Environment(\.modelContext) var context

    var body: some View {
        HStack {
            TextField("원하시는 운동을 추가 하세요", text: $exerciseLabel)
            Spacer()
            Button {
                // MARK: Exercise 데이터 Insert
                guard !exerciseLabel.isEmpty else { return }
                let exercise = Exercise(name: exerciseLabel)
                context.insert(exercise)
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: - Preview
#Preview("수정 화면") {
    NavigationStack {
        RetrospectView(isCreate: false, retrospect: Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(exercise: Exercise(name: "데드 리프트"), weight: 65, count: 10, set: 5)], cardios: [Cardio(exercise: Exercise(name: "런닝머신"), minutes: 30)], startTime: .now, finishTime: .now, satisfaction: 50.0, writing: "감사합니다", bookMark: false))
    }
}

#Preview("생성 화면") {
    NavigationStack {
        RetrospectView(isCreate: true)
    }
}

#Preview("SearchExerciseView") {
    let container: ModelContainer = {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Exercise.self, configurations: config)

        let exercise1 = Exercise(name: "벤치 프레스")
        let exercise2 = Exercise(name: "데드 리프트")
        let exercise3 = Exercise(name: "스쿼트")

        container.mainContext.insert(exercise1)
        container.mainContext.insert(exercise2)
        container.mainContext.insert(exercise3)

        return container
    }()

    NavigationStack {
        SearchExerciseView(name: .constant("테스트"))
            .modelContainer(container)
    }
}
//

