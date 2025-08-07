//
//  ChartsDetailInteractorTests.swift
//  prueba-tecnica-viperTests
//
//  Created by Luis Segoviano on 06/08/25.
//

import XCTest
@testable import prueba_tecnica_viper

class MockChartsDetailPresenter: ChartsDetailInteractorOutputProtocol {
    
    var didRetrieveChartDataCalled = false
    var didFailToRetrieveChartDataCalled = false
    
    var retrievedQuestions: [Question]?
    var retrievedError: Error?
    
    func didRetrieveChartData(_ questions: [Question]) {
        didRetrieveChartDataCalled = true
        retrievedQuestions = questions
    }
    
    func didFailToRetrieveChartData(error: Error) {
        didFailToRetrieveChartDataCalled = true
        retrievedError = error
    }
}




final class ChartsDetailInteractorTests: XCTestCase {
    
    var sut: ChartsDetailInteractor!
    var mockPresenter: MockChartsDetailPresenter!

    override func setUp() {
        super.setUp()
        
        sut = ChartsDetailInteractor()
        mockPresenter = MockChartsDetailPresenter()
        sut.presenter = mockPresenter
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testExample() throws {
        sut.fetchChartData()
        
        XCTAssertTrue(mockPresenter.didRetrieveChartDataCalled, "Se esperaba que se llamara a didRetrieveChartData, pero no fue así.")
        XCTAssertFalse(mockPresenter.didFailToRetrieveChartDataCalled, "No se esperaba que se llamara a didFailToRetrieveChartData, pero sí se llamó.")
        
        XCTAssertNotNil(mockPresenter.retrievedQuestions, "Las preguntas no deberias ser nulas")
        XCTAssertEqual(mockPresenter.retrievedQuestions?.count, 4, "Se esperaban 4 preguntas del JSON, pero resulto un numero diferente")
    }
    
    
    func test_FetchChartData_WhenJSONIsMissing_ShouldCallDidFail() {
        
        let sutWithBadFileName = ChartsDetailInteractor(resourceName: "notExistentFile")
        sutWithBadFileName.presenter = mockPresenter
        
        sutWithBadFileName.fetchChartData()
        
        XCTAssertTrue(mockPresenter.didFailToRetrieveChartDataCalled, "Se esperaba a que se lllamara a didFailToRetrieveChartData")
        XCTAssertFalse(mockPresenter.didRetrieveChartDataCalled, "No se esperaba a que se llamara didRetrieveChartDataCalled")
        XCTAssertNotNil(mockPresenter.retrievedError, "El error no deberia ser nulo")
    }

}
