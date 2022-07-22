import SwiftUI

class DataSource: ObservableObject {
    @Published var teas: [Tea]
    
    init(teas: [Tea]) {
        self.teas = teas
    }
}
