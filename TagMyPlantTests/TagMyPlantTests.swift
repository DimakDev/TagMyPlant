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
    var mockBarcodes: MockBarcodes!
    
    override func setUpWithError() throws {
        contentViewModel = ContentViewModel()
        mockBarcodes = MockBarcodes()
    }
    
    override func setUp() {
        for barcode in mockBarcodes.content {
            contentViewModel.barcodeType = barcode.type
            contentViewModel.barcodeContent = barcode.content
            
            contentViewModel.saveBarcode()
        }
    }
    
    func testSaveBarcode() throws {
        contentViewModel.getAllBarcodes()
        
        XCTAssertEqual(contentViewModel.barcodes.count, mockBarcodes.content.count)
    }
    
    func testDeleteBarcode() throws {
        contentViewModel.getAllBarcodes()

        for barcode in contentViewModel.barcodes {
            contentViewModel.deleteBarcode(barcode)
        }

        contentViewModel.getAllBarcodes()

        XCTAssertEqual(contentViewModel.barcodes.count, 0)
    }
}
