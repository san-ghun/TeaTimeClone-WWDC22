//
//  DataSource.swift
//  TeaPlz
//
//  Created by Sanghun Park on 17.06.22.
//

import SwiftUI

class DataSource: ObservableObject {
    @Published var teas: [Tea]
    
    init(teas: [Tea]) {
        self.teas = teas
    }
}
