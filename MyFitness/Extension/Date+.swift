//
//  Date+.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

extension Date {
    /// 년도와 월을 XXXX년 XX월 형태의 문자열로 반환합니다.
    func toYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: self)
    }

    /// XXXX년 X월 X일 형태의 문자열로 반환합니다.
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }
    
    /// "월"을 증가하는 메소드입니다.
    /// - Parameter value: 증가할 만큼의 정수를 받습니다.
    /// - Returns: 증가된 "월"을 반영하여 Date형태로 반환합니다.
    func changeMonth(by value: Int) -> Self {
        if value == 0 { return self }
        return Calendar.current.date(byAdding: .month, value: value, to: self) ?? self
    }

    /// "일"을 증가하는 메소드입니다.
    /// - Parameter value: 증가할 만큼의 정수를 받습니다.
    /// - Returns: 증가된 "일"을 반영하여 Date형태로 반환합니다.
    func changeDay(by value: Int) -> Self {
        if value == 0 { return self }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = value

        return calendar.date(from: components) ?? self
    }

    /// 해당 날짜가 속한 달의 주 수를 반환하는 함수입니다.
    /// - Returns: 달(month) 내 포함된 주(week) 수 (Int)
    func weeksInMonth() -> Int {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: self),
              let lastDay = calendar.date(byAdding: .day, value: -1, to: interval.end) else {
            return 0
        }
        return calendar.component(.weekOfMonth, from: lastDay)
    }
    
    /// 현재 날짜(self)와 전달된 날짜가 같은 연도와 월에 속하는지 비교하는 함수입니다.
    /// - Parameter date: 비교할 날짜
    /// - Returns: 두 날짜가 같은 연도와 월이면 true, 아니면 false
    func isSameYearAndMonth(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let lhsComponents = calendar.dateComponents([.year, .month], from: self)
        let rhsComponents = calendar.dateComponents([.year, .month], from: date)

        return lhsComponents.year == rhsComponents.year &&
               lhsComponents.month == rhsComponents.month
    }
}
