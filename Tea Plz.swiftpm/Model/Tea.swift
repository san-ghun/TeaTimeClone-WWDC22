import Foundation
import SwiftUI

struct Tea: Identifiable, Hashable {
    
    var id: Int
    var name: String = ""
    var steepTime: Int = 0
    var temperature: Int = 0
    var steepTimeForm: String {
        get {
            "\(steepTime) minute"
        }
    }
    var temperatureForm: String {
        get {
            "\(temperature)°C"
        }
    }
    
//    let steepTimeFormatter: Formatter = {
//    }()
//    let temperatureFormatter: MeasurementFormatter = {
//    }()
    
}

