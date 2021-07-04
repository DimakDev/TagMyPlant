//
//  ContentView.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import SwiftUI
import CarBode

struct ContentView: View {
    
    @StateObject private var contentViewModel = ContentViewModel()
    @State private var showClearAllDataAlert = false
    
    var body: some View {
        ZStack {
            NavigationView{
                ListView(contentViewModel: contentViewModel)
                    .navigationTitle("Scan results")
                    .navigationBarItems(trailing: Button("Clear all") {
                        showClearAllDataAlert.toggle()
                    }
                    .font(.callout)
                    .alert(isPresented: $showClearAllDataAlert) {
                        if contentViewModel.barcodes.isEmpty {
                            return dismissAlert
                        } else {
                            return deleteDataAlert
                        }
                    }
                    )
            }
            BarcodeScannerView(contentViewModel: contentViewModel)
        }.onAppear(perform: {
            contentViewModel.getAllBarcodes()
        })
    }
    
    func deleteAllBarcodes() {
        withAnimation {
            contentViewModel.barcodes.forEach { barcode in
                contentViewModel.deleteBarcode(barcode)
            }
            contentViewModel.getAllBarcodes()
        }
    }
    
    var dismissAlert: Alert {
        Alert(
            title: Text("There is no data stored"),
            dismissButton: .default(Text("Got it"))
        )
    }
    
    var deleteDataAlert: Alert {
        Alert(
            title: Text("Are you sure you want to delete all data?"),
            message: Text("There is no undo"),
            primaryButton: .destructive(Text("Clear all")) {
                deleteAllBarcodes()
            },
            secondaryButton: .cancel()
        )
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
