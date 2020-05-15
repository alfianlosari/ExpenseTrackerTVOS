//
//  CategoryimageView.swift
//  ExpenseTrackertvOS
//
//  Created by Alfian Losari on 10/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct CategoryImageView: View {
    
    let category: Category
    
    var body: some View {
        Image(systemName: category.systemNameIcon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 24, height: 24)
            .padding(.all, 12)
            .foregroundColor(category.color)
            .overlay(
                Circle()
                    .stroke(category.color, style: StrokeStyle(lineWidth: 3)
                )
        )
    }
}
