//
//  RestospectViewModel.swift
//  MyFitness
//
//  Created by 홍승아 on 5/13/25.
//

import Foundation
import SwiftData

class RestospectViewModel: ObservableObject {
    
    /// Restospect에 포함된 운동관련 데이터를 WorkoutItem으로 변환
    func converToWorkoutItems(from restospect: Restospect) -> [WorkoutItem] {
        var workoutItems: [WorkoutItem] = []
        
        restospect.anaerobics.forEach { anaerobic in
            let title = anaerobic.name
            // TODO: 0회 이상인 경우만 출력
            let contents = "\(anaerobic.weight)kg \(anaerobic.count)회"
//            let contents = "\(anaerobic.weight)kg \(anaerobic.count)회 \(anaerobic.set)세트"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        restospect.cardios.forEach { cardio in
            let title = cardio.name
            // TODO: 0분 이상인 경우만 출력
            let contents = "\(cardio.minutes)분"
            
            workoutItems.append(WorkoutItem(title: title, contents: contents))
        }
        
        return workoutItems
    }
}
