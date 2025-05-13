//
//  Category.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case arms = "팔"
    case chest = "가슴"
    case back = "등"
    case shoulders = "어깨"
    case cardio = "유산소"
    case legs = "다리"
    case butt = "엉덩이"
}
