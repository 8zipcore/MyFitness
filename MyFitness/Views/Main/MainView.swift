//
//  MainView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @Query
    var restospects: [Restospect] = []
    var restospect: Restospect? {
        restospects.filter {
            Calendar.current.isDate($0.date, inSameDayAs: calendarVM.selectedDate)
        }.first
    }
    
    @StateObject private var restospectVM = RestospectViewModel()
    @StateObject private var calendarVM = CalendarViewModel()
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let circleWidth: CGFloat = 30
        let iconWidth: CGFloat = 17
        
        let iconColor: Color = colorScheme == .light ? .black : .white
        let backgroundColor: Color = colorScheme == .light ? RGB(r: 247, g: 247, b: 247) : .black
        let toolBarBackgroundColor: Color = colorScheme == .light ? .black.opacity(0.1) : .white.opacity(0.2)
        
        NavigationStack {
            ZStack {
                ScrollView {
                    CalendarView(vm: calendarVM)
                    
                    Group {
                        WorkoutItemView(
                            workoutItems: [
                                WorkoutItem(title: "런지", contents: "40kg 3회 2세트"),
                                WorkoutItem(title: "런지", contents: "40kg 3회 2세트"),
                                WorkoutItem(title: "런지", contents: "40kg 3회 2세트"),
                                WorkoutItem(title: "런지", contents: "40kg 3회 2세트"),
                            ]
                        )
                        
                        CommentsItemView(
                            date: calendarVM.selectedDate.toString(),
                            comments: "오늘의 한줄평 입니다"
                        )
                        
                        if let restospect = restospect {
                            WorkoutItemView(
                                workoutItems: restospectVM.converToWorkoutItems(from: restospect)
                            )
                            
                            CommentsItemView(
                                date: calendarVM.selectedDate.toString(),
                                comments: restospect.writing
                            )
                        }
                        
                        HStack {
                            Text("이번주 운동 횟수")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            Spacer()
                            
                            Text("3회")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 20)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, 30)
                    
                    Spacer()
                        .frame(height: 130)
                }
                // 운동 기록 없으면
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        CircleButton(type: .plus) {
                            
                        }
                        .frame(width: 65, height: 65)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("나의 운동 기록")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(spacing: 5) {
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(toolBarBackgroundColor)
                                .frame(width: circleWidth)
                                .overlay {
                                    Image(systemName: "chart.bar.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(iconColor)
                                        .frame(width: iconWidth)
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            Circle()
                                .fill(toolBarBackgroundColor)
                                .frame(width: circleWidth)
                                .overlay {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(iconColor)
                                        .frame(width: iconWidth)
                                }
                        }
                    }
                }
            }
            .background(backgroundColor)
        }

    }
}

#Preview {
    MainView()
}
