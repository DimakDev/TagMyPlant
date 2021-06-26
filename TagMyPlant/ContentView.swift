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
    
    @State var isPresentingScanner = false
    
    var body: some View {
        VStack {
            CBScanner(
                supportBarcode: .constant([.qr, .code128]),
                scanInterval: .constant(5.0),
                mockBarCode: .constant(BarcodeData(value:"Mocking data", type: .qr))
            ){
                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                self.isPresentingScanner = false
            }
            VStack {
                Text("Scan the code")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
