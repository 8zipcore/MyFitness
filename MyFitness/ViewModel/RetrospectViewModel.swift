//
//  RetrospectViewModel.swift
//  MyFitness
//
//  Created by 홍승아 on 5/13/25.
//

import Foundation
import SwiftData
/// 회고 데이터를 관리하는 ViewModel입니다.
class RetrospectViewModel: ObservableObject {
    
    /// Retrospect에 포함된 운동관련 데이터를 WorkoutItem으로 변환하는 함수입니다.
    func converToWorkoutItems(from retrospect: Retrospect) -> [WorkoutItem] {
        var workoutItems: [WorkoutItem] = []
        
        retrospect.anaerobics.forEach { anaerobic in
            let title = anaerobic.name
            let contents = "\(anaerobic.weight)kg \(anaerobic.count)회 \(anaerobic.set)세트"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        retrospect.cardios.forEach { cardio in
            let title = cardio.name
            
            let contents = "\(cardio.minutes)분"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        return workoutItems
    }
    /// 회고가 작성된 날짜 Date를 반환하는 함수입니다.
    func writtenDates(from retrospects: [Retrospect]) -> [Date] {
        return retrospects.map { $0.date }
    }
    /// 선택한 날짜가 포함되는 달의 회고 작성수를 반환합니다.
    func retropsectCount(from date: Date, writtenDates: [Date]) -> Int {
        let calendar = Calendar.current
        
        return writtenDates.filter {
            calendar.isDate($0, equalTo: date, toGranularity: .month)
        }.count
    }
    /// 유산소, 무산소 운동 데이터 목록이 비어있는지 확인하는 함수입니다.
    func isWorkoutDataEmpty(from retrospect: Retrospect) -> Bool {
        return retrospect.anaerobics.count == 0 && retrospect.cardios.count == 0
    }
}
