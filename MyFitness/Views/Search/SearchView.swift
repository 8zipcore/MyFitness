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
    @Query(sort: [SortDescriptor(\Restospect.date, order: .reverse)])
    var restospects: [Restospect]

    var exampleList: [Restospect] = [
        Restospect(date: .now + 86400, category: ["등"], anaerobics: [Anaerobic(name: "등운동", weight: 70, count: 10, set: 3)], cardios: [Cardio(name: "달리기", minutes: 30)], start_time: 12.30, finish_time: 12.50, satisfaction: 90, writing: "오늘도 고생했어", bookMark: true),
        Restospect(date: .now, category: ["유산소"], anaerobics: [Anaerobic(name: "레그익스프레스", weight: 100, count: 10, set: 3)], cardios: [Cardio(name: "달리기", minutes: 80)], start_time: 12.30, finish_time: 12.50, satisfaction: 30, writing: "부상 당함 ㅠㅠ", bookMark: false),
        Restospect(date: .now - 86400, category: ["팔"], anaerobics: [Anaerobic(name: "등운동", weight: 100, count: 10, set: 3)], cardios: [Cardio(name: "자전거", minutes: 80)], start_time: 12.30, finish_time: 12.50, satisfaction: 30, writing: "트레이너 선생님이 잘 가르쳐줘서 좋았다", bookMark: false)
    ]
    
    
    @Environment(\.modelContext) var context
    
    @State private var keyword: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedCategories: Set<Category> = []

    
    
    private var filteredRestospect: [Restospect] {
        exampleList.filter { resto in
            let matchesKeyword = keyword.isEmpty || resto.writing.lowercased().contains(keyword.lowercased())
            
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(where: { category in
                resto.category.contains(category.rawValue)
            })
            
            return matchesKeyword && matchesCategory
        }
    }
    
    var body: some View {
        NavigationStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Category.allCases, id: \.self) { category in
                        CategoryButton(category: category, isSelected: selectedCategories.contains(category), toggleAction: {
                            if selectedCategories.contains(category) {
                                selectedCategories.remove(category)
                            } else {
                                selectedCategories.insert(category)
                            }
                            
                        })
                        
                    }
                }
            }
            .padding()
            
            List {
                ForEach(filteredRestospect) { item in
                    NavigationLink {
                        // TODO: - 작성글로 이동
                    } label: {
                        ListItem(item: item)
                            .swipeActions(edge: .leading) { // 오른쪽으로 스와이프해서 북마크
                                Button {
                                    item.bookMark.toggle()
                                } label: {
                                    Image(systemName: "bookmark")
                                }
                                .tint(.orange)
                            }
                    }
                    
                }
                .onDelete(perform: delete) // 왼쪽으로 스와이프해서 삭제
                
            }
            .listStyle(.plain)
            .navigationTitle("검색")
            .searchable(text: $keyword, prompt: "운동 기록을 검색하세요")
            
        }
        .navigationBarBackButtonHidden(true)
        
    }
}

#Preview {
    SearchView()
}


func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
}

extension SearchView {
    func delete(_ indexSet: IndexSet) {
        for index in indexSet {
            context.delete(restospects[index])
        }
    }
}


struct CategoryButton: View {
    @Environment(\.colorScheme) var colorScheme

    let category: Category
    let isSelected: Bool
    let toggleAction: () -> Void
    
    var body: some View {
        let isDark = colorScheme == .dark
        
        let backgroundColor: Color = {
            if isSelected {
                return isDark ? .white : .black
            } else {
                return isDark ? .black : .white
            }
        }()
        
        let textColor: Color = {
            if isSelected {
                return isDark ? .black : .white
            } else {
                return isDark ? .white : .black
            }
        }()
        
        let borderColor: Color = {
            if isSelected {
                return .clear
            } else {
                return isDark ? .white : .black
            }
        }()
        
        Button {
            toggleAction()
        } label: {
            Text(category.rawValue)
                .foregroundStyle(textColor)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
            
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .tint(backgroundColor)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(borderColor, lineWidth: 1)
        }
        
    }
}

struct ListItem: View {
    @Environment(\.colorScheme) var colorScheme
    
    var item: Restospect
    
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.writing)
                    .font(.footnote)
                    .foregroundStyle(colorScheme == .light ? .gray : .white) // TODO: - 다크모드일때 글자 색깔 무슨색으로 해야할까요?
                    .padding(.vertical, 4)
                
                Text(formattedDate(item.date))
                    .font(.callout)
                    .fontWeight(.medium)
                
            }
            Spacer()
            if item.bookMark == true {
                Image(systemName: "bookmark")
            }
        }
        
    }
}

