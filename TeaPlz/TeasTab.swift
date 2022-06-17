//
//  TeasTab.swift
//  TeaPlz
//
//  Created by Sanghun Park on 17.06.22.
//

import SwiftUI
//import Collections

struct TeasTab: View {
    
    @EnvironmentObject var dataSource: DataSource
    
    var body: some View {
        NavigationView {
            List {
                ForEach(dataSource.teas, id: \.self) { tea in
                    VStack(alignment: .leading) {
                        Text(tea.name)
                            .bold()
                        HStack {
                            Text(tea.steepTimeForm)
                            Text("/")
                            Text(tea.temperatureForm)
                        }
                    }
                }
            }
            .navigationTitle("Teas")
        }
    }
}
