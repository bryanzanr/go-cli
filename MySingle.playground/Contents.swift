//: A SwiftUI based Playground for presenting user interface of Go-CLI

import PlaygroundSupport
import SwiftUI

// Maps Object
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

// Peoples Object
class Peoples {
    var axis: Int = 0
    var ordinate: Int = 0
    var isDriver: Bool = false
}

// Main Application
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
    @State private var arrayCount = 0
    @State private var executeButton = false
    @State private var priceCount = 0
    let user = Peoples()
    let driver = Peoples()
//    let destination = Peoples()
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
            self.priceCount = 0
        }, label: {
            Text("Refresh")
                .foregroundColor(.green)
        })

        self.inputView()
        .transition(.move(edge: .trailing))
        .animation(Animation.linear(duration: 2))
        self.executeView()
        .transition(.move(edge: .trailing))
        .animation(Animation.linear(duration: 2))
      }
    }
    
    // Choose Main Features
    func inputView() -> some View {
        Group {
            if actionButton {
                checkAction()
            }else{
                checkAction()
            }
        }
    }
    
    // Check Routing Features
    func executeView() -> some View {
        Group {
            if executeButton {
                checkRoute()
            }else{
                checkRoute()
            }
        }
    }
    
    // Manhattan Distance Algorithm
    func checkRoute() -> some View {
        Group {
            if arrayCount > 0 {
                Text("Driver Name: \(arrayCount)")
                Text("- start at (\(user.axis),\(user.ordinate))").onAppear() {
                    while (self.user.ordinate - self.driver.ordinate) > 0 {
                        if self.user.ordinate > self.driver.ordinate {
                            self.user.ordinate -= 1
                        }else{
                            self.user.ordinate += 1
                        }
                        Text("- go to (\(self.user.axis),\(self.user.ordinate))")
                        self.priceCount += 250
                    }
                    while (self.user.axis - self.driver.axis) > 0 {
                        if self.user.axis > self.driver.axis {
                            Text("- turn left")
                            self.user.axis -= 1
                        }else{
                            Text("- turn right")
                            self.user.axis += 1
                        }
                        Text("- go to (\(self.user.axis),\(self.user.ordinate))")
                        self.priceCount += 750
                    }
                }
                Text("- finish at (\(driver.axis),\(driver.ordinate))")
                Text("Price Estimate = \(priceCount)")
            }
        }
    }
    
    // Populate Map
    func checkDriver(row: Int, col: Int, icon: String) -> some View {
        Group {
            if row == Int.random(in: 0..<Int(self.slide)) && col == Int.random(in: 0..<Int(self.slide)) {
                Text(icon).onAppear() {
                    if icon == "U" {
                        self.user.axis = row
                        self.user.ordinate = col
                    }else{
                        self.driver.axis = row
                        self.driver.ordinate = col
                        self.driver.isDriver = true
                    }
                }
            }else{
                Text("-")
            }
        }
    }
    
    // Count Driver
    func countDriver(){
        if Int(self.arrayCount) > 2 {
            var temp = ""
            var i = 1
            while i < self.arrayCount - 1{
                temp += "\(i),"
                i += 1
            }
            temp += "\(self.arrayCount - 1)"
            Text("{\(temp)} = Driver")
        }else{
            Text("{\(self.arrayCount)} = Driver")
        }
    }
    
    // Main Features Switch
    func checkAction() -> some View {
        Group {
            if actionType == 1{
                //MARK:- Slider
                Slider(value: self.$slide, in: 1...2, step: 1)
                Stepper("Number of Drivers: \(arrayCount)", value: $arrayCount, in: 0...Int(slide))
                Text("Your Map: \(self.slide)")
                Text("U = User").onAppear() {
                    self.countDriver()
                }
                GridStack(rows: Int(self.slide), columns: Int(self.slide)) { row, col in
                    if Int(self.arrayCount) > 0 {
                        self.checkDriver(row: row, col: col, icon: "\(self.arrayCount)")
                        self.checkDriver(row: row, col: col, icon: "U")
                    }else{
                        self.checkDriver(row: row, col: col, icon: "U")
                    }
                }
            }else if actionType == 2 {
                //MARK:- Toggle
                Toggle(isOn: self.$showSecret) {
                 Text("Please Choose your Coordinates")
               }
                if !self.showSecret {
                   //MARK:- Stepper
                    Stepper("Coordinates_X: \(self.step)", value: self.$step, in: 0...Int(slide))
        
               }else{
                   //MARK:- Stepper
                    Stepper("Coordinates_Y: \(self.step)", value: self.$step, in: 0...Int(slide))
               }
                Button(action: {
                    self.executeButton = !self.executeButton
                }, label: {
                    Text("Confirm Your Trip")
                        .foregroundColor(.green)
                })
            }else if actionType == 3{
                //MARK:- Text Field
                TextField("Insert your name", text: self.$text)
                if !self.text.isEmpty {Text("Your name: \(self.text)")}
            }
        }
    }
    
}

// Generate View
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
