//
//  Retrospect.swift
//  MyFitness
//
//  Created by 강대훈 on 5/12/25.
//

import Foundation
import SwiftData

// MARK: Retrospect (회고 데이터 스키마)
@Model
final class Retrospect {
    @Attribute(.unique) var id: UUID
    var date: Date
    var category: [Category]

    @Relationship(deleteRule: .cascade)
    var anaerobics: [Anaerobic]

    @Relationship(deleteRule: .cascade)
    var cardios: [Cardio]

    var startTime: Date
    var finishTime: Date
    var satisfaction: Int
    var writing: String
    var bookMark: Bool = false

    init(
        id: UUID = UUID(),
        date: Date,
        category: [Category],
        anaerobics: [Anaerobic],
        cardios: [Cardio],
        startTime: Date,
        finishTime: Date,
        satisfaction: Int,
        writing: String,
        bookMark: Bool
    ) {
        self.id = id
        self.date = date
        self.category = category
        self.anaerobics = anaerobics
        self.cardios = cardios
        self.startTime = startTime
        self.finishTime = finishTime
        self.satisfaction = satisfaction
        self.writing = writing
        self.bookMark = bookMark
    }
}

// MARK: Anaerobic (무산소 데이터 스키마)
@Model
final class Anaerobic {
    @Attribute(.unique) var id: UUID
    var exercise: Exercise
    var weight: Int
    var count: Int
    var set: Int

    init(id: UUID = UUID(), exercise: Exercise, weight: Int, count: Int, set: Int) {
        self.id = id
        self.exercise = exercise
        self.weight = weight
        self.count = count
        self.set = set
    }

    /// Retrospect 화면에서 "무산소 운동 추가" 에서 사용됩니다.
    /// - Returns: 초기 값의 Anaerobic 객체가 반환됩니다.
    static func emptyData() -> Anaerobic {
        return Anaerobic(exercise: Exercise(name: "", exerciseType: .anaerobic), weight: 0, count: 0, set: 0)
    }
}

// MARK: Cardio (유산소 데이터 스키마)
@Model
final class Cardio {
    @Attribute(.unique) var id: UUID
    var exercise: Exercise
    var minutes: Int

    init(id: UUID = UUID(), exercise: Exercise, minutes: Int) {
        self.id = id
        self.exercise = exercise
        self.minutes = minutes
    }
    
    /// Retrospect 화면에서 "유산소 운동 추가" 에서 사용됩니다.
    /// - Returns: 초기 값의 Cardio 객체가 반환됩니다.
    static func emptyData() -> Cardio {
        return Cardio(exercise: Exercise(name: "", exerciseType: .cardio), minutes: 0)
    }
}

// MARK: 세부 운동 이름
// MARK: 기본적인 세부 운동 데이터를 주입해줘야 함.
@Model
final class Exercise {
    @Attribute(.unique) var id: UUID
    var name: String
    var exerciseType: ExerciseType

    init(id: UUID = UUID(), name: String, exerciseType: ExerciseType) {
        self.id = id
        self.name = name
        self.exerciseType = exerciseType
    }
}
