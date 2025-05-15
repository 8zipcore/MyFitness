//
//  CalendarView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI
import SwiftData

// 달력을 보여줄 화면
struct CalendarView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var calendarVM: CalendarViewModel
    
    @Query
    var retrospects: [Retrospect] = []
    
    @State private var selection = 1
    @State private var showDatePicker = false
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    let writtenDates: [Date]
    
    var body: some View {
        let iconWidth: CGFloat = 8
        
        let isLight = colorScheme == .light
        let primaryColor: Color = isLight ? .black : .white
        let datePickerBackgroundColor: Color = isLight ? .white : RGB(r: 28, g: 28, b: 30)
        
        let datePickerButtonImage = showDatePicker ? "chevron.right" : "chevron.down"
        
        VStack(spacing: 0) {
            HStack(spacing: 35) {
                HStack {
                    Text(calendarVM.currentMonthDate.toYearMonthString())
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(primaryColor)
                    
                    withAnimation {
                        Image(systemName: datePickerButtonImage)
                            .resizable()
                            .scaledToFit()
                            .tint(primaryColor)
                            .frame(width: 13, height: 13)
                    }
                }
                .onTapGesture {
                    showDatePicker.toggle()
                }
                
                Spacer()
                
                Button {
                    withAnimation {
                        selection = 0
                    }
                } label: {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .tint(primaryColor)
                        .frame(width: iconWidth)
                }
                
                Button {
                    withAnimation {
                        selection = 2
                    }
                } label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .scaledToFit()
                        .tint(primaryColor)
                        .frame(width: iconWidth)
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 5)
            
            VStack(spacing: 0) {
                HStack {
                    ForEach(calendarVM.weekdays, id:\.self) { weekday in
                        Text(weekday)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 5)
                
                TabView(selection: $selection) {
                    ForEach(calendarVM.months.indices, id: \.self) { index in
                        CalendarGridView(
                            calendarVM: calendarVM,
                            days: calendarVM.months[index],
                            writtenDates: writtenDates,
                            primaryColor: primaryColor,
                            direction: CalendarDirection(rawValue: index) ?? .current
                        )
                        .tag(index)
                        .onDisappear {
                            if selection == 0 {
                                calendarVM.changeMonth(by: .previous)
                            }
                            
                            if selection == 2 {
                                calendarVM.changeMonth(by: .next)
                            }
                            
                            selection = 1
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 250)
            }
            .overlay {
                if showDatePicker {
                    HStack(spacing: 0) {
                        Picker("연도", selection: $selectedYear) {
                            ForEach(Array(1900...2100), id: \.self) { year in
                                Text("\(String(year)) 년")
                                    .tag(year)
                            }
                        }
                        .frame(maxWidth: .infinity)

                        Picker("월", selection: $selectedMonth) {
                            ForEach(Array(1...23), id: \.self) { month in
                                Text("\(month) 월")
                                    .tag(month)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(datePickerBackgroundColor)
                    )
                    .onChange(of: selectedYear) { calendarVM.changeYear($0) }
                    .onChange(of: selectedMonth) { calendarVM.changeMonth($0) }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    CalendarView(calendarVM: viewModel, writtenDates: [])
}
