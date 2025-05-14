//
//  MainView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

struct MainView: View {

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
        let circleWidth: CGFloat = 30
        let iconWidth: CGFloat = 17

        let isLight = colorScheme == .light

        let primaryColor: Color = isLight ? .black : .white
        let backgroundColor: Color = isLight ? RGB(r: 247, g: 247, b: 247) : .black
        let toolBarBackgroundColor: Color = isLight ? .black.opacity(0.1) : .white.opacity(0.2)
        let itemViewBackgroundColor: Color = isLight ? .white : RGB(r: 28, g: 28, b: 30)

        let isRetrospectEmpty = retrospect == nil

        ZStack {
            ScrollView {
                CalendarView(calendarVM: calendarVM, writtenDates: retrospectVM.writtenDates(from: retrospects))

                Group {
                    if let retrospect = retrospect { // 운동 기록 있으면
                        WorkoutItemView(
                            workoutItems: retrospectVM.converToWorkoutItems(from: retrospect),
                            textColor: primaryColor
                        )

                        CommentsItemView(
                            date: calendarVM.selectedDate.toString(),
                            comments: retrospect.writing,
                            textColor: primaryColor
                        )
                    } else { // 운동 기록 없으면
                        CommentsItemView(
                            date: calendarVM.selectedDate.toString(),
                            comments: "운동 기록을 추가해주세요.",
                            textColor: primaryColor
                        )
                    }

                    HStack {
                        Text("이번주 운동 횟수")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(primaryColor)

                        Spacer()

                        Text("3회")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(primaryColor)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(itemViewBackgroundColor)
                )
                .padding(.top, 20)
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
                        .frame(width: 65, height: 65)
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 30)
                }
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                RetrospectView(isCreate: true)
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
                                    .foregroundStyle(primaryColor)
                                    .frame(width: iconWidth)
                            }
                    }

                    NavigationLink {
                        SearchView()
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
