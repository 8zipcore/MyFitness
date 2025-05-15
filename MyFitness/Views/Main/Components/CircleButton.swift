//
//  CircleButton.swift
//  MyFitness
//
//  Created by 홍승아 on 5/12/25.
//

import SwiftUI

/// 회고 추가를 할 수 있도록하는 컴포넌트
struct CircleButton: View {
    
    enum ButtonType: String {
        case plus = "plus"
    }
    
    let type: ButtonType
    let action: () -> ()
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        let iconColor: Color = colorScheme == .light ? RGB(r: 86, g: 86, b: 214) : .white
        let circleColor: Color = colorScheme == .light ? .white : RGB(r: 94, g: 92, b: 230)
        let shadowColor: Color = colorScheme == .light ? .black.opacity(0.15) : .clear
        
        GeometryReader { geometry in
            Button {
                action()
            } label: {
                Circle()
                    .fill(circleColor)
                    .shadow(color: shadowColor, radius: 5)
                    .overlay {
                        Image(systemName: type.rawValue)
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(iconColor)
                            .frame(width: geometry.size.width / 2.5, height: geometry.size.width / 2.5)
                    }
            }
        }
    }
}

#Preview {
    CircleButton(type: .plus, action: { })
        .frame(width: 60, height: 60)
}
