//
//  CalendarView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI

struct CalendarView: View {
    
    @ObservedObject var vm: CalendarViewModel
    
    @State private var selection = 1
    @State private var showDatePicker = false
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let iconWidth: CGFloat = 8
        
        let isLight = colorScheme == .light
        let primaryColor: Color = isLight ? .black : .white
        let datePickerBackgroundColor: Color = isLight ? .white : RGB(r: 28, g: 28, b: 30)
        
        let datePickerButtonImage = showDatePicker ? "chevron.right" : "chevron.down"
        
        VStack(spacing: 0) {
            HStack(spacing: 35) {
                HStack {
                    Text(vm.currentMonthDate.toYearMonthString())
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
                    ForEach(vm.weekdays, id:\.self) { weekday in
                        Text(weekday)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.vertical, 5)
                
                TabView(selection: $selection) {
                    ForEach(vm.months.indices, id: \.self) { index in
                        CalendarGridView(
                            vm: vm,
                            days: vm.months[index],
                            writtenDates: [],
                            primaryColor: primaryColor
                        )
                        .tag(index)
                        .onDisappear {
                            if selection == 0 {
                                vm.changeMonth(by: .previos)
                            }
                            
                            if selection == 2 {
                                vm.changeMonth(by: .next)
                            }
                            
                            selection = 1
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 180)
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
                    .onChange(of: selectedYear) { vm.changeYear($0) }
                    .onChange(of: selectedMonth) { vm.changeMonth($0) }
                }
            }
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    let viewModel = CalendarViewModel()
    CalendarView(vm: viewModel)
}

struct CalendarGridView: View {
    
    @ObservedObject var vm: CalendarViewModel
    let days: [Int]
    let writtenDates: [Date]
    var primaryColor: Color
    
    var body: some View {
        let circleColor: Color = RGB(r: 73, g: 70, b: 220)
        let fontSize: CGFloat = days.count > 35 ? 15 : 16
        let textWidth: CGFloat = days.count > 35 ? 20 : 30
        
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible()), count: 7)
        ) {
            ForEach(0..<days.count, id: \.self) { index in
                let day = days[index]
                let dayToString = day > 0 ? "\(days[index])" : ""
                let isWritten = vm.didWriteRetrospect(on: day, writtenDates: writtenDates)
                let textColor = !isWritten && vm.isToday(day) ? circleColor : primaryColor
                
                Text(dayToString)
                    .font(.system(size: fontSize))
                    .foregroundStyle(isWritten ? .white : textColor)
                    .frame(width: textWidth, height: textWidth)
                    .background(
                        Circle()
                            .fill(isWritten ? circleColor : .clear)
                            .frame(maxWidth: .infinity)
                    )
                
            }
        }
    }
}
