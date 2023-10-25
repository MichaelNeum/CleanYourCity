//
//  ContentView.swift
//  CleanYourCity
//
//  Created by Michael Neumayr on 25.10.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Clean your City")
            Text("Another Text")
        }
        .padding()
    }
}

struct ContentView2: View {
    var body: some View {
        VStack {
            Text("Some bold Text").fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Text("Another Text").fontWeight(.light)
        }.frame(alignment: .top)
    }
}

#Preview {
    ContentView2()
}
