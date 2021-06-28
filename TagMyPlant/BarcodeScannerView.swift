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
    
    var body: some View {
        ZStack {
            NavigationView{
                BarcodeScannerListView(controller: controller)
                    .navigationTitle("Scan results")
            }
            BarcodeScannerCameraView(controller: controller)
        }
    }
}

struct BarcodeScannerListView: View {
    
    @ObservedObject var controller: BarcodeScannerController
    
    private let captionOpacity: Double = 0.8
    private let stackLowSpacing: CGFloat = 5
    private let stackMiddleSpacing: CGFloat = 10
    private let stackHighSpacing: CGFloat = 20
    
    var body: some View {
        List(controller.barcodes, id: \.id) { barcode in
            HStack(alignment: .top, spacing: stackHighSpacing) {
                VStack(alignment: .leading, spacing: stackLowSpacing) {
                    HStack(spacing: stackLowSpacing){
                        Image(systemName: barcode.data.getImageName())
                        Text("Type")
                    }
                    .font(.caption)
                    .opacity(captionOpacity)
                    Text(barcode.type)
                }
                VStack(alignment: .leading, spacing: stackMiddleSpacing) {
                    VStack(alignment: .leading, spacing: stackLowSpacing) {
                        Text("Content")
                            .font(.caption)
                            .opacity(captionOpacity)
                        Text(barcode.data.getContent())
                    }
                    if let error = barcode.error?.rawValue {
                        VStack(alignment: .leading, spacing: stackLowSpacing) {
                            Text("Error: \(error)")
                        }
                        .background(Color.secondary)
                    } else if let description = barcode.data.getUrlDescription() {
//                        url want take whitespaces in string
                        if let url = URL(string: barcode.data.getContent()) {
                            Link(description, destination: url)
                                .font(.headline)
                                .foregroundColor(.accentColor)
                        }
                    }
                }
            }
        }
    }
}

struct BarcodeScannerCameraView: View {
    
    @State private var isPresentingCameraView = false
    @ObservedObject var controller: BarcodeScannerController
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    isPresentingCameraView.toggle()
                }) {
                    HStack {
                        Image(systemName: "viewfinder")
                        Text("Start scanning")
                    }
                }
                .sheet(isPresented: $isPresentingCameraView) {
                        scannerView
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(.all, 20.0)
    }
    
    var scannerView: some View {
        VStack{
            CBScanner(
                supportBarcode: .constant([.qr, .code39, .code128]),
                scanInterval: .constant(5.0)
            ){
                controller.storeBarcodeMetadata(type: $0.type.rawValue, content: $0.value)
                print("BarCodeType =",$0.type.rawValue.utf8, "Value =",$0.value.utf8)
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .font(.headline)
            .foregroundColor(Color.primary)
            .background(Color.accentColor)
            .cornerRadius(40.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct BarcodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScannerView()
//        BarcodeScannerCameraView(controller: BarcodeScannerController())
    }
}
