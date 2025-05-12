//
//  Retrospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import SwiftUI

struct Retrospect: View {
    @State private var anaerobics: [Anaerobic] = []
    @State private var cardios: [Cardio] = []
    @State private var satisfaction: Int = 0
    @State private var startTime: Date = .now
    @State private var endTime: Date = .now
    @State private var writing: String = ""

    var body: some View {
        Form {
            Section("무산소 운동") {
                List {
                    ForEach($anaerobics) { $anaerobic in
                        AnaerobicView(anaerobic: $anaerobic)
                    }
                    .onDelete { indexPath in
                        anaerobics.remove(atOffsets: indexPath)
                    }
                }

                Button {
                    anaerobics.append(Anaerobic(name: "", weight: 0, count: 0, set: 0))
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }
            Section("유산소 운동") {
                List {
                    ForEach($cardios) { $cardio in
                        CardioView(cardio: $cardio)
                    }
                    .onDelete { indexPath in
                        cardios.remove(atOffsets: indexPath)
                    }
                }
                Button {
                    cardios.append(Cardio(name: "", minutes: 0))
                } label: {
                    Label("추가", systemImage: "plus")
                }
            }
            Section("성취도") {
                HStack {
                    Text("금일 운동은 어땠나요?")
                    Spacer()
                    Picker("", selection: $satisfaction) {
                        ForEach(Array(stride(from: 0, through: 100, by: 10)), id: \.self) { number in
                            Text("\(number)%")
                        }
                    }
                }
            }

            Section("운동 시간") {
                VStack(spacing: 8) {
                    HStack {
                        Text("시작 시간")
                        Spacer()
                        DatePicker("시간 선택", selection: $startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }
                    Divider()
                    HStack {
                        Text("종료 시간")
                        Spacer()
                        DatePicker("시간 선택", selection: $endTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.graphical) // 또는 .compact, .graphical
                            .labelsHidden()
                            .frame(width: 200, height: 30)
                    }

                }
            }

            Section("회고") {
                TextEditor(text: $writing)
                    .frame(minHeight: 150)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    print(anaerobics.forEach { print($0.name) })
                } label: {
                    Text("저장")
                }
            }
        }
        .navigationTitle("운동 기록")
        .navigationBarTitleDisplayMode(.inline)

    }

}

// MARK: 무산소 View
struct AnaerobicView: View {
    @Binding var anaerobic: Anaerobic

    var body: some View {
        VStack {
            HStack {
                TextField("운동명", text: $anaerobic.name)
                Spacer()
            }

            Divider()

            HStack {
                Picker("", selection: $anaerobic.weight) {
                    ForEach(Array(stride(from: 0, to: 200, by: 5)), id: \.self) { number in
                        Text("\(number)")
                    }
                }

                Text("Kg")

                Picker("", selection: $anaerobic.set) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }
                }

                Text("세트")

                Picker("", selection: $anaerobic.count) {
                    ForEach(0..<200, id: \.self) { number in
                        Text("\(number)")
                    }
                }
                Text("회")

                Spacer()
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: 유산소 View
struct CardioView: View {
    @Binding var cardio: Cardio

    var body: some View {
        HStack {
            TextField("운동명", text: $cardio.name)
            Spacer()
            Picker("", selection: $cardio.minutes) {
                ForEach(0..<200, id: \.self) { number in
                    Text("\(number)")
                }
            }

            Text("분")
        }
    }
}

struct CustomButton: View {
    var body: some View {
        Button {

        } label: {
            Text("하체")
                .padding(.horizontal, 10)
                .padding(.vertical, 2)
                .tint(.black)
                .font(.callout)
                .background {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(.gray.opacity(0.2))
                }
        }
        .padding(.trailing, 7)
    }
}

#Preview {
    NavigationStack {
        Retrospect()
    }
}
