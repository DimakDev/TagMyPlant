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
            VStack(alignment: .trailing) {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.isPresentingCameraView.toggle()
                    }) {
                        HStack {
                            Image(systemName: "viewfinder")
                            Text("Start scanning")
                        }
                    }
                    .sheet(isPresented: $isPresentingCameraView) {
                        BarcodeScannerCameraView(controller: controller)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .padding(.all, 20.0)
            
        }
    }
}

struct BarcodeScannerListView: View {
    
    @ObservedObject var controller: BarcodeScannerController
    
    var body: some View {
        List(controller.barcodes, id: \.id) { barcode in
            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(spacing: 5){
                        Image(systemName: barcode.data.getImageName())
                        Text("Type")
                    }
                    .font(.caption)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                    Text(barcode.type)
                }
                VStack(alignment: .leading, spacing: 10) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Content")
                            .font(.caption)
                            .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                        Text(barcode.data.getContent())
                    }
                    if let error = barcode.error?.rawValue {
                        VStack(alignment: .leading, spacing: 5) {
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
    
    @ObservedObject var controller: BarcodeScannerController
    
    var body: some View {
        VStack{
            CBScanner(
                supportBarcode: .constant([.qr, .code39, .code128]),
                scanInterval: .constant(5.0)
            ){
                self.controller.storeBarcodeMetadata(type: $0.type.rawValue, content: $0.value)
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
//        BarcodeScannerListView(controller: BarcodeScannerController())
//        BarcodeScannerCameraView(controller: BarcodeScannerController())
    }
}
