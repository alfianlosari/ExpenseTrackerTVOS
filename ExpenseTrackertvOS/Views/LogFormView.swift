//
//  LogFormView.swift
//  ExpenseTrackertvOS
//
//  Created by Alfian Losari on 10/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI
import CoreData

struct LogFormView: View {
    
    var logToEdit: ExpenseLog?
    var context: NSManagedObjectContext
        
    @State var name: String = ""
    @State var amount: Double = 0
    @State var category: Category = .utilities
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var title: String {
        logToEdit == nil ? "Create Expense Log" : "Edit Expense Log"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Name")
                        Spacer()
                        TextField("Name", text: $name)
                    }
                    
                    HStack {
                        Text("Amount")
                        Spacer()
                        TextField("Amount", value: $amount, formatter: Utils.numberFormatter)
                    }
                    
                    Picker(selection: $category, label: Text("Category")) {
                        ForEach(Category.allCases) { category in
                            HStack {
                                CategoryImageView(category: category)
                                Text(category.rawValue.capitalized)
                            }
                            .tag(category)
                        }
                    }
                }
                
                Section {
                    Button(action: self.onSaveClicked) {
                        HStack {
                            Spacer()
                            Text("Save")
                            Spacer()
                        }
                    }
                    
                    if self.logToEdit != nil {
                        Button(action: self.onDeleteClicked) {
                            HStack {
                                Spacer()
                                Text("Delete")
                                    .foregroundColor(Color.red)
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
        }
    }
    
    private func onSaveClicked() {
        let log: ExpenseLog
        if let logToEdit = self.logToEdit {
            log = logToEdit
        } else {
            log = ExpenseLog(context: self.context)
            log.id = UUID()
            log.date = Date()
        }
        
        log.name = self.name
        log.category = self.category.rawValue
        log.amount = NSDecimalNumber(value: self.amount)
        do {
            try context.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func onDeleteClicked() {
        guard let logToEdit = self.logToEdit else { return }
        self.context.delete(logToEdit)
        try? context.saveContext()
        self.presentationMode.wrappedValue.dismiss()
    }
}
