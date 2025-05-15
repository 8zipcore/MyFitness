import SwiftUI

final class StatisticsViewModel: ObservableObject {
    @Published var periodTimes: [PeriodTime] = []
    @Published var anaerobicCounts: [ExerciseCount] = []
    @Published var cardioCounts: [ExerciseCount] = []
    @Published var anaerobicTotalCount: Int = 0
    @Published var cardioTotalCount: Int = 0
    @Published var anaerobicMaxCount: Int = 0
    @Published var cardioMaxCount: Int = 0
    @Published var exerciseDayCount: Int = 0
    @Published var totalSatisfaction: Double = 0.0
    @Published var categoryCountDict: [Category: Int] = [:]
    @Published var totalCategoryCount: Int = 0 // 비율로 계산해야 하기 때문에 Double

    @Published var weekOrMonth: WeekOrMonth = .week
    @Published var showAnaerobicAll: Bool = false
    @Published var showCardioAll: Bool = false

    @Published var selectedDate: Date = .now

    /// 만족도에 따른 컬러 반환 계산 속성입니다.
    var satisfactionColor: Color {
        switch totalSatisfaction {
        case 0...33:
            return .red
        case 34...66:
            return .yellow
        case 67...100:
            return .green
        default:
            return .green
        }
    }

    /// 해당 주의 첫 번째 요일로 초기화합니다.
    init() {
        if let startDate = Calendar.current.dateInterval(of: .weekOfYear, for: .now)?.start {
            self.selectedDate = startDate
        }
    }

    
    /// 날짜가 바뀌거나, 화면이 나타나면 호출되는 함수로, 선택된 날짜에 맞춰서 데이터를 필터링합니다.
    /// - Parameter retrospects: 회고 데이터 스키마를 받습니다.
    func setData(retrospects: [Retrospect]) {
        var filteredRetrospects: [Retrospect] = []
        if weekOrMonth == .week {
            weekDates(for: selectedDate).forEach { date in
                let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
                retrospects.forEach {
                    let retrospectComponents = Calendar.current.dateComponents([.year, .month, .day], from: $0.date)
                    if retrospectComponents.year == components.year && retrospectComponents.month == components.month && retrospectComponents.day == components.day {
                        filteredRetrospects.append($0)
                    }
                }
            }
        } else {
            let components = Calendar.current.dateComponents([.year, .month], from: selectedDate)
            filteredRetrospects = retrospects.filter {
                let retrospectComponents = Calendar.current.dateComponents([.year, .month], from: $0.date)
                if retrospectComponents.year == components.year && retrospectComponents.month == components.month {
                    return true
                } else {
                    return false
                }
            }
        }

        setPeriodTime(retrospects: filteredRetrospects)
        setCardioCount(retrospects: filteredRetrospects)
        setAnaerobicCount(retrospects: filteredRetrospects)
        setCardioTotalCount(retrospects: filteredRetrospects)
        setAnaerobicTotalCount(retrospects: filteredRetrospects)
        setTotalSatisfaction(retrospects: filteredRetrospects)
        setExerciseDayCount(retrospects: filteredRetrospects)
        setTotalCategoryCount(retrospects: filteredRetrospects)
        setCategoryCount(retrospects: filteredRetrospects)

        anaerobicMaxCount = anaerobicCounts.max { $0.count < $1.count }?.count ?? 0
        cardioMaxCount = cardioCounts.max { $0.count < $1.count }?.count ?? 0

        showAnaerobicAll = false
        showCardioAll = false
    }
}

// 통계 관련
extension StatisticsViewModel {
    /// CategoryPerCountView에서 사용하는 메소드이며, 카테고리를 정렬하여 반환합니다.
    func getSortedCategoryList() -> [(Category, Int)] {
		return Array(categoryCountDict).sorted { $0.value > $1.value }
    }

    
    /// Category별 개수를 딕셔너리로 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setCategoryCount(retrospects: [Retrospect]) {
        let allCategories = retrospects.flatMap { $0.category }

        self.categoryCountDict = allCategories.reduce(into: [:]) { tempDict, category in
            tempDict[category, default: 0] += 1
        }
    }
    
    /// Category의 총 개수를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setTotalCategoryCount(retrospects: [Retrospect]) {
        self.totalCategoryCount = retrospects.map { $0.category.count }.count
    }

    /// 오전, 오후, 새벽에 따른 시간을 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
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

    /// 무산소 세부 운동 총 횟수를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setAnaerobicTotalCount(retrospects: [Retrospect]) {
        self.anaerobicTotalCount = retrospects.map { $0.anaerobics.count }.reduce(0, +)
    }

    /// 유산소 세부 운동 총 횟수를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setCardioTotalCount(retrospects: [Retrospect]) {
        self.cardioTotalCount = retrospects.map { $0.cardios.count }.reduce(0, +)
    }

    /// 무산소 세부 운동 별로 리스트를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
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

    /// 유산소 세부 운동 별로 리스트를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
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

        self.cardioCounts = cardioCountList
    }

    
    /// 통계에서 나타낼 운동 만족도 평균을 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setTotalSatisfaction(retrospects: [Retrospect]) {
        self.totalSatisfaction = Double(retrospects.map { Int($0.satisfaction) }.reduce(0, +)) / Double(retrospects.count)
    }

    /// 통계에서 나타낼 운동 총 횟수를 저장합니다.
    /// - Parameter retrospects: 날짜에 맞게 필터링된 회고 데이터 스키마를 받습니다.
    private func setExerciseDayCount(retrospects: [Retrospect]) {
        self.exerciseDayCount = retrospects.count
    }
}

/// 날짜 관련
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

        var weekWorkoutTimes: [Int: [Int]] = [:]
        
        // 선택된 날짜와 같은 연도, 같은 월일때
        retrospects.forEach {
            if isSameYearAndMonth($0.date, selectedDate) {
                let week = Calendar.current.component(.weekOfMonth, from: $0.date) // TODO: 달 데이터 가져오기 (활용 예정)
                weekWorkoutTimes[week, default: []].append(Int($0.finishTime.timeIntervalSince($0.startTime)) / 60)
            }
        }
        
        let lastWeeks = selectedDate.weeksInMonth()

        for index in 1...lastWeeks {
            var workoutTimeData = WorkoutTimeData(week: "\(index)주", time: 0)

            if let times = weekWorkoutTimes[index] {
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
