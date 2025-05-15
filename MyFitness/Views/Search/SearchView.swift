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
    
    let backgroundColor: Color
    let itemViewBackgroundColor: Color
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<Category.allCases.count, id: \.self) { index in
                                let category = Category.allCases[index]
                                
                                CategoryButton(category: category, isSelected: searchVM.selectedCategories.contains(category), toggleAction: {
                                    if searchVM.selectedCategories.contains(category) {
                                        searchVM.selectedCategories.remove(category)
                                    } else {
                                        searchVM.selectedCategories.insert(category)
                                    }
                                    
                                    updateData()
                                })
                                .padding(.leading, index == 0 ? 15 : 0)
                                .padding(.trailing, index == Category.allCases.count - 1 ? 15 : 0)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(backgroundColor)
                    
                    // 아이템 누르면 저장 뜨고 카테고리 누르고 누르면 삭제수정 뜨는 issue
                    
                    ForEach(searchVM.sortedAndFiltered.indices, id:\.self) { index in
                        let item = searchVM.sortedAndFiltered[index]
                        
                        ListItemView(
                            item: item,
                            itemViewBackgroundColor: itemViewBackgroundColor,
                            isFirst: index == 0,
                            isLast: index == searchVM.sortedAndFiltered.count - 1
                        )
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
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 3)
                                    .fill(backgroundColor)
                            )
                    }
                }
                .background(backgroundColor)
                .listStyle(.plain)
                .padding(.horizontal, 10)
                .sheet(item: $selectedRetrospect) { retrospect in
                    NavigationStack {
                        RetrospectView(retrospect: retrospect, date: modalDate)
                    }
                }
                //            .searchable(text: $searchVM.keyword, prompt: "운동 기록을 검색하세요")
                //            .searchable(text: $searchVM.keyword, placement: horizontalSizeClass == .compact ? .navigationBarDrawer(displayMode: .always) : .navigationBarDrawer(displayMode: .always), prompt: "운동 기록을 검색하세요")
                .searchable(text: $searchVM.keyword, placement: .navigationBarDrawer(displayMode: .always), prompt: "운동 기록을 검색하세요")
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
            .overlay {
                if searchVM.sortedAndFiltered.isEmpty {
                    Text("운동을 기록해 보세요!")
                        .foregroundStyle(.secondary)
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
        }
        .background(backgroundColor)
    }
}

extension SearchView {
    private func updateData() {
        searchVM.loadRetrospects(from: context)
    }
}

#Preview {
    SearchView(backgroundColor: .gray, itemViewBackgroundColor: .white)
}







