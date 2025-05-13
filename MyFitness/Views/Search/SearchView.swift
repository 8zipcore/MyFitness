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
        
        Restospect(date: .now - 86400, category: ["팔"], anaerobics: [Anaerobic(name: "등운동", weight: 100, count: 10, set: 3)], cardios: [Cardio(name: "자전거", minutes: 80)], start_time: 12.30, finish_time: 12.50, satisfaction: 60, writing: "트레이너 선생님이 잘 가르쳐줘서 좋았다", bookMark: false),
        
        Restospect(date: .now - 86400 * 2, category: ["가슴"], anaerobics: [Anaerobic(name: "벤치프레스", weight: 50, count: 10, set: 3)], cardios: [], start_time: 10.00, finish_time: 10.40, satisfaction: 70, writing: "오늘 벤치프레스 기록 갱신!", bookMark: true),
        
        Restospect(date: .now - 86400 * 3, category: ["등"], anaerobics: [Anaerobic(name: "랫풀다운", weight: 60, count: 12, set: 4)], cardios: [Cardio(name: "자전거", minutes: 15)], start_time: 11.00, finish_time: 11.45, satisfaction: 80, writing: "컨디션 최고", bookMark: false),
        
        Restospect(date: .now - 86400 * 4, category: ["유산소"], anaerobics: [], cardios: [Cardio(name: "러닝", minutes: 40)], start_time: 7.00, finish_time: 7.50, satisfaction: 50, writing: "숨이 차지만 개운했다", bookMark: false),
        
        Restospect(date: .now - 86400 * 5, category: ["어깨"], anaerobics: [Anaerobic(name: "숄더프레스", weight: 25, count: 10, set: 3)], cardios: [], start_time: 12.00, finish_time: 12.30, satisfaction: 65, writing: "어깨 뿌듯함", bookMark: true),
        
        Restospect(date: .now - 86400 * 6, category: ["다리"], anaerobics: [Anaerobic(name: "레그프레스", weight: 100, count: 10, set: 4)], cardios: [], start_time: 13.00, finish_time: 13.50, satisfaction: 90, writing: "다리 운동 제대로 했음", bookMark: false),
        
        Restospect(date: .now - 86400 * 7, category: ["엉덩이"], anaerobics: [Anaerobic(name: "힙쓰러스트", weight: 60, count: 12, set: 3)], cardios: [], start_time: 14.00, finish_time: 14.30, satisfaction: 85, writing: "엉덩이 운동 완벽", bookMark: false),
        
        Restospect(date: .now - 86400 * 8, category: ["팔"], anaerobics: [Anaerobic(name: "트라이셉스 익스텐션", weight: 20, count: 10, set: 3)], cardios: [], start_time: 15.00, finish_time: 15.20, satisfaction: 55, writing: "조금 힘들었지만 좋았음", bookMark: true),
        
        Restospect(date: .now - 86400 * 9, category: ["등"], anaerobics: [Anaerobic(name: "데드리프트", weight: 80, count: 8, set: 4)], cardios: [], start_time: 16.00, finish_time: 16.45, satisfaction: 95, writing: "오늘 운동 최고", bookMark: true)
    ]
    
    
    @Environment(\.modelContext) var context
    
    @State private var keyword: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedCategories: Set<Category> = []
    @State private var selectedSort: SortOption = .dateDesc
    

//    @State private var restospects: [Restospect]
    
    
    private var filteredRestospect: [Restospect] {
        let filtered = exampleList.filter { resto in
            let matchesKeyword = keyword.isEmpty || resto.writing.lowercased().contains(keyword.lowercased())
            
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(where: { category in
                resto.category.contains(category.rawValue)
            })
            return matchesKeyword && matchesCategory
        }

        return sortedRestospects(filtered)
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
            
//            .searchable(text: )
            
        }
        //        .navigationBarBackButtonHidden(true)
        Menu {
            ForEach(SortOption.allCases) { option in
                Button {
                    selectedSort = option
                } label: {
                    Label(option.rawValue, systemImage: selectedSort == option ? "checkmark" : "")
                }
            }
        } label: {
            Label("정렬: \(selectedSort.rawValue)", systemImage: "arrow.up.arrow.down")
                .foregroundColor(.primary)
                .padding(8)
                .background(Color(.systemGray5))
                .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
    
    private func sortedRestospects(_ list: [Restospect]) -> [Restospect] {
        switch selectedSort {
        case .dateDesc:
            return list.sorted { $0.date > $1.date }
        case .dateAsc:
            return list.sorted { $0.date < $1.date }
        case .satisfactionDesc:
            return list.sorted { $0.satisfaction > $1.satisfaction }
        case .satisfactionAsc:
            return list.sorted { $0.satisfaction < $1.satisfaction }
        case .weightDesc:
            return list.sorted { maxWeight($0) > maxWeight($1) }
        case .weightAsc:
            return list.sorted { maxWeight($0) < maxWeight($1) }
        }
    }

    private func maxWeight(_ restro: Restospect) -> Int {
        restro.anaerobics.map { $0.weight }.max() ?? 0
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
            context.delete(filteredRestospect[index])
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
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
            
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

enum SortOption: String, CaseIterable, Identifiable {
    case dateDesc = "최신 순"
    case dateAsc = "오래된 순"
    case satisfactionDesc = "만족도 높은 순"
    case satisfactionAsc = "만족도 낮은 순"
    case weightDesc = "무게 높은 순"
    case weightAsc = "무게 낮은 순"

    var id: String { self.rawValue }
}

enum searchTokens: String, Identifiable, Hashable, CaseIterable {
    case bookmarked
    var id: Self { self }
}
