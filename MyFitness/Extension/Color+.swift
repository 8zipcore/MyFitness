//
//  Color+.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI

func RGB(r: Int, g: Int, b: Int, opacity: CGFloat = 1) -> Color {
    return Color(red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: opacity)
}
