//
//  ListView.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import SwiftUI

struct ListView: View {
    
    @ObservedObject var barcodeViewModel: ContentViewModel
    
    var body: some View {
        List {
            ForEach(barcodeViewModel.barcodes, id: \.id) { barcode in
                VStack(alignment: .leading, spacing: 10) {
                    BarcodeContentView(barcode: barcode)
                    
                    HStack(alignment: .bottom) {
                        BarcodeMetadataView(barcode: barcode)
                        Spacer()
                        BarcodeLinkView(barcode: barcode)
                    }
                }
            }.onDelete(perform: deleteBarcode)
        }
    }
    
    func deleteBarcode(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach { index in
                let barcode = barcodeViewModel.barcodes[index]
                barcodeViewModel.delete(barcode)
            }
            
            barcodeViewModel.getAllBarcodes()
        }
    }
}

struct BarcodeContentView: View {
    
    var barcode: BarcodeViewModel
    
    var body: some View {
        Text(barcode.content)
            .font(.headline)
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = barcode.content
                }) {
                    Image(systemName: "doc.on.doc")
                    Text("Copy to clipboard")
                }
            }
    }
}

struct BarcodeMetadataView: View {
    
    var barcode: BarcodeViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 5){
                Image(systemName: barcode.contentIcon)
                Text("Type: \(barcode.type)")
            }
            .font(.subheadline)
            .opacity(0.5)
            
            HStack(spacing: 5){
                Image(systemName: "calendar")
                Text("Date: \(barcode.createdAt)")
            }
            .font(.subheadline)
            .opacity(0.5)
            
        }
    }
}

struct BarcodeLinkView: View {
    
    var barcode: BarcodeViewModel
    
    var body: some View {
        if let url = barcode.url {
            Link(barcode.urlDescription, destination: url)
                .font(.callout)
                .foregroundColor(.accentColor)
        } else {
            Text("Ivalid link")
                .padding(5)
                .font(.callout)
                .background(Color.secondary)
                .foregroundColor(Color.primary)
                .cornerRadius(5.0)
        }
    }
}