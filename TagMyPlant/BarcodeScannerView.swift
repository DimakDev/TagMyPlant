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
    @State private var isPresentingCameraView = false
    
    var body: some View {
        ZStack {
            NavigationView{
                BarcodeScannerListView(controller: controller)
                    .navigationTitle("Scan results")
            }
            Button("Open scannerView") {
                self.isPresentingCameraView.toggle()
            }
            .sheet(isPresented: $isPresentingCameraView) {
                BarcodeScannerCameraView(controller: controller)
            }
        }
    }
}

struct BarcodeScannerListView: View {
    
    @ObservedObject var controller: BarcodeScannerController
    
    var body: some View {
        List(controller.barcodes, id: \.id) { barcode in
            if !barcode.content.isEmpty {
                Text(barcode.content[0].getType())
            }
        }
    }
}

struct BarcodeScannerCameraView: View {
    
    @ObservedObject var controller: BarcodeScannerController
    
    var body: some View {
        VStack{
            CBScanner(
                supportBarcode: .constant([.qr, .code128]),
                scanInterval: .constant(5.0)
            ){
                self.controller.storeBarcodeMetadata(barcodeType: $0.type.rawValue,
                                                     barcodeContentString: $0.value)
                print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
            }
            
        }
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
        BarcodeScannerListView(controller: BarcodeScannerController())
        BarcodeScannerCameraView(controller: BarcodeScannerController())
    }
}
