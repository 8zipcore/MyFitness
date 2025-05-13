//
//  CalendarViewModel.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

class CalendarViewModel: ObservableObject {
    
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
    // 선택한 Date
    @Published var selectedDate: Date
    // 달력에 표시되는 Date
    @Published var currentMonthDate: Date
    // Paging 효과를 위해 현재 선택된 월을 기준으로
    // [이전 달의 day 배열, 현재 달의 day 배열, 다음 달의 day 배열]의 값을 가짐
    @Published var months: [[Int]] = []
    
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
    
    func firstWeekdayOfMonth(in date: Date) -> Int?{
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        guard let firstDayOfMonth = calendar.date(from: components) else { return nil }
        
        return calendar.component(.weekday, from: firstDayOfMonth)
    }
    
    func lastDay(of date: Date) -> Int? {
        let calendar = Calendar.current
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return nil
        }
        
        return range.count
    }
    
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
    
    func changeYear(_ year: Int) {
        let currentMonth = Calendar.current.component(.month, from: currentMonthDate)
        let currentDay = Calendar.current.component(.day, from: currentMonthDate)

        if let newDate = Calendar.current.date(from: DateComponents(year: year, month: currentMonth, day: currentDay)) {
            currentMonthDate = newDate
        }
        
        months = [days(from: .previos), days(from: .current), days(from: .next)]
    }
    
    func changeMonth(_ month: Int) {
        let currentYear = Calendar.current.component(.year, from: currentMonthDate)
        let currentDay = Calendar.current.component(.day, from: currentMonthDate)

        if let newDate = Calendar.current.date(from: DateComponents(year: currentYear, month: month, day: currentDay)) {
            currentMonthDate = newDate
        }
        
        months = [days(from: .previos), days(from: .current), days(from: .next)]
    }
    
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
    
    func didWriteRetrospect(on day: Int, writtenDates: [Date]) -> Bool {
        guard let date = Calendar.current.date(bySetting: .day, value: day, of: currentMonthDate) else { return false }
        
        return writtenDates.contains { writtenDate in
            Calendar.current.isDate(writtenDate, inSameDayAs: date)
        }
    }
    
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
