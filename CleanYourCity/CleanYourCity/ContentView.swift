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

struct MainView: View {
    var body: some View {
        ZStack {
            Image("JkuMap").resizable().ignoresSafeArea(.all, edges: .all)
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {}, label: {
                        Circle().fill(Color.green).frame(width:60, height:60).overlay(
                            VStack {
                                Text("---")
                                Text("---")
                                Text("---")
                            }
                        )
                    })
                    Spacer()
                    Button(action: {}, label: {
                        Circle().fill(Color.green).frame(width:60, height:60).overlay(
                            Text("+").foregroundStyle(.white).fontWeight(.bold).font(.system(size: 40))
                        )
                    })
                    NavigationView {
                        NavigationLink(destination: CameraView()) {
                            Text("Test")
                        }
                        
                    }
                }.padding(20)
            }
        }
    }
}

struct CameraView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all, edges: .all)
            
            VStack {
                Spacer()
                
                HStack {
                    Button(action: {}, label: {
                        ZStack {
                            Circle().fill(Color.white).frame(width: 75, height: 75)
                        }
                    })
                }
            }
        }
    }
}

#Preview {
    MainView()
}
