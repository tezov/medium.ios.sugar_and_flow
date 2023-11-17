import PlaygroundSupport
import SwiftUI

struct ContentView: View {
    @State var updateTrigger = 0
    
    var body: some View {
        VStack {
            
            CodeBlock {
                let hello = "hello"
                print(hello)
            }
            
            
            Text("Playground Remember")
            
            
            let world = "world"
            let _ = print(world)
            
        }
    }
}


PlaygroundPage.current.setLiveView(ContentView())
