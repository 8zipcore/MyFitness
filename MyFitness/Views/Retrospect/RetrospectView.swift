//
//  Retrospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import SwiftUI
import SwiftData

// 무산소 운동 ->

struct RetrospectView: View {
	// MARK: SwiftData Context
    @Environment(\.modelContext) var context

    // MARK: retrospect가 nil이면 생성, 존재한다면 수정 로직을 진행합니다.
    var retrospect: Retrospect?

    @State private var anaerobics: [Anaerobic] = []
    @State private var cardios: [Cardio] = []
    @State private var satisfaction: Int = 0
    @State private var startTime: Date = .now
    @State private var finishTime: Date = .now
    @State private var writing: String = ""
    @State private var categoryList: [Category] = Category.allCases
    @State private var selectedCategoryList: [Category] = []

    var body: some View {
        Form {
            Section("카테고리") {
                List($categoryList, id: \.self) { category in
                    HStack {
                        Text(category.wrappedValue.rawValue)
                        Spacer()
                        if selectedCategoryList.contains(category.wrappedValue) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.blue)
                        }
                    }
                    .contentShape(Rectangle()) // 제스쳐 범위 늘리기
                    .onTapGesture {
                        if selectedCategoryList.contains(category.wrappedValue) {
                            selectedCategoryList = selectedCategoryList.filter { $0 != category.wrappedValue }
                        } else {
                            selectedCategoryList.append(category.wrappedValue)
                        }
                    }
                }
            }

            Section("무산소 운동") {
                List {
                    ForEach($anaerobics) { $anaerobic in
                        AnaerobicView(anaerobic: $anaerobic)
                    }
                    .onDelete { indexPath in
                        anaerobics.remove(atOffsets: indexPath)
                    }
                }

                Button {
                    anaerobics.append(Anaerobic(exercise: Exercise(name: ""), weight: 0, count: 0, set: 0))
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }
            Section("유산소 운동") {
                List {
                    ForEach($cardios) { $cardio in
                        CardioView(cardio: $cardio)
                    }
                    .onDelete { indexPath in
                        cardios.remove(atOffsets: indexPath)
                    }
                }
                Button {
                    cardios.append(Cardio(exercise: Exercise(name: ""), minutes: 0))
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }
            Section("성취도") {
                HStack {
                    Text("금일 운동은 어땠나요?")
                    Spacer()
                    Picker("", selection: $satisfaction) {
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
                        DatePicker("시간 선택", selection: $startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }
                    Divider()
                    HStack {
                        Text("종료 시간")
                        Spacer()
                        DatePicker("시간 선택", selection: $finishTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }

                }
            }

            Section("회고") {
                TextEditor(text: $writing)
                    .frame(minHeight: 150)
            }

            Section {
                HStack {
                    Spacer()
                    Text(retrospect == nil ? "저장" : "수정")
                        .foregroundStyle(.blue)
                    Spacer()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // MARK: 저장할 때 운동 시간 검증을 해야 합니다.
                    // MARK: 운동명을 기입했는지 검증을 해야 합니다.
                    // MARK: nil로 선언할 수 있는게 필요한가?
                    // MARK: 저장 및 수정을 분기해야 합니다.
                    let retrospect = Retrospect(
                        date: .now,
                        category: selectedCategoryList,
                        anaerobics: anaerobics,
                        cardios: cardios,
                        startTime: startTime,
                        finishTime: finishTime,
                        satisfaction: Double(satisfaction),
                        writing: writing,
                        bookMark: false
                    )

                    print(
                        retrospect.category,
                        retrospect.anaerobics,
                        retrospect.cardios,
                        retrospect.startTime,
                        retrospect.finishTime,
                        retrospect.satisfaction,
                        retrospect.writing,
                        retrospect.bookMark
                    )
                } label: {
                    Text(retrospect == nil ? "저장" : "수정")
                }
            }
        }
        .navigationTitle("운동 기록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: 무산소 View
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

// MARK: 유산소 View
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

// MARK: 운동 검색 View
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
            ForEach(filteredExercise) { exercise in
                Text(exercise.name)
                    .onTapGesture {
                        print(exercise.name)
                        name = exercise.name
                        dismiss()
                    }
            }
        }
        .navigationTitle("운동 검색")
        .searchable(text: $keyword, prompt: "운동을 검색하세요")
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        RetrospectView()
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


