//
//  AssistantTab.swift
//  TeaPlz
//
//  Created by Sanghun Park on 17.06.22.
//

import SwiftUI

struct AssistantTab: View {
    
    @State var showPickAlert: Bool = false
    @State var lastPickedTea: Tea? = nil
    
    @EnvironmentObject var dataSource: DataSource
    
    var body: some View {
        NavigationView {
            TeaWheelView(dataSource.teas, action: { tea in
                lastPickedTea = tea
                showPickAlert = true
            })
                .padding()
                .navigationTitle("Assistant")
                .navigationBarTitleDisplayMode(.inline)
                .alert("Tea Selected", isPresented: $showPickAlert, presenting: lastPickedTea) { _ in
                    Button("OK") { showPickAlert = false }
                } message: { tea in
                    Text("You should have the \(tea.name). It needs to steep for \(tea.steepTimeForm) at \(tea.temperatureForm).")
                }
        }
    }
}
