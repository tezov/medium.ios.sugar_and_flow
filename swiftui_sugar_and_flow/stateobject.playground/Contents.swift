import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State var updateTrigger = 0
    
    var body: some View {
        VStack() {
            Text("Playground StateObject").padding(.bottom, 4)
            Text("trigger external update \(updateTrigger)      ")
                .background(.green)
                .onTapGesture {
                    updateTrigger += 1
                }
            SubViewStateObject()
        }
    }
}

struct SubViewStateObject: View {
    @StateObject var stateFlow = StateObjectCounter()

    var body: some View { Text("Use case of StateFlow \(stateFlow.counter)") }
    
}

class StateObjectCounter:ObservableObject {
    @Published var counter = 0
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.counter += 1
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
