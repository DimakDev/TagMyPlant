//
//  TagMyPlantTests.swift
//  TagMyPlantTests
//
//  Created by Dmytro Kostiuk on 03.07.21.
//

import XCTest
@testable import TagMyPlant

class TagMyPlantTests: XCTestCase {
    var contentViewModel: ContentViewModel!
    
    override func setUpWithError() throws {
        contentViewModel = ContentViewModel()
    }
    
    func testSaveBarcode() throws {
        contentViewModel.barcodeType = "org.iso.Code39"
        contentViewModel.barcodeContent = "gBx-19-2043"
        
        contentViewModel.saveBarcode()
        
        contentViewModel.barcodeType = "org.iso.Code39"
        contentViewModel.barcodeContent = "gBx-19-2042"
        
        contentViewModel.saveBarcode()
        
        contentViewModel.barcodeType = "org.iso.Code39"
        contentViewModel.barcodeContent = "gBx-19-2041"
        
        contentViewModel.saveBarcode()
        contentViewModel.getAllBarcodes()
        
        XCTAssertEqual(contentViewModel.barcodes.count, 3)
        
        guard let barcode = contentViewModel.barcodes.last else {
            return
        }
        
        contentViewModel.deleteBarcode(barcode)
        contentViewModel.getAllBarcodes()
        
        guard let barcode = contentViewModel.barcodes.last else {
            return
        }
        
        contentViewModel.deleteBarcode(barcode)
        contentViewModel.getAllBarcodes()
        
        contentViewModel.getAllBarcodes()
        
        XCTAssertEqual(contentViewModel.barcodes.count, 1)
    }
}
