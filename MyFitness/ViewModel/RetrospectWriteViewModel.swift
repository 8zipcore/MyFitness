import SwiftUI
import SwiftData

/// 회고 생성, 수정, 삭제 화면의 ViewModel
final class RetrospectWriteViewModel: ObservableObject {
    @Published var retrospect: Retrospect
    @Published var isInvalidDate: Bool = false
    @Published var isInvalidExercise: Bool = false
    @Published var categoryList: [Category] = Category.allCases

    /// 최초 생성시에 사용되는 생성자입니다.
    convenience init(date: Date = .now) {
        self.init(retrospect: Retrospect(
            date: date,
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

        if ((startDate == "오후" && finishDate == "오전") && !isValidDate()) {
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
            if anaerobic.name.isEmpty { return false }
        }

        for cardio in retrospect.cardios {
            if cardio.name.isEmpty { return false }
        }

        return true
    }

    // MARK: - DataBase 관련 작업
    /// 명시적으로 데이터를 저장합니다.
    /// - Parameter context: DB를 조작할 수 있는 객체입니다.
    func save(context: ModelContext) {
        try? context.save()
        print(retrospect.anaerobics.count, retrospect.cardios.count)
    }

    /// 데이터를 삭제합니다.
    /// - Parameter context: DB를 조작할 수 있는 객체입니다.
    func delete(context: ModelContext) {
        context.delete(retrospect)
    }
    
    /// 데이터를 삽입합니다.
    /// - Parameter context: DB를 조작할 수 있는 객체입니다.
    func insert(context: ModelContext) {
        context.insert(retrospect)
    }
}
