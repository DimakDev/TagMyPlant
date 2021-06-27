//
//  BarcodeScannerController.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import Foundation

final class BarcodeScannerController: ObservableObject {
    
    @Published var barcodes: [Barcode] = []
    
    func storeBarcodeMetadata(barcodeType: String, barcodeContentString: String) {
        let parsedBarcodeContent = parseBarcodeContent(barcodeContentString: barcodeContentString)
        let barcode = Barcode(type: barcodeType, content: parsedBarcodeContent)
        self.barcodes.append(barcode)
    }
    
    func parseBarcodeContent(barcodeContentString: String) -> [BarcodeContent] {
        let detector = try! NSDataDetector(types: NSTextCheckingAllTypes)
        let range = NSRange(location: 0, length: barcodeContentString.utf16.count)
        let matches = detector.matches(in: barcodeContentString, options: [], range: range)
        
        var barcodeContent: [BarcodeContent] = []
        
        for match in matches {
            switch match.resultType {
            case .link:
                guard let url = match.url else { continue }
                if url.absoluteString.hasPrefix("mailto:") {
                    let email = url.absoluteString.replacingOccurrences(of: "mailto:", with: "")
                    let content = BarcodeContent.email(email)
                    barcodeContent.append(content)
                } else if url.absoluteString.contains("@") {
                    let email = url.absoluteString
                    let content = BarcodeContent.email(email)
                    barcodeContent.append(content)
                } else {
                    let content = BarcodeContent.url(url.absoluteString)
                    barcodeContent.append(content)
                }
            case .date:
                guard let date = match.date else { continue }
                guard let timeZone = match.timeZone else { continue }
                let duration = match.duration
                let dateString = "Date: \(date), TimeZone: \(timeZone), Duration: \(duration)"
                let content = BarcodeContent.date(dateString)
                barcodeContent.append(content)
            case .phoneNumber:
                guard let phoneNumber = match.phoneNumber else { continue }
                let content = BarcodeContent.phoneNumber(phoneNumber)
                barcodeContent.append(content)
            default:
                print(match)
            }
        }
        
        return barcodeContent
    }
}
