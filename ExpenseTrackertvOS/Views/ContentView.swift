//
//  ContentView.swift
//  ExpenseTrackertvOS
//
//  Created by Alfian Losari on 10/05/20.
//  Copyright © 2020 Alfian Losari. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection = 0
 
    var body: some View {
        TabView(selection: $selection){
            DashboardView()
                .tabItem {
                    HStack {
                        Image(systemName: "chart.pie")
                        Text("Dashboard")
                    }
                }
                .tag(0)
            
            LogView()
                .tabItem {
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        Text("Expenses")
                    }
                }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
