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
            let title = anaerobic.exercise.name
            // TODO: 0회 이상인 경우만 출력
            let contents = "\(anaerobic.weight)kg \(anaerobic.count)회"
//            let contents = "\(anaerobic.weight)kg \(anaerobic.count)회 \(anaerobic.set)세트"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        retrospect.cardios.forEach { cardio in
            let title = cardio.exercise.name
            // TODO: 0분 이상인 경우만 출력
            let contents = "\(cardio.minutes)분"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        return workoutItems
    }
    
    func writtenDates(from retrospects: [Retrospect]) -> [Date] {
        return retrospects.map { $0.date }
    }
}
