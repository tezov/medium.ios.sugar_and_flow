import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State var updateTrigger = 0

    var body: some View {
        VStack {
            Text("Playground Lazy").padding(.bottom, 4)
                
        }
        SubViewRemember(trigger: $updateTrigger) {
            VStack {
                Text("Click the green text to update to view")
                Text("Click trigger (update UI)) : \(updateTrigger)")
                    .background(Color.green)
                    .padding(.bottom, 4)
                    .onTapGesture {
                        updateTrigger += 1
                    }
            }
        }.padding(.bottom, 60)
    }
}

class DummyClassLazy {
    var number = Int.random(in: 0 ... 1000)
}

struct SubViewRemember<Content: View>: View {
    @Lazy var dummy = DummyClassLazy()
    @Binding var trigger: Int
    @ViewBuilder let content: Content

    init(
        trigger: Binding<Int>,
        content: () -> Content
    ) {
        self._trigger = trigger
        self.content = content()
    }

    var body: some View {
        VStack {
            content
            if trigger > 10 {
                Text("Dummy number \(dummy.number)")
            }
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())
