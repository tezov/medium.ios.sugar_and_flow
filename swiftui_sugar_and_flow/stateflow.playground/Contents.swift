import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State var updateTrigger = 0
    
    var body: some View {
        VStack() {
            Text("Playground StateFlow").padding(.bottom, 4)
            
            Text("trigger external update \(updateTrigger)")
                .background(.green)
                .onTapGesture {
                    updateTrigger += 1
                }
            
            SubViewStateFlow()
        }
    }
}

struct SubViewStateFlow: View {
    
    @StateFlow var stateFlow = StateFlowUpdater(
        injectedPublisher: PublisherObservable()
    )
    
    var body: some View {
        Text("Use case of StateFlow \(stateFlow.random)      ")
    }
    
}

class StateFlowUpdater: ObservableFlow {
    private let injectedPublisher: PublisherObservable
    
    init(
        injectedPublisher: PublisherObservable
    ) {
        self.injectedPublisher = injectedPublisher
        super.init()
        publish(injectedPublisher.$counterFastFlow)
        publish(injectedPublisher.$counterLowFlow)
    }

    
    var random:Int { Int.random(in: 1...10) }

}

class PublisherObservable {
    @Published var counterFastFlow = 0
    @Published var counterLowFlow = 0
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.counterFastFlow += 1
        }
        
        
        Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { [weak self] _ in
            self?.counterLowFlow += 1
        }
    }
    
}


PlaygroundPage.current.setLiveView(ContentView())
