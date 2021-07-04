//
//  TagMyPlantTestsMockData.swift
//  TagMyPlantTests
//
//  Created by Dmytro Kostiuk on 04.07.21.
//

import Foundation

struct MockBarcode {
    var type: String
    var content: String
}

struct MockBarcodes {
    let content: [MockBarcode]
    
    init() {
        let url = "https://api.mockaroo.com/api/9e433b50?count=5&key=88c59a10"
        let contents = fetchMockData(url: url)
        
        content = parseMockData(contents: contents!)
    }
}


private func fetchMockData(url: String) -> String! {
    guard let url = URL(string: url) else { return nil }
    
    do {
        let contents = try String(contentsOf: url, encoding: .utf8)
        return contents
    } catch {
        print("Fetch request error")
        return nil
    }
}



private func parseMockData(contents: String) -> [MockBarcode] {
    var rows = contents.components(separatedBy: "\n")
    var mockBarcodes = [MockBarcode]()
    
    let header = rows.removeFirst().components(separatedBy: ",")
    
    for row in rows {
        let columns = row.components(separatedBy: ",")
        
        if columns.count == 6 {
            let barcode0 = MockBarcode(type: header[0], content: columns[0])
            let barcode1 = MockBarcode(type: header[1], content: columns[1])
            let barcode2 = MockBarcode(type: header[2], content: columns[2])
            let barcode3 = MockBarcode(type: header[3], content: columns[3])
            let barcode4 = MockBarcode(type: header[4], content: columns[4])
            let barcode5 = MockBarcode(type: header[5], content: columns[5])
            
            mockBarcodes.append(contentsOf: [barcode0,
                                             barcode1,
                                             barcode2,
                                             barcode3,
                                             barcode4,
                                             barcode5])
        }
    }
    
    return mockBarcodes
}
