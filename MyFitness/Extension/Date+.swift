//
//  Date+.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

extension Date {
    func toYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: self)
    }
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: self)
    }
    
    func changeMonth(by value: Int) -> Self {
        if value == 0 { return self }
        return Calendar.current.date(byAdding: .month, value: value, to: self) ?? self
    }
    
    func changeDay(by value: Int) -> Self {
        if value == 0 { return self }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: self)
        components.day = value

        return calendar.date(from: components) ?? self
    }
}

func isSameYearAndMonth(_ lhs: Date, _ rhs: Date) -> Bool {
    let calendar = Calendar.current
    let lhsComponents = calendar.dateComponents([.year, .month], from: lhs)
    let rhsComponents = calendar.dateComponents([.year, .month], from: rhs)

    return lhsComponents.year == rhsComponents.year &&
           lhsComponents.month == rhsComponents.month
}
