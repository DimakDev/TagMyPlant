//
//  BarcodeScannerView.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import SwiftUI
import CarBode
import AVFoundation

struct BarcodeScannerView: View {
    
    @StateObject private var controller = BarcodeScannerController()
    @State private var isPresentingScanner = false
    
    var body: some View {
        ZStack {
            NavigationView{
                BarcodeListView()
                    .navigationTitle("Scan results")
            }
            Button("Open scannerView") {
                self.isPresentingScanner.toggle()
            }
            .sheet(isPresented: $isPresentingScanner) {
                BarcodeScannerView(isPresentingScanner: $isPresentingScanner)}
        }
    }
}

struct BarcodeListView: View {
    var body: some View {
        List(0..<10) {item in
            Text("\(item)")
        }
    }
}

struct BarcodeScannerView: View {
    
    @Binding var isPresentingScanner: Bool
    var body: some View {
        VStack{
            
            CBScanner(
                supportBarcode: .constant([.qr, .code128]), //Set type of barcode you want to scan
                scanInterval: .constant(5.0) //Event will trigger every 5 seconds
            ){
                print($0)
                print(type(of: $0))
                print(type(of: $0.type.rawValue))
                print(type(of: $0.value))
                //When the scanner found a barcode
                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
            }
            
        }
        //    var body: some View {
        //        VStack {
        //            Button("Close scannerView") {
        //                self.isPresentingScanner.toggle()
        //            }
        //        }
        //    }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
        BarcodeListView()
        BarcodeScannerView(isPresentingScanner: .constant(true))
    }
}
