import SwiftUI

enum CalendarDirection {
    case previous
    case next
}

final class StatisticsViewModel: ObservableObject {
    @Published var periodTimes: [PeriodTime] = []
    @Published var anaerobicCounts: [ExerciseCount] = []
    @Published var cardioCounts: [ExerciseCount] = []
    @Published var anaerobicTotalCount: Int = 0
    @Published var cardioTotalCount: Int = 0
    @Published var anaerobicMaxCount: Int = 0
    @Published var cardioMaxCount: Int = 0

    @Published var selectedDate: Date = .now

    init() {
        /// 해당 주의 첫번째 요일로 초기화
        if let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.start {
            self.selectedDate = startDate
        }
    }

    func setData(retrospects: [Retrospect]) {
        setPeriodTime(retrospects: retrospects)
        setCardioCount(retrospects: retrospects)
        setAnaerobicCount(retrospects: retrospects)
        setCardioTotalCount(retrospects: retrospects)
        setAnaerobicTotalCount(retrospects: retrospects)

        anaerobicMaxCount = anaerobicCounts.max { $0.count < $1.count }?.count ?? 0
        cardioMaxCount = cardioCounts.max { $0.count < $1.count }?.count ?? 0
    }

    func getCategoryCount(retrospects: [Retrospect], category: Category) -> Int {
        return retrospects.flatMap { $0.category.filter { $0 == category } }.count
    }

    private func setPeriodTime(retrospects: [Retrospect]) {
        let calendar = Calendar.current

        let grouped = Dictionary(grouping: retrospects) { retrospect -> Period in
            let hour = calendar.component(.hour, from: retrospect.startTime)
            switch hour {
            case 0..<8:
                return .evening
            case 8..<16:
                return .morning
            default:
                return .dayTime
            }
        }

        let periodTimes = Period.allCases.map {
            PeriodTime(period: $0, count: grouped[$0]?.count ?? 0)
        }

        self.periodTimes = periodTimes
    }

    private func setAnaerobicTotalCount(retrospects: [Retrospect]) {
        self.anaerobicTotalCount = retrospects.map { $0.anaerobics.map { $0.name }.count }.count
    }

    private func setCardioTotalCount(retrospects: [Retrospect]) {
        self.cardioTotalCount = retrospects.map { $0.cardios.map { $0.name }.count }.count
    }

    private func setAnaerobicCount(retrospects: [Retrospect]) {
        var anaerobicCountList: [ExerciseCount] = []
        retrospects.flatMap { $0.anaerobics }.map { $0.name }.reduce(into: [:]) { results, name in
            results[name, default: 0] += 1
        }
        .sorted {
            $0.value > $1.value
        }
        .forEach {
            anaerobicCountList.append(ExerciseCount(name: $0.key, count: $0.value))
        }

        self.anaerobicCounts = anaerobicCountList
    }

    private func setCardioCount(retrospects: [Retrospect]) {
        var cardioCountList: [ExerciseCount] = []
        retrospects.flatMap { $0.cardios }.map { $0.name }.reduce(into: [:]) { results, name in
            results[name, default: 0] += 1
        }
        .sorted {
            $0.value > $1.value
        }
        .forEach {
            cardioCountList.append(ExerciseCount(name: $0.key, count: $0.value))
        }

        self.cardioCounts = anaerobicCounts
    }
}

extension StatisticsViewModel {
    /// 날짜를 String으로 변환하는 함수입니다.
    func dateToString(type: WeekOrMonth) -> String {
        let calendar = Calendar.current

        switch type {
        case .week:
            guard let interval = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else {
                return ""
            }

            let startDate = interval.start
            guard let endDate = calendar.date(byAdding: .day, value: -1, to: interval.end) else { return "" }

            let startYear = calendar.component(.year, from: startDate)
            let endYear = calendar.component(.year, from: endDate)
            let startMonth = calendar.component(.month, from: startDate)
            let endMonth = calendar.component(.month, from: endDate)
            let lastDay = calendar.component(.day, from: endDate)

            if startYear == endYear {
                if startMonth == endMonth { // ex) 2025년 5월 10일 ~ 17일
                    return "\(startDate.toString()) ~ \(lastDay)일"
                } else { // ex) 2025년 4월 27일 ~ 5월 4일
                    return "\(startDate.toString()) ~ \(endMonth)월 \(lastDay)일"
                }
            } else { // ex) 2024년 12월 31일 ~ 2025년 1월 7일
                return "\(startDate.toString()) ~ \(endDate.toString())"
            }
        case .month:
            return selectedDate.toYearMonthString()
        }
    }
    /// selectedDate를 변환해주는 함수입니다.
    func changeDate(type: WeekOrMonth, direction: CalendarDirection) {
        let calendar = Calendar.current

        switch type {
        case .week:
            let value = direction == .previous ? -7 : 7
            selectedDate = calendar.date(byAdding: .day, value: value, to: selectedDate) ?? .now
        case .month:
            let value = direction == .previous ? -1 : 1
            selectedDate = calendar.date(byAdding: .month, value: value, to: selectedDate) ?? .now
        }
    }
    /// 선택한 날짜와 현재 날짜의 동일여부를 반환해주는 함수입니다.
    func isCurrent(type: WeekOrMonth) -> Bool {
        let calendar = Calendar.current

        switch type {
        case .week:
            guard let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.start,
                  let selectedDate = Calendar.current.dateInterval(of: .weekOfYear, for: selectedDate)?.start else {
                return false
            }
            return calendar.isDate(startDate, inSameDayAs: selectedDate)
        case .month:
            let currentYear = calendar.component(.year, from: .now)
            let currentMonth = calendar.component(.month, from: .now)

            let targetYear = calendar.component(.year, from: selectedDate)
            let targetMonth = calendar.component(.month, from: selectedDate)

            return currentYear == targetYear && currentMonth == targetMonth
        }
    }
}
/// 운동 시간 관련
extension StatisticsViewModel {
    /// 운동시간 데이터를 반환합니다.
    func workoutTimes(from retrospects: [Retrospect], type: WeekOrMonth) -> [WorkoutTimeData] {
        switch type {
        case .week:
            fetchWorkoutTimesForWeeks(from: retrospects)
        case .month:
            fetchWorkoutTimesForMonth(from: retrospects)
        }
    }
    /// 주별 운동시간 데이터를 반환합니다.
    func fetchWorkoutTimesForWeeks(from retrospects: [Retrospect]) -> [WorkoutTimeData] {
        var workoutTimeDatas: [WorkoutTimeData] = []

        let weekDates: [Date] = weekDates(for: selectedDate)
        let weekString = ["일", "월", "화", "수", "목", "금", "토"]

        for index in weekString.indices {
            var workoutTimeData = WorkoutTimeData(week: weekString[index], time: 0)

            if let retrospect = retrospects.filter({ Calendar.current.isDate($0.date, inSameDayAs: weekDates[index]) }).first {
                let time = Int(retrospect.finishTime.timeIntervalSince(retrospect.startTime) / 60)
                workoutTimeData.time = time
            }

            workoutTimeDatas.append(workoutTimeData)
        }
        return workoutTimeDatas
    }
    /// 월별 운동시간 데이터를 반환합니다.
    func fetchWorkoutTimesForMonth(from retrospects: [Retrospect]) -> [WorkoutTimeData] {
        var workoutTimeDatas: [WorkoutTimeData] = []

        var monthWorkoutTimes: [Int: [Int]] = [:]

        // 선택된 날짜와 같은 연도, 같은 월일때
        retrospects.forEach {
            if isSameYearAndMonth($0.date, selectedDate) {
                let month = Calendar.current.component(.month, from: selectedDate)
                monthWorkoutTimes[month, default: []].append(Int($0.finishTime.timeIntervalSince($0.startTime)) / 60)
            }
        }

        for index in 1...12 {
            var workoutTimeData = WorkoutTimeData(week: "\(index)월", time: 0)

            if let times = monthWorkoutTimes[index] {
                workoutTimeData.time = times.reduce(0, +) / times.count
            }

            workoutTimeDatas.append(workoutTimeData)
        }
        return workoutTimeDatas
    }
    /// 입력받은 Date에 해당하는 주의 모든 Date를 반환하는 함수입니다.
    func weekDates(for date: Date) -> [Date] {
        let calendar = Calendar.current

        guard let interval = calendar.dateInterval(of: .weekOfYear, for: date) else {
            return []
        }

        let startOfWeek = interval.start
        let endOfWeek = interval.end

        var weekDates: [Date] = []

        var currentDate = startOfWeek
        while currentDate < endOfWeek {
            weekDates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }

        return weekDates
    }
}

