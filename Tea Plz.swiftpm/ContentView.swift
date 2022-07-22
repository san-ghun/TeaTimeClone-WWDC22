import SwiftUI

struct ContentView: View {
    @StateObject var dataSource = DataSource(teas: loadTeas())
    var body: some View {
        TabView {
            TeasTab()
                .tabItem {
                    Label("Teas", systemImage: "cup.and.saucer")
                }
                .tag(1)
            AssistantTab()
                .tabItem {
                    Label("Assistant", systemImage: "person.fill.questionmark")
                }
                .tag(2)
        }
        .environmentObject(dataSource)
        .navigationViewStyle(.stack)
    }
}
