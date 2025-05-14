//
//  Retrospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import SwiftUI
import SwiftData

// TODO: 슬라이더
// TODO: 수정이 잘 안될 가능성이 있음 안된다면 리팩토링 예정

/// 회고 생성, 수정, 삭제 메인 화면
struct RetrospectView: View {
    // MARK: SwiftData Context
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: RetrospectWriteViewModel
    @FocusState private var isFocused: Bool

    let isCreate: Bool

    /// RetrospectView 생성자
    /// - Parameters:
    ///   - isCreated: 최초 생성인지 수정인지 Bool값으로 받습니다.
    ///   - retrospect: 만약 수정이라면 회고 데이터를 전달받습니다.
    ///   - date: 최소 생성이라면 Date를 전달받고, 수정이라면 전달받지 않습니다.
    init(isCreate: Bool, retrospect: Retrospect? = nil, date: Date? = nil) {
        self.isCreate = isCreate

        if let retrospect = retrospect {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel(retrospect: retrospect))
        } else {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel())
        }

        if let date = date {
            viewModel.retrospect.date = date
        }
    }

    var body: some View {
        Form {
            Section("카테고리") {
                List($viewModel.categoryList, id: \.self) { category in
                    HStack {
                        Text(category.wrappedValue.rawValue)
                        Spacer()
                        if viewModel.retrospect.category.contains(category.wrappedValue) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle())
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
                    Text("금일 운동은 어땠나요?")
                    Spacer()
                    Picker("", selection: $viewModel.retrospect.satisfaction) {
                        ForEach(Array(stride(from: 0, through: 100, by: 10)), id: \.self) { number in
                            Text("\(number)%")
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
                            .datePickerStyle(.graphical)
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }
                }
            }
            Section("회고") {
                TextEditor(text: $viewModel.retrospect.writing)
                    .submitLabel(.continue)
                    .autocorrectionDisabled(false)
                    .textInputAutocapitalization(.never)
                    .focused($isFocused)
                    .onSubmit {
                        isFocused = false
                    }
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
            Text("선택하지 않은 운동이 존재합니다.")
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
                        viewModel.insert(context: context)
                    }
					// MARK: Retrospect 명시적 저장
                    viewModel.save(context: context)
                    dismiss()
                } label: {
                    Text(isCreate == true ? "저장" : "수정")
                }
            }

            if !isCreate {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        // MARK: Retrospect 데이터 삭제
                        viewModel.delete(context: context)
                        dismiss()
                    } label: {
                        Text("삭제")
                            .foregroundStyle(.red)
                    }
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
                SearchExerciseView(name: $anaerobic.exercise.name, exerciseType: .anaerobic)
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
                SearchExerciseView(name: $cardio.exercise.name, exerciseType: .cardio)
            }
        }
    }
}

/// 유저가 세부 운동을 검색할 수 있는 화면
struct SearchExerciseView: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @Query(sort: [SortDescriptor(\Exercise.name, order: .forward)])
    var exercises: [Exercise]

    @State var keyword: String = ""
    @Binding var name: String

    let exerciseType: ExerciseType

    var filteredExercise: [Exercise] {
        if keyword.isEmpty {
            return exercises.filter { $0.exerciseType == exerciseType }
        }

        return exercises.filter {
            $0.exerciseType == exerciseType && $0.name.lowercased().contains(keyword.lowercased())
        }
    }

    var body: some View {
        List {
            Section {
                addCustomExerciseView(exerciseType: exerciseType)
            }

            ForEach(filteredExercise) { exercise in
                HStack {
                    Text(exercise.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                }
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
        .searchable(text: $keyword, prompt: "\(exerciseType == .cardio ? "유산소" : "무산소") 운동을 검색하세요")
    }
}

/// 유저가 직접 운동을 추가할 수 있는 화면
struct addCustomExerciseView: View {
    @Environment(\.modelContext) var context

    @State private var exerciseLabel: String = ""

    let exerciseType: ExerciseType

    var body: some View {
        HStack {
            TextField("원하시는 운동을 추가 하세요", text: $exerciseLabel)
            Spacer()
            Button {
                // MARK: Exercise 데이터 Insert
                guard !exerciseLabel.isEmpty else { return }
                let exercise = Exercise(name: exerciseLabel, exerciseType: exerciseType)
                context.insert(exercise)
                exerciseLabel = ""
            } label: {
                Image(systemName: "plus")
            }
        }
    }
}

// MARK: - Preview
#Preview("수정 화면") {
    NavigationStack {
        RetrospectView(isCreate: false, retrospect: Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(exercise: Exercise(name: "데드 리프트", exerciseType: .anaerobic), weight: 65, count: 10, set: 5)], cardios: [Cardio(exercise: Exercise(name: "런닝머신", exerciseType: .cardio), minutes: 30)], startTime: .now, finishTime: .now, satisfaction: 50, writing: "감사합니다", bookMark: false))
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

        let exercise1 = Exercise(name: "벤치 프레스", exerciseType: .anaerobic)
        let exercise2 = Exercise(name: "데드 리프트", exerciseType: .anaerobic)
        let exercise3 = Exercise(name: "스쿼트", exerciseType: .anaerobic)

        container.mainContext.insert(exercise1)
        container.mainContext.insert(exercise2)
        container.mainContext.insert(exercise3)

        return container
    }()

    NavigationStack {
        SearchExerciseView(name: .constant("테스트"), exerciseType: .cardio)
            .modelContainer(container)
    }
}

