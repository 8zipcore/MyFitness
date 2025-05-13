//
//  Category.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case arm = "팔"
    case chest = "가슴"
    case back = "등"
    case shoulder = "어깨"
    case cardio = "유산소"
    case leg = "하체"
}
