//
//  LogView.swift
//  ExpenseTrackertvOS
//
//  Created by Alfian Losari on 10/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogView: View {
    
    @Environment(\.managedObjectContext)
    var context
    
    @State private var sortType = SortType.date
    @State private var isAddPresented: Bool = false
    
    var body: some View {
        List {
            HStack {
                Button(action: {
                    self.isAddPresented = true
                }) {
                    HStack(spacing: 32) {
                        Spacer()
                        Image(systemName: "plus.circle")
                        Text("Add Log")
                        Spacer()
                    }
                }
                .buttonStyle(BorderedButtonStyle())
                .font(.headline)
                
                Spacer()
                SelectSortOrderView(sortType: $sortType)
            }
            
            LogListView(sortDescriptor: ExpenseLogSort(sortType: sortType, sortOrder: .descending).sortDescriptor)
        }
        .padding(.top)
        .sheet(isPresented: $isAddPresented) {
            LogFormView(context: self.context)
        }
    }
}

struct LogListView: View {
    
    @Environment(\.managedObjectContext)
    var context
    
    @State var logToEdit: ExpenseLog?
    
    init(sortDescriptor: NSSortDescriptor) {
        let fetchRequest = NSFetchRequest<ExpenseLog>(entityName: ExpenseLog.entity().name ?? "ExpenseLog")
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        _result = FetchRequest(fetchRequest: fetchRequest)
    }
    
    @FetchRequest(
        entity: ExpenseLog.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \ExpenseLog.date, ascending: false)
        ]
    )
    var result: FetchedResults<ExpenseLog>
    
    var body: some View {
        ForEach(self.result) { (log: ExpenseLog) in
            Button(action: {
                self.logToEdit = log
            }) {
                LogRowView(log: log)
            }
        }
        .sheet(item: self.$logToEdit) { (log: ExpenseLog) in
            LogFormView(
                logToEdit: log,
                context: self.context,
                name: log.name ?? "",
                amount: log.amount?.doubleValue ?? 0,
                category: Category(rawValue: log.category ?? "") ?? .food
            )
        }
    }
}

struct LogRowView: View {
    
    var log: ExpenseLog
    
    var body: some View {
        HStack {
            CategoryImageView(category: log.categoryEnum)
            VStack(alignment: .leading) {
                Text(log.nameText)
                HStack(spacing: 4) {
                    Text(log.dateText)
                    Text("-")
                    Text(log.categoryText)
                }
                .font(.caption)
            }
            Spacer()
            Text(log.amountText)
        }
        .font(.headline)
        .padding(.vertical)
    }
}


struct SelectSortOrderView: View {
    
    @Binding var sortType: SortType
    private let sortTypes: [SortType] =  [.date, .amount]
    
    var body: some View {
        HStack {
            Text("Sort by")
            Picker(selection: $sortType, label: Text("Sort by")) {
                ForEach(sortTypes) { type in
                    Text(type.rawValue.capitalized)
                        .tag(type)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.horizontal)
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
