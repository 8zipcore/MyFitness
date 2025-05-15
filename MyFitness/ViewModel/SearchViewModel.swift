//
//  SearchViewModel.swift
//  MyFitness
//
//  Created by 하재준 on 5/13/25.
//

import Foundation
import SwiftData

/// 검색화면에서 사용하는 데이터를 관리하는 ViewModel입니다.
final class SearchViewModel: ObservableObject {
    /// 입력받은 문자열을 저장합니다.
    @Published var keyword: String = ""
    /// 선택된 카테고리를 Set에 저장합니다.
    @Published var selectedCategories: Set<Category> = []
    /// 북마크가 표시되어 있는지 저장합니다.
    @Published var showOnlyBookmarks: Bool
	/// 정렬 옵션을 저장합니다.
    @Published var selectedSort: SortOption = .dateDesc
    /// 회고 데이터를 저장하는 배열입니다.
    @Published var retrospects: [Retrospect] = []

    init() {
        self.keyword = ""
        self.selectedCategories = []
        self.showOnlyBookmarks = false
        self.selectedSort = .dateDesc
        self.retrospects = []
    }
    
    /// 필터링 해서 표시해줄 회고 데이터 배열입니다.
    var filteredRetrospects: [Retrospect] {
        let filtered = retrospects.filter { restro in
            let matchesKeyword = keyword.isEmpty || restro.writing.lowercased().contains(keyword.lowercased())
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains {
                restro.category.contains($0)
            }
            let matchesBookmark = !showOnlyBookmarks || restro.bookMark
            
            return matchesKeyword && matchesCategory && matchesBookmark
        }
        
        return filtered
    }

    /// 리스트를 정렬 해서 표시해줄 배열입니다.
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
    
    /// 데이터를 가져와서 회고 데이터 배열에 넣습니다.
    /// - Parameter context: 데이터 관리를 위한 대리자를 받습니다.
    func loadRetrospects(from context: ModelContext) {
            /// 기본 정렬 날짜 내림차순(최신순)
            let descriptor = FetchDescriptor<Retrospect>(
                sortBy: [ SortDescriptor(\.date, order: .reverse) ]
            )
        
            let results = (try? context.fetch(descriptor)) ?? []
            self.retrospects = results
        }

    /// 북마크를 토글합니다.
    /// - Parameters:
    ///   - item: 북마크로 설정하거나 제거할 회고 데이터를 받습니다.
    ///   - context: 데이터 관리를 위한 대리자를 받습니다.
    func toggleBookmark(_ item: Retrospect, context: ModelContext) {
        item.bookMark.toggle()
        try? context.save()
    }

    /// 회고 데이터를 삭제합니다.
    /// - Parameters:
    ///   - item: 영구적으로 삭제할 회고 데이터를 받습니다.
    ///   - context: 데이터 관리를 위한 대리자를 받습니다.
    func delete(_ item: Retrospect, context: ModelContext) {
        context.delete(item)
        do {
            try context.save()
            loadRetrospects(from: context)
        } catch {
            print("삭제 실패", error)
        }
    }

    
    /// 최대 무게를 반환합니다.
    /// - Parameter restro: 최대 무게를 확인할 회고 데이터입니다.
    private func maxWeight(_ restro: Retrospect) -> Int {
        restro.anaerobics.map { $0.weight }.max() ?? 0
    }
}
