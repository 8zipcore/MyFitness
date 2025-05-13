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
}
