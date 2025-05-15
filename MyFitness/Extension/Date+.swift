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

    // TODO:
    func weeksInMonth() -> Int {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: self),
              let lastDay = calendar.date(byAdding: .day, value: -1, to: interval.end) else {
            return 0
        }
        return calendar.component(.weekOfMonth, from: lastDay)
    }
}

// TODO: 
func isSameYearAndMonth(_ lhs: Date, _ rhs: Date) -> Bool {
    let calendar = Calendar.current
    let lhsComponents = calendar.dateComponents([.year, .month], from: lhs)
    let rhsComponents = calendar.dateComponents([.year, .month], from: rhs)

    return lhsComponents.year == rhsComponents.year &&
           lhsComponents.month == rhsComponents.month
}
