//
//  Color+.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI

/// RGB 색상을 생성하는 함수입니다.
func RGB(r: Int, g: Int, b: Int, opacity: CGFloat = 1) -> Color {
    return Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: opacity)
}
