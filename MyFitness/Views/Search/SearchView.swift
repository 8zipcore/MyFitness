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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject private var searchVM = SearchViewModel()
    
    @State private var selectedRetrospect: Retrospect? = nil
    @State private var modalDate = Date()


    @Query
    var retrospects: [Retrospect]

    var body: some View {
        NavigationStack {
            List {
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
                .listRowSeparator(.hidden)
                .padding(.vertical, 6)
                // 아이템 누르면 저장 뜨고 카테고리 누르고 누르면 삭제수정 뜨는 issue
                ForEach(searchVM.sortedAndFiltered) { item in
                    ListItemView(item: item)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedRetrospect = item
                            modalDate = item.date
                        }
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
            .sheet(item: $selectedRetrospect) { retrospect in
                NavigationStack {
                    RetrospectView(retrospect: retrospect, date: modalDate)
                }
            }
//            .searchable(text: $searchVM.keyword, prompt: "운동 기록을 검색하세요")
//            .searchable(text: $searchVM.keyword, placement: horizontalSizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .navigationBarDrawer(displayMode: .always), prompt: "운동 기록을 검색하세요")
            .searchable(text: $searchVM.keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: "운동 기록을 검색하세요")
            .listStyle(.plain)
            .navigationTitle("검색")
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
        .onChange(of: retrospects, { _, _ in
            updateData()
        })
        .onAppear {
            updateData()
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

extension SearchView {
    private func updateData() {
        searchVM.loadRetrospects(from: context)
        searchVM.fetchSortedList()
    }
}

#Preview {
    SearchView()
}







