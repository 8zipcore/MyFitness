//
//  SearchViewModel.swift
//  MyFitness
//
//  Created by 하재준 on 5/13/25.
//

import Foundation
import SwiftData


final class SearchViewModel: ObservableObject {
    @Published var keyword: String = ""
    @Published var selectedCategories: Set<Category> = []
    @Published var showOnlyBookmarks: Bool
    @Published var selectedSort: SortOption = .dateDesc
    @Published var retrospects: [Retrospect] = []

    init() {
        self.keyword = ""
        self.selectedCategories = []
        self.showOnlyBookmarks = false
        self.selectedSort = .dateDesc
        self.retrospects = []
    }
    
    /// 필터링 해서 표시해줄 배열입니다
    var filteredRetrospects: [Retrospect] {
        let filtered = retrospects.filter { restro in
            /// 검색 키워드
            let matchesKeyword = keyword.isEmpty || restro.writing.lowercased().contains(keyword.lowercased())
            /// 카테고리
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains {
                restro.category.contains($0)
            }
            /// 북마크
            let matchesBookmark = !showOnlyBookmarks || restro.bookMark
            
            return matchesKeyword && matchesCategory && matchesBookmark
        }
        
        return filtered
    }
    /// 리스트를 sort 해서 표시해줄 배열입니다.
    var sortedAndFiltered: [Retrospect] {
        let list = filteredRetrospects
        var newList: [Retrospect] = []
        
        switch selectedSort {
        case .dateDesc:
            newList = list.sorted { $0.date > $1.date }
        case .dateAsc:
            newList = list.sorted { $0.date < $1.date }
        case .satisfactionDesc:
            newList = list.sorted { $0.satisfaction > $1.satisfaction }
        case .satisfactionAsc:
            newList = list.sorted { $0.satisfaction < $1.satisfaction }
        case .weightDesc:
            newList = list.sorted { maxWeight($0) > maxWeight($1) }
        case .weightAsc:
            newList = list.sorted { maxWeight($0) < maxWeight($1) }
        }
        
        return newList
    }
    
    /// 데이터를 가져와서 retrospect 배열에 넣습니다
    func loadRetrospects(from context: ModelContext) {
            /// 기본 정렬 날짜 내림차순(최신순)
            let descriptor = FetchDescriptor<Retrospect>(
                sortBy: [ SortDescriptor(\.date, order: .reverse) ]
            )
        
            let results = (try? context.fetch(descriptor)) ?? []
            self.retrospects = results
        }

    /// 북마크 토글입니다
    func toggleBookmark(_ item: Retrospect, context: ModelContext) {
        item.bookMark.toggle()
        try? context.save()
    }

    /// 회고록 삭제입니다
    func delete(_ item: Retrospect, context: ModelContext) {
        context.delete(item)
        do {
            try context.save()
            loadRetrospects(from: context)
        } catch {
            print("삭제 실패", error)
        }
    }

    
    /// 최대 무게를 리턴합니다
    private func maxWeight(_ restro: Retrospect) -> Int {
        restro.anaerobics.map { $0.weight }.max() ?? 0
    }

    /// 정렬에 쓰이는 요소들 열거입니다
    enum SortOption: String, CaseIterable, Identifiable {
        case dateDesc = "최신 순"
        case dateAsc = "오래된 순"
        case satisfactionDesc = "만족도 높은 순"
        case satisfactionAsc = "만족도 낮은 순"
        case weightDesc = "무게 높은 순"
        case weightAsc = "무게 낮은 순"
        var id: String { rawValue }
    }
}
