//
//  CalendarGridView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/14/25.
//

import SwiftUI

struct CalendarGridView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var calendarVM: CalendarViewModel
    
    let days: [Int]
    let writtenDates: [Date]
    let primaryColor: Color
    let direction: CalendarDirection
    
    var body: some View {
        let isMoreThanFiveWeeks = days.count > 35
        let fontSize: CGFloat = isMoreThanFiveWeeks ? 15 : 16
        let textWidth: CGFloat = isMoreThanFiveWeeks ? 33 : 40
        
        let isLight = colorScheme == .light
        
        let currentDate = calendarVM.currentMonthDate.changeMonth(by: direction.value)
        
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7)
        ) {
            ForEach(0..<days.count, id: \.self) { index in
                let day = days[index]
                let dayToString = day > 0 ? "\(days[index])" : ""
                
                let newDate = currentDate.changeDay(by: day)
                                
                let isWritten = calendarVM.didWriteRetrospect(
                    on: newDate,
                    writtenDates: writtenDates
                )
                // TextColor 우선순위
                // 회고 기록 여부 > 오늘 날짜 > 내일 이후의 날짜
                let futureDateTextColor: Color = calendarVM.isFutureDate(newDate) ? .gray : primaryColor
                let todayTextColor: Color = calendarVM.isToday(newDate) ? RGB(r: 73, g: 70, b: 220) : futureDateTextColor
                let textColor = isWritten ? .white : todayTextColor
                
                // CircleBackgroundColor 우선순위
                // 선택한 날짜 > 회고 기록 여부
                let writtenCircleColor = isWritten ? RGB(r: 73, g: 70, b: 220) : .clear
                let selectedCircleColor: Color = isLight ? .black.opacity(0.2) : .white.opacity(0.2)
                let circleColor = calendarVM.isSelectedDay(on: newDate) ? selectedCircleColor : writtenCircleColor
                
                Text(dayToString)
                    .font(.system(size: fontSize))
                    .foregroundStyle(textColor)
                    .frame(width: textWidth, height: textWidth)
                    .background(
                        Circle()
                            .fill(day > 0 ? circleColor : .clear)
                            .frame(maxWidth: .infinity)
                    )
                    .onTapGesture {
                        calendarVM.changeDay(newDate)
                    }
            }
        }
    }
}
