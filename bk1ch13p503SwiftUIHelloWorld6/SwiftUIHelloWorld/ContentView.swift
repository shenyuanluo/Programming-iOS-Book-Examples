

import SwiftUI
import Combine

class Defaults : BindableObject {
    var didChange = PassthroughSubject<Void, Never>()
    var username : String {
        get {
            UserDefaults.standard.string(forKey: "name") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "name")
            self.didChange.send()
        }
    }
}

struct ContentView : View {
    @State var isHello = true
    @ObjectBinding var defaults = Defaults()
    var greeting : String {
        self.isHello ? "Hello" : "Goodbye"
    }
    var body: some View {
        VStack {
            PresentationLink(
                "Show Message",
                destination: Greeting(
                    greeting:self.greeting,
                    username:self.$defaults.username
                )
            )
            Spacer()
            Text(self.defaults.username.isEmpty ? "" : greeting + ", " + self.defaults.username)
            Spacer()
            Toggle("Friendly", isOn: self.$isHello)
        }.frame(width: 150, height: 100)
            .padding(20)
            .background(Color.yellow)
    }
}

struct Greeting : View {
    let greeting : String
    @Binding var username : String
    var body: some View {
        VStack {
            Text(greeting + ", " + username)
            TextField("Your Name", text:$username)
                .frame(width:200)
                .textFieldStyle(.roundedBorder)
        }.padding(20)
            .background(Color.green)
    }

}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif