//
//  Array+.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import Foundation

extension Array where Element == Retrospect {
    var categoryCounts: [CategoryCount] {
        // 1. allCategories: 모든 Retrospect의 category 배열을 flatMap으로 합치기
        let allCategories = self.flatMap { $0.category }
        
        // 2. rawValue별로 count 계산
        let countsByName = allCategories
            .map(\.rawValue)
            .reduce(into: [String: Int]()) { acc, name in
                acc[name, default: 0] += 1
            }
        
        // 3. CategoryCount로 변환 (원하는 순서로 정렬 가능)
        return countsByName
            .map { CategoryCount(categoryName: $0.key, categoryCount: $0.value) }
            .sorted { $0.categoryCount > $1.categoryCount }
    }
}
