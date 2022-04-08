//
//  ContentView.swift
//  API Calling3
//
//  Created by KSerek on 4/5/22.
//

import SwiftUI

struct ContentView: View {
    @State private var facts = [Fact]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(facts) { fact in
                NavigationLink(
                    destination: Text("Source: \(fact.source)")
                        .padding(),
                    label: {
                        Text(fact.text)
                    })
            }
            .navigationTitle("Daily Cat Facts")
        }
        .onAppear(perform: {
            getFacts()
        })
        .alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the data"),
                  dismissButton: .default(Text("OK")))
        })
    }
    func getFacts() {
        let apiKey = "?rapidapi-key=dcdeb11b82msh92bdd760de21315p1ddd5djsnd15d938d1e5b"
        let query = "https://brianiswu-cat-facts-v1.p.rapidapi.com/facts\(apiKey)"
        if let url = URL(string: query) {
            if let data = try? Data(contentsOf: url) {
                let json = try! JSON(data: data)
                let contents = json.arrayValue
                for item in contents {
                    let text = item["text"].stringValue
                    let source = item["source"].stringValue
                    let fact = Fact(text: text, source: source)
                    facts.append(fact)
                }
                return
            }
        }
        showingAlert = true
    }
}

struct Fact: Identifiable {
    let id = UUID()
    var text: String
    var source: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
