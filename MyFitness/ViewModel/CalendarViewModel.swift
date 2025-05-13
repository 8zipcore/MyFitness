//
//  CalendarViewModel.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

/// MainView에 표시되는 캘린더 데이터를 관리하는 ViewModel입니다.
class CalendarViewModel: ObservableObject {
    /// 달력에서 월의 위치를 나타내는 열거형입니다.
    ///
    /// 이 열거형은 현재 달력을 기준으로 이전 달, 현재 달, 다음 달을 구분할 때 사용됩니다.
    enum MonthType {
        case previos, current, next
        
        var value: Int {
            switch self {
            case .previos:
                return -1
            case .current:
                return 0
            case .next:
                return 1
            }
        }
    }
    /// 현재 선택된 날짜입니다.
    ///
    /// 캘린더에서 사용자가 선택한 날짜를 나타내며,
    /// 이 값을 기준으로 회고 데이터를 필터링합니다.
    @Published var selectedDate: Date
    // 달력에 표시되는 날짜입니다.
    @Published var currentMonthDate: Date
    /// 이전 달, 현재 달, 다음 달의 값을 포함한 배열입니다.
    ///
    /// Paging 효과를 위해 현재 선택된 월을 기준으로
    /// [이전 달의 day 배열, 현재 달의 day 배열, 다음 달의 day 배열]의 값을 가집니다.
    @Published var months: [[Int]] = []
    /// 요일을 나타내는 배열입니다.
    var weekdays: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.shortWeekdaySymbols
    }
    
    init() {
        self.selectedDate = .now
        self.currentMonthDate = .now
        self.months = [days(from: .previos), days(from: .current), days(from: .next)]
    }
    /// 해당 달의 첫번째 요일을 구하는 함수입니다.
    func firstWeekdayOfMonth(in date: Date) -> Int?{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return nil }
        
        return calendar.component(.weekday, from: firstDayOfMonth)
    }
    /// 해당 달의 마지막 날짜를 구하는 함수입니다.
    func lastDay(of date: Date) -> Int? {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        
        return range.count
    }
    /// 해당 달의 모든 날짜를 배열로 나타내는 함수입니다. 시작 요일 이전의 날짜에는 0을 채워 넣습니다.
    func calendarDaysOfMonth(from date: Date) -> [Int] {
        var days: [Int] = []
        
        if let startDay = firstWeekdayOfMonth(in: date),
           let lastDay = lastDay(of: date) {
            (1..<startDay + lastDay).forEach { index in
                days.append(index < startDay ? 0 : index - startDay + 1)
            }
        }
        
        return days
    }
    /// currentMonthDate의 연도를 지정한 값으로 변경하고, 이에 따라 month 데이터도 함께 갱신합니다.
    func changeYear(_ year: Int) {
        let currentMonth = Calendar.current.component(.month, from: currentMonthDate)
        let currentDay = Calendar.current.component(.day, from: currentMonthDate)

        if let newDate = Calendar.current.date(from: DateComponents(year: year, month: currentMonth, day: currentDay)) {
            currentMonthDate = newDate
        }
        
        months = [days(from: .previos), days(from: .current), days(from: .next)]
    }
    /// currentMonthDate의 달을 지정한 값으로 변경하고, 이에 따라 month 데이터도 함께 갱신합니다.
    func changeMonth(_ month: Int) {
        let currentYear = Calendar.current.component(.year, from: currentMonthDate)
        let currentDay = Calendar.current.component(.day, from: currentMonthDate)

        if let newDate = Calendar.current.date(from: DateComponents(year: currentYear, month: month, day: currentDay)) {
            currentMonthDate = newDate
        }
        
        months = [days(from: .previos), days(from: .current), days(from: .next)]
    }
    /// currentMonthDate의 달을 MonthType에 따라 변경하고, 이에 따라 month 데이터도 함께 갱신합니다.
    func changeMonth(by type: MonthType) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: type.value, to: currentMonthDate) {
            self.currentMonthDate = newMonth
        }
        
        switch type {
        case .previos:
            months.insert(days(from: .previos), at: 0)
            months.removeLast()
        case .current: break
        case .next:
            months.append(days(from: .next))
            months.removeFirst()
        }
    }
    /// selectedDate의 날짜를 지정한 값으로 변경하는 함수입니다.
    func changeDay(_ day: Int) {
        let currentYear = Calendar.current.component(.year, from: selectedDate)
        let currentMonth = Calendar.current.component(.month, from: selectedDate)

        if let newDate = Calendar.current.date(from: DateComponents(year: currentYear, month: currentMonth, day: day)) {
            selectedDate = newDate
        }
    }
    /// 해당 날짜에 작성된 회고가 있는지 여부를 반환합니다.
    func didWriteRetrospect(on day: Int, writtenDates: [Date]) -> Bool {
        guard let date = Calendar.current.date(bySetting: .day, value: day, of: currentMonthDate) else { return false }
        
        return writtenDates.contains { writtenDate in
            Calendar.current.isDate(writtenDate, inSameDayAs: date)
        }
    }
    /// [`MonthType`](doc:MonthType)에 따른 날짜 배열을 반환하는 함수입니다.
    func days(from type: MonthType) -> [Int] {
        switch type {
        case .previos:
            guard let previosMonth = Calendar.current.date(byAdding: .month, value: type.value, to: currentMonthDate) else { return [] }
            return calendarDaysOfMonth(from: previosMonth)
        case .current:
            return calendarDaysOfMonth(from: currentMonthDate)
        case .next:
            guard let nextMonth = Calendar.current.date(byAdding: .month, value: type.value, to: currentMonthDate) else { return [] }
            return calendarDaysOfMonth(from: nextMonth)
        }
    }
    /// 주어진 날짜가 오늘인지 여부를 반환합니다.
    func isToday(_ day: Int) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        var components = calendar.dateComponents([.year, .month], from: currentMonthDate)
        components.day = day

        guard let targetDate = calendar.date(from: components) else {
            return false
        }

        return calendar.isDate(now, inSameDayAs: targetDate)
    }
}
