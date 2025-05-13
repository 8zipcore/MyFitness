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
    @Query(sort: [SortDescriptor(\Retrospect.date, order: .reverse)])
    var restospects: [Retrospect]
    
    var exampleList: [Retrospect] = [
        
        Retrospect(date: .now, category: [.arms], anaerobics: [Anaerobic(exercise: Exercise(name: "레그 익스프레스"), weight: 50, count: 3, set: 10)], cardios: [Cardio(exercise: Exercise(name: "달리기"), minutes: 30)], startTime: .now, finishTime: .now + 1800, satisfaction: 70, writing: "오늘 화이팅", bookMark: true),
        
        Retrospect(date: .now - 86400, category: [.chest], anaerobics: [Anaerobic(exercise: Exercise(name: "벤치 프레스"), weight: 80, count: 8, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2400, satisfaction: 85, writing: "가슴 운동 느낌 좋음", bookMark: true),
        
        Retrospect(date: .now - 2 * 86400, category: [.back], anaerobics: [Anaerobic(exercise: Exercise(name: "랫풀다운"), weight: 60, count: 12, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2100, satisfaction: 65, writing: "등이 땡긴다", bookMark: false),
        
        Retrospect(date: .now - 3 * 86400, category: [.cardio], anaerobics: [], cardios: [Cardio(exercise: Exercise(name: "러닝머신"), minutes: 40)], startTime: .now, finishTime: .now + 2400, satisfaction: 50, writing: "지루했지만 끝냈다", bookMark: false),
        
        Retrospect(date: .now - 4 * 86400, category: [.legs], anaerobics: [Anaerobic(exercise: Exercise(name: "스쿼트"), weight: 90, count: 6, set: 4)], cardios: [], startTime: .now, finishTime: .now + 2700, satisfaction: 90, writing: "하체 힘들지만 보람있음", bookMark: true),
        
        Retrospect(date: .now - 5 * 86400, category: [.shoulders], anaerobics: [Anaerobic(exercise: Exercise(name: "숄더 프레스"), weight: 35, count: 10, set: 3)], cardios: [], startTime: .now, finishTime: .now + 1800, satisfaction: 75, writing: "어깨 불타는 느낌", bookMark: false),
        
        Retrospect(date: .now - 6 * 86400, category: [.butt], anaerobics: [Anaerobic(exercise: Exercise(name: "힙 쓰러스트"), weight: 70, count: 10, set: 3)], cardios: [], startTime: .now, finishTime: .now + 2000, satisfaction: 85, writing: "엉덩이 자극 굿", bookMark: true),
        
        Retrospect(date: .now - 7 * 86400, category: [.arms, .chest], anaerobics: [Anaerobic(exercise: Exercise(name: "푸쉬업"), weight: 0, count: 15, set: 3)], cardios: [], startTime: .now, finishTime: .now + 1500, satisfaction: 60, writing: "간단한 운동", bookMark: false),
        
        Retrospect(date: .now - 8 * 86400, category: [.cardio], anaerobics: [], cardios: [Cardio(exercise: Exercise(name: "자전거 타기"), minutes: 50)], startTime: .now, finishTime: .now + 3000, satisfaction: 55, writing: "날씨 좋아서 좋았음", bookMark: false),
        
        Retrospect(date: .now - 9 * 86400, category: [.legs], anaerobics: [Anaerobic(exercise: Exercise(name: "레그 프레스"), weight: 100, count: 8, set: 4)], cardios: [], startTime: .now, finishTime: .now + 2500, satisfaction: 95, writing: "기록 경신!", bookMark: true)
        
        
        
        
    ]
    
    
    @Environment(\.modelContext) var context
    
    @State private var keyword: String = ""
    @State private var selectedCategory: Category? = nil
    @State private var selectedCategories: Set<Category> = []
    @State private var selectedSort: SortOption = .dateDesc
    
    
    //    @State private var restospects: [Restospect]
    
    
    private var filteredRestospect: [Retrospect] {
        let filtered = exampleList.filter { restro in
            let matchesKeyword = keyword.isEmpty || restro.writing.lowercased().contains(keyword.lowercased())
            
            let matchesCategory = selectedCategories.isEmpty || selectedCategories.contains(where: { category in
                restro.category.contains(category)
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
    
    private func sortedRestospects(_ list: [Retrospect]) -> [Retrospect] {
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
    
    private func maxWeight(_ restro: Retrospect) -> Int {
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
    
    var item: Retrospect
    
    
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

