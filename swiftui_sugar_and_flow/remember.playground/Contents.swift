import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State var updateTrigger = 0

    var body: some View {
        VStack {
            Text("Playground Remember").padding(.bottom, 4)
            SubViewRemember(onClick: { updateTrigger += 1 }) {
                VStack {
                    Text("Click the green text to update to view")
                    Text("Click trigger (update UI)) : \(updateTrigger)")
                        .background(Color.green)
                        .padding(.bottom, 4)
                }
            }.padding(.bottom, 60)
        }
    }
}

class DummyClassWhichDoNotTriggerUpdate {
    var counter = 0
}

struct SubViewRemember<Content: View>: View {
    @Remember var dummy = DummyClassWhichDoNotTriggerUpdate()

    let onClick: () -> Void
    let content: Content

    init(
        onClick: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.onClick = onClick
        self.content = content()
    }

    var body: some View {
        VStack {
            content
                .onTapGesture {
                    onClick()
                }
            Text("Click the red text to increase dummy counter with no update")
            Text("Click Dummy Counter (No Update UI) : \(dummy.counter)")
                .background(Color.red)
                .onTapGesture {
                    dummy.counter += 1
                }
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
