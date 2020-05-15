//
//  DashboardView.swift
//  ExpenseTrackertvOS
//
//  Created by Alfian Losari on 10/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct DashboardView: View {
    
    @Environment(\.managedObjectContext)
    var context
    
    @State private var totalExpenses: Double?
    @State private var categoriesSum: [CategorySum]?
    
    var body: some View {
        ZStack {
            HStack(alignment: .center, spacing: 64) {
                if totalExpenses != nil && totalExpenses! > 0 {
                    VStack(alignment: .center, spacing: 2) {
                        Text("Total expenses")
                            .font(.headline)
                        
                        if categoriesSum != nil  {
                            PieChartView(
                                data: categoriesSum!.map { ($0.sum, $0.category.color) },
                                style: Styles.pieChartStyleOne,
                                form: CGSize(width: 512, height: 384),
                                dropShadow: false
                            ).padding()
                        }
                        Text(totalExpenses!.formattedCurrencyText)
                            .font(.title)
                    }
                }
                
                if categoriesSum != nil {
                    List(self.categoriesSum!) { (categorySum: CategorySum) in
                        Button(action: {}) {
                            CategoryRowView(category: categorySum.category, sum: categorySum.sum)
                        }
                    }
                    .listRowBackground(Divider())
                }
            }
            .padding(.top)
            
            
            if totalExpenses == nil && categoriesSum == nil {
                Text("No expenses data\nPlease add log from the Expenses tab")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear(perform: fetchTotalSums)
    }
    
    
    func fetchTotalSums() {
        ExpenseLog.fetchAllCategoriesTotalAmountSum(context: self.context) { (results) in
            guard !results.isEmpty else {
                self.totalExpenses = nil
                self.categoriesSum = nil
                return
            }
            
            let totalSum = results.map { $0.sum }.reduce(0, +)
            self.totalExpenses = totalSum
            self.categoriesSum = results.map({ (result) -> CategorySum in
                return CategorySum(sum: result.sum, category: result.category)
            })
        }
    }
}

struct CategoryRowView: View {
    let category: Category
    let sum: Double
    
    var body: some View {
        HStack {
            CategoryImageView(category: category)
            Text(category.rawValue.capitalized)
            Spacer()
            Text(sum.formattedCurrencyText)
        }
        .font(.headline)
        .padding(.vertical)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
