//: A SwiftUI based Playground for presenting user interface of Go-CLI

import PlaygroundSupport
import SwiftUI

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct ContentView: View {
    @State private var redButton = false
    @State private var step = 0
    @State private var segment = 0
    @State private var showSecret = false
    @State private var text = ""
    @State private var slide = 0.0
    @State private var isButtonVisible = false
    @State private var actionButton = false
    @State private var actionType = 0
    var body: some View {
      VStack {
        Text("Welcome to GO-CLI!")
          .font(.headline)
        //MARK:- Text & Stepper
        Text("Please Choose your Action")
         Stepper("Input: \(actionType)", value: $actionType, in: 0...3)
        //MARK:- Button
        Button(action: {
            self.actionButton = !self.actionButton
        }, label: {
            Text("Refresh")
                .foregroundColor(.green)
        })

        self.subView()
        .transition(.move(edge: .trailing))
        .animation(Animation.linear(duration: 2))
      }
    }
    
    func subView() -> some View {
        Group {
            if actionButton {
                checkAction()
            }else{
                checkAction()
            }
        }
    }
    
    func checkAction() -> some View {
        Group {
            if actionType == 1{
                //MARK:- Slider
                Slider(value: self.$slide, in: 1...5, step: 1)
                Text("Your Map: \(self.slide)")
                GridStack(rows: Int(self.slide), columns: Int(self.slide)) { row, col in
                    Image(systemName: "\(row * 4 + col).circle")
                    Text("R\(row) C\(col)")
                }
            }else if actionType == 2 {
                //MARK:- Toggle
                Toggle(isOn: self.$showSecret) {
                 Text("Please Choose your Coordinates")
               }
                if !self.showSecret {
                   //MARK:- Stepper
                    Stepper("Coordinates_X: \(self.step)", value: self.$step, in: 0...3)
        
               }else{
                   //MARK:- Stepper
                    Stepper("Coordinates_Y: \(self.step)", value: self.$step, in: 0...3)
               }
            }else if actionType == 3{
                //MARK:- Text Field
                TextField("Insert your name", text: self.$text)
                if !self.text.isEmpty {Text("Your name: \(self.text)")}
            }
        }
    }
    
}


let contentView = ContentView()

let window = UIWindow(frame: CGRect(x: 0,
y: 0,
width: 360,
height: 1024))
let vc = UIHostingController(rootView: contentView)
window.rootViewController = vc
window.makeKeyAndVisible()
PlaygroundPage.current.liveView = window
PlaygroundPage.current.needsIndefiniteExecution = true
