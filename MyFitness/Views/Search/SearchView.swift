//
//  SearchView.swift
//  MyFitness
//
//  Created by 하재준 on 5/12/25.
//

import SwiftUI
import SwiftData

// 검색뷰
struct SearchView: View {
    @Environment(\.modelContext) var context
    @StateObject private var searchVM = SearchViewModel()

    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    var retrospects: [Retrospect]

    var body: some View {
        NavigationStack {

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Category.allCases, id: \.self) { category in
                        CategoryButton(category: category, isSelected: searchVM.selectedCategories.contains(category), toggleAction: {
                            if searchVM.selectedCategories.contains(category) {
                                searchVM.selectedCategories.remove(category)
                            } else {
                                searchVM.selectedCategories.insert(category)
                            }

                        })

                    }
                }
            }
            .padding()

            List {
                ForEach(searchVM.sortedAndFiltered) { item in
                    NavigationLink {
                        RetrospectView(isCreate: false, retrospect: item) // isCreate 호출 안들어감.
                    } label: {
                        ListItemView(item: item)
                            .swipeActions(edge: .leading) { // 오른쪽으로 스와이프해서 북마크
                                Button {
                                    searchVM.toggleBookmark(item, context: context)
                                } label: {
                                    Image(systemName: "bookmark")
                                }
                                .tint(.orange)
                            }
                            .swipeActions(edge: .trailing) { // 왼쪽으로 스와이프해서 삭제
                                Button(role: .destructive) {
                                    searchVM.delete(item, context: context)
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("검색")
            .searchable(text: $searchVM.keyword, prompt: "운동 기록을 검색하세요")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        searchVM.showOnlyBookmarks.toggle()
                    } label: {
                        Image(systemName: searchVM.showOnlyBookmarks ? "bookmark.fill" : "bookmark")
                    }
                    .tint(.primary)
                }
            }
        }
        Menu {
            ForEach(SearchViewModel.SortOption.allCases) { option in
                Button {
                    searchVM.selectedSort = option
                } label: {
                    Label(option.rawValue, systemImage: searchVM.selectedSort == option ? "checkmark" : "")
                }
            }
        } label: {
            Label("정렬: \(searchVM.selectedSort.rawValue)", systemImage: "arrow.up.arrow.down")
                .foregroundColor(.primary)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

#Preview {
    SearchView()
}







