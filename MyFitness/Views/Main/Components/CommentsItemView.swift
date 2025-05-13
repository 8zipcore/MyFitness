//
//  CommentsItemView.swift
//  MyFitness
//
//  Created by 홍승아 on 5/13/25.
//

import SwiftUI

struct CommentsItemView: View {
    
    let date: String
    let comments: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(date)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            
            Text(comments)
                .font(.subheadline)
                .foregroundStyle(.black)
                .padding(.top, 10)
            
            Spacer()
                .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CommentsItemView(date: Date.now.toString(), comments: "오늘의 한줄평")
}
