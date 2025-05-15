//
//  ListItem.swift
//  MyFitness
//
//  Created by 하재준 on 5/14/25.
//


import SwiftUI
import SwiftData

struct ListItemView: View {
    @Environment(\.colorScheme) var colorScheme

    var item: Retrospect
    let itemViewBackgroundColor: Color
    let isFirst: Bool
    let isLast: Bool
    
    var body: some View {
        let cornerRadius: CGFloat = 10
        
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(item.writing)
                        .font(.footnote)
                        .foregroundStyle(colorScheme == .light ? .gray : .white)
                        .padding(.vertical, 4)
                    
                    Text(formattedDate(item.date))
                        .font(.callout)
                        .fontWeight(.medium)
                    
                }
                Spacer()
                if item.bookMark == true {
                    Image(systemName: "bookmark")
                }
            }
            .padding(.bottom, 5)
            
            if !isLast {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 0.5)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(itemViewBackgroundColor)
        .clipShape(
            UnevenRoundedRectangle(cornerRadii:
                                    RectangleCornerRadii(
                                        topLeading: isFirst ? cornerRadius : 0,
                                        bottomLeading: isLast ? cornerRadius : 0,
                                        bottomTrailing: isLast ? cornerRadius : 0,
                                        topTrailing: isFirst ? cornerRadius : 0))
        )
    }
}


func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
}
