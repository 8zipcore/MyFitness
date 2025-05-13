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
    
    var body: some View {
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
        
    }
}


func formattedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월 dd일"
    return formatter.string(from: date)
}
