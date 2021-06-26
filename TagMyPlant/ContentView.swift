//
//  ContentView.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import SwiftUI
import CarBode
import AVFoundation

struct ContentView: View {
    
    @State private var isPresentingScanner = false
    
    var body: some View {
        ZStack {
            NavigationView{
                CodeListView()
                    .navigationTitle("Scan results")
            }
            Button("Open scannerView") {
                self.isPresentingScanner.toggle()
            }
            .sheet(isPresented: $isPresentingScanner) {
                CodeScannerView(isPresentingScanner: $isPresentingScanner)}
        }
    }
}

struct CodeListView: View {
    var body: some View {
        List(0..<10) {item in
            Text("\(item)")
        }
    }
}

struct CodeScannerView: View {
    
    @Binding var isPresentingScanner: Bool
    
    var body: some View {
        VStack {
            Button("Close scannerView") {
                self.isPresentingScanner.toggle()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        CodeListView()
        CodeScannerView(isPresentingScanner: .constant(true))
    }
}
