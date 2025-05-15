//
//  MainView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

/// 메인 화면
struct MainView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme

    @StateObject private var retrospectVM = RetrospectViewModel()
    @StateObject private var calendarVM = CalendarViewModel()
    @State var isPresented: Bool = false

    @Query
    var retrospects: [Retrospect] = []
    var retrospect: Retrospect? {
        retrospects.filter {
            Calendar.current.isDate($0.date, inSameDayAs: calendarVM.selectedDate)
        }.first
    }

    var body: some View {
        /* size */
        let isiPad = horizontalSizeClass == .regular
        
        let circleWidth: CGFloat = isiPad ? 35 : 30
        let iconWidth: CGFloat = isiPad ? 20 : 17
        let circleButtonWidth: CGFloat = isiPad ? 80 : 65

        /* color */
        let isLight = colorScheme == .light

        let primaryColor: Color = isLight ? .black : .white
        let backgroundColor: Color = isLight ? RGB(r: 242, g: 242, b: 247) : RGB(r: 28, g: 28, b: 30)
        let toolBarBackgroundColor: Color = isLight ? .black.opacity(0.1) : .white.opacity(0.2)
        let itemViewBackgroundColor: Color = isLight ? .white : RGB(r: 44, g: 44, b: 46)

        let isRetrospectEmpty = retrospect == nil
        
        ZStack {
            ScrollView {
                CalendarView(calendarVM: calendarVM, writtenDates: retrospectVM.writtenDates(from: retrospects))
                
                Group {
                    if let retrospect = retrospect { // 운동 기록 있으면
                        CommentsItemView(
                            date: calendarVM.selectedDate.toString(),
                            comments: retrospect.writing,
                            textColor: primaryColor
                        )
                        .contentShape(Rectangle())
                        .onTapGesture { isPresented = true }
                        
                        if !retrospectVM.isWorkoutDataEmpty(from: retrospect) {
                            WorkoutItemView(
                                workoutItems: retrospectVM.converToWorkoutItems(from: retrospect),
                                textColor: primaryColor
                            )
                            .contentShape(Rectangle())
                            .onTapGesture { isPresented = true }
                        }
                    } else { // 운동 기록 없으면
                        CommentsItemView(
                            date: calendarVM.selectedDate.toString(),
                            comments: "운동 기록을 추가해주세요.",
                            textColor: primaryColor
                        )
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(itemViewBackgroundColor)
                )
                .padding(.top, 5)
                .padding(.horizontal, 30)

                Spacer()
                    .frame(height: 130)
            }

            if isRetrospectEmpty {
                VStack {
                    Spacer()

                    HStack {
                        Spacer()

                        CircleButton(type: .plus) {
                            isPresented = true
                        }
                        .frame(width: circleButtonWidth, height: circleButtonWidth)
                    }
                    .padding(.vertical, circleButtonWidth * 0.3)
                    .padding(.horizontal, circleButtonWidth * 0.46)
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                RetrospectView(retrospect: retrospect, date: calendarVM.selectedDate)
            }
        }
        .scrollIndicators(.hidden)
        .navigationTitle("나의 운동 기록")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack(spacing: 5) {
                    NavigationLink {
                        StatisticsView(backgroundColor: backgroundColor)
                    } label: {
                        Circle()
                            .fill(toolBarBackgroundColor)
                            .frame(width: circleWidth)
                            .overlay {
                                Image(systemName: "chart.bar.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(primaryColor)
                                    .frame(width: iconWidth)
                            }
                    }

                    NavigationLink {
                        SearchView(backgroundColor: backgroundColor, itemViewBackgroundColor: itemViewBackgroundColor)
                    } label: {
                        Circle()
                            .fill(toolBarBackgroundColor)
                            .frame(width: circleWidth)
                            .overlay {
                                Image(systemName: "magnifyingglass")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(primaryColor)
                                    .frame(width: iconWidth)
                            }
                    }
                }
            }
        }
        .background(backgroundColor)
    }
}

#Preview {
    NavigationStack {
        MainView()
    }
}
