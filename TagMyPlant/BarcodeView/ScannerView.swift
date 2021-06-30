//
//  ScannerView.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import SwiftUI
import CarBode

struct BarcodeScannerView: View {
    
    @ObservedObject var barcodeViewModel: ContentViewModel
    
    @State private var isPresentingCameraView = false
    @State private var showNotificationBanner = false
    @State private var torchIsOn = false
    
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
                .sheet(isPresented: $isPresentingCameraView, onDismiss: { torchIsOn = false }) {
                    scannerView
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .padding(20)
    }
    
    var scannerView: some View {
        ZStack{
            CBScanner(
                supportBarcode: .constant([.qr, .code39, .code128]),
                torchLightIsOn: $torchIsOn,
                scanInterval: .constant(5.0)
            ){
                barcodeViewModel.barcodeType = $0.type.rawValue
                barcodeViewModel.barcodeContent = $0.value
                
                barcodeViewModel.save()
                barcodeViewModel.getAllBarcodes()
                
                showNotificationBanner = true
                print("BarCodeType =", $0.type.rawValue, "Value =",$0.value)
            }
            onDraw: {
                let lineWidth = 2
                let lineColor = UIColor(Color.accentColor)
                let fillColor = UIColor(Color.accentColor).withAlphaComponent(0.4)
                
                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
            }
            footer
        }
    }
    
    var footer: some View {
        VStack {
            Spacer()
            HStack(alignment: .center) {
                if showNotificationBanner {
                    VStack {
                        Label("scanned", systemImage: "checkmark.circle")
                            .labelStyle(PrimaryLabelStyle())
                    }
                    .animation(.easeInOut)
                    .transition(AnyTransition.move(edge: .leading).combined(with: .opacity))
                    .onTapGesture {
                        withAnimation {
                            showNotificationBanner = false
                        }
                    }.onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showNotificationBanner = false
                            }
                        }
                    })
                    
                }
                Spacer()
                Button(action: {
                    torchIsOn.toggle()
                }) {
                    Image(systemName: torchIsOn ? "lightbulb.fill" : "lightbulb").imageScale(.large)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            
        }
        .padding(20)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(10)
            .font(.callout)
            .foregroundColor(Color.primary)
            .background(Color.accentColor)
            .cornerRadius(40.0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct PrimaryLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(configuration)
            .padding(10)
            .font(.callout)
            .foregroundColor(Color.primary)
            .background(Color.accentColor)
            .cornerRadius(40.0)
    }
}
