//
//  CommentsItemView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/13/25.
//

import SwiftUI

/// 회고 코멘트를 보여줄 컴포넌트
struct CommentsItemView: View {
    
    let date: String
    let comments: String
    let textColor: Color
    
    var body: some View {
        let comments = comments.isEmpty ? "회고를 입력해주세요." : comments
        
        VStack(alignment: .leading, spacing: 0) {
            Text(date)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(textColor)
            
            Text(comments)
                .font(.subheadline)
                .foregroundStyle(textColor)
                .padding(.top, 10)
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CommentsItemView(date: Date.now.toString(), comments: "오늘의 한줄평", textColor: .black)
}
