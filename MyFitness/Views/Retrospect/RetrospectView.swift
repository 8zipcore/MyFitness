import SwiftUI
import SwiftData

/// 회고 생성, 수정, 삭제 메인 화면
struct RetrospectView: View {
    // MARK: SwiftData Context
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel: RetrospectWriteViewModel
    @FocusState private var isFocused: Bool

    var isCreate: Bool = false
    /// RetrospectView 생성자
    /// - Parameters:
    ///   - isCreated: 최초 생성인지 수정인지 Bool값으로 받습니다.
    ///   - retrospect: 만약 수정이라면 회고 데이터를 전달받습니다.
    ///   - date: 최소 생성이라면 Date를 전달받고, 수정이라면 전달받지 않습니다.
    init(retrospect: Retrospect? = nil, date: Date = .now) {
        if let retrospect = retrospect {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel(retrospect: retrospect))
            isCreate = false
        } else {
            _viewModel = StateObject(wrappedValue: RetrospectWriteViewModel(date: date))
            isCreate = true
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
                        AnaerobicCreateView(anaerobic: $anaerobic)
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
                        CardioCreateView(cardio: $cardio)
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
                VStack {
                    HStack {
                        Text("금일 운동은 어땠나요?")
                        Spacer()
                        Text("\(Int(viewModel.retrospect.satisfaction))%")
                    }


                    Slider(value: $viewModel.retrospect.satisfaction, in: 0...100, step: 5)
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
        .alert("", isPresented: $viewModel.isDelete) {
            Button(role: .destructive) {
                viewModel.delete(context: context)
                dismiss()
            } label: {
                Text("삭제")
            }

            Button(role: .cancel) {

            } label: {
                Text("취소")
            }
        } message: {
            Text("정말로 삭제하시겠습니까?")
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
                        viewModel.isDelete = true
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

// MARK: - Preview
#Preview("수정 화면") {
    NavigationStack {
        RetrospectView(retrospect: Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(name: "데드 리프트", weight: 65, count: 10, set: 5)], cardios: [Cardio(name: "런닝", minutes: 30)], startTime: .now, finishTime: .now, satisfaction: 50, writing: "감사합니다", bookMark: false))
    }
}

#Preview("생성 화면") {
    NavigationStack {
        RetrospectView()
    }
}

