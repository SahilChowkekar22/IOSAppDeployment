//
//  DigimonViewModelTests.swift
//  DigiHuntTests
//
//  Created by Sahil ChowKekar on 3/4/25.
//

import XCTest

@testable import DigiHunt

final class DigimonViewModelTests: XCTestCase {
    var digimonViewModel: DigimonViewModel!
    var fakeServiceManager: FakeAPIServiceManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        //given
        fakeServiceManager = FakeAPIServiceManager()
        digimonViewModel = DigimonViewModel(apiManager: fakeServiceManager)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        fakeServiceManager = nil
        digimonViewModel = nil
    }

    func testFetchDigimon_Success() throws {
        let expectation = XCTestExpectation(
            description: "Digimons loaded successfully")
        let duration = 2.0

        //When
        fakeServiceManager.testPath = "ValidDigimonTest"
        digimonViewModel.fetchDigimon()

        //Then
        DispatchQueue.main.async {
            XCTAssertEqual(self.digimonViewModel.digimonList.count, 209)
            XCTAssertEqual(
                self.digimonViewModel.digimonList.first?.name, "Koromon")
            XCTAssertEqual(
                self.digimonViewModel.digimonList.first?.img, "https://digimon.shadowsmith.com/img/koromon.jpg")
            XCTAssertEqual(
                self.digimonViewModel.digimonList.first?.level, "In Training")
            

            expectation.fulfill()

        }
        wait(for: [expectation], timeout: duration)

    }
    
    func testFetchDigimon_Failure() {
        
        
        let expectation = XCTestExpectation(description: "API request fails")
        digimonViewModel.fetchDigimon()
        
        let duration = 2.0
        
        //When
        fakeServiceManager.testPath = "ValidDigimonInvalidTest"
        digimonViewModel.fetchDigimon()
        
        // Then
        DispatchQueue.main.async {
            XCTAssertNotNil(self.digimonViewModel)
            XCTAssertNotEqual(self.digimonViewModel.digimonList.count, 0)
            XCTAssertEqual(
                self.digimonViewModel.digimonViewState, DigimonViewState.error(APIError.parsingError))
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: duration)
    }
    
    func testSearchDigimon_MatchingResults() {
        let expectation = XCTestExpectation(
            description: "Searching for a Digimon That Exists successfully")
        let duration = 2.0

        //When
        fakeServiceManager.testPath = "ValidDigimonTest"
        digimonViewModel.fetchDigimon()

        
        // Then
        DispatchQueue.main.async {
            XCTAssertNotNil(self.digimonViewModel)
            XCTAssertEqual(self.digimonViewModel.digimonList.count, 209)
            self.digimonViewModel.filterDigimon(searchText: "agu")
            XCTAssertEqual(self.digimonViewModel.digimonList.count, 4)
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: duration)

}
    
    func testSearchDigimon_EmptySearch() {
        let expectation = XCTestExpectation(
            description: "Searching for a INput is empty, should return the whole list")
        let duration = 2.0

        //When
        fakeServiceManager.testPath = "ValidDigimonTest"
        digimonViewModel.fetchDigimon()

        
        // Then
        DispatchQueue.main.async {
            XCTAssertNotNil(self.digimonViewModel)
            XCTAssertEqual(self.digimonViewModel.digimonList.count, 209)
            self.digimonViewModel.filterDigimon(searchText: "")
            XCTAssertEqual(self.digimonViewModel.digimonList.count, 209)
            expectation.fulfill()
            
        }
        wait(for: [expectation], timeout: duration)

}

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
