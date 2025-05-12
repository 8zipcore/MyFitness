//
//  SearchView.swift
//  MyFitness
//
//  Created by 하재준 on 5/12/25.
//

import SwiftUI

// 검색뷰
struct SearchView: View {
    
    @State var keyword: String = ""

    
    var body: some View {
        NavigationStack {
            
            List {
                
            }
            .navigationTitle("검색")
            .searchable(text: $keyword, prompt: "운동 기록을 검색하세요")


        }
        .navigationBarBackButtonHidden(true)

    }
}

#Preview {
    SearchView()
}
