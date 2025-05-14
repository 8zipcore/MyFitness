//
//  Category.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

/// 사용자가 선택할 수 있는 운동 카테고리
enum Category: String, CaseIterable, Codable {
    case arms = "팔"
    case chest = "가슴"
    case back = "등"
    case shoulders = "어깨"
    case cardio = "유산소"
    case legs = "다리"
    case butt = "엉덩이"
    
    var emoji: String {
            switch self {
            case .arms: return "💪"
            case .chest: return "🦍"
            case .back: return "🐢"
            case .shoulders: return "🙆‍♂️"
            case .cardio: return "🏃"
            case .legs: return "🦵"
            case .butt: return "🍑"
            }
        }
}
