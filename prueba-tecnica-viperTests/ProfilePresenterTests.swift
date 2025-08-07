//
//  ProfilePresenterTests.swift
//  prueba-tecnica-viperTests
//
//  Created by Luis Segoviano on 07/08/25.
//

import XCTest
@testable import prueba_tecnica_viper


// MARK: - Mocks

// Mock de la Vista
class MockProfileView: ProfileViewProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    var displayLastProfileCalled = false
    var displayErrorCalled = false
    var displaySuccessCalled = false
    var updateBackgroundColorCalled = false
    
    var displayedViewModel: ProfileViewModel?
    var displayedErrorMessage: String?
    
    func displayLastProfile(viewModel: ProfileViewModel) {
        displayLastProfileCalled = true
        displayedViewModel = viewModel
    }
    
    func displayError(message: String) {
        displayErrorCalled = true
        displayedErrorMessage = message
    }
    
    func displaySuccess(message: String) {
        displaySuccessCalled = true
    }
    
    func updateBackgroundColor(with color: UIColor) {
        updateBackgroundColorCalled = true
    }
}

// Mock del Interactor
class MockProfileInteractor: ProfileInteractorInputProtocol {
    
    var presenter: ProfileInteractorOutputProtocol?
    
    var fetchLastProfileCalled = false
    var saveProfileCalled = false
    var startColorListenerCalled = false
    
    func fetchLastProfile() {
        fetchLastProfileCalled = true
    }
    
    func saveProfile(name: String, avatarData: Data) {
        saveProfileCalled = true
    }
    
    func startColorListener() {
        startColorListenerCalled = true
    }
    
    func stopColorListener() {
        // No necesitamos probar esto por ahora.
    }
}


// Mock del Router
class MockProfileRouter: ProfileRouterProtocol {
    
    var navigateToGraphDetailCalled = false
    
    static func createModule() -> UIViewController {
        return UIViewController()
    }
    
    func navigateToGraphDetail(from view: ProfileViewProtocol) {
        navigateToGraphDetailCalled = true
    }
    
}


final class ProfilePresenterTests: XCTestCase {
    
    // SUT: System Under Test
    var sut: ProfilePresenter!
    
    // Mocks
    var mockView: MockProfileView!
    var mockInteractor: MockProfileInteractor!
    var mockRouter: MockProfileRouter!
    
    override func setUp() {
        super.setUp()
        
        sut = ProfilePresenter()
        mockView = MockProfileView()
        mockInteractor = MockProfileInteractor()
        mockRouter = MockProfileRouter()
        
        // Conectamos el SUT con sus mocks
        sut.view = mockView
        sut.interactor = mockInteractor
        sut.router = mockRouter
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testDidTapSaveButton_WithNilUsername_ShouldCallDisplayError() {
        
        let nilUsername: String? = nil
        let validAvatarData = Data() // Un objeto Data vacío pero no nulo.
        
        sut.didTapSaveButton(username: nilUsername, avatarData: validAvatarData)
        
        XCTAssertTrue(mockView.displayErrorCalled, "Se esperaba que displayError fuera llamado, pero no fue así.")
        
        XCTAssertFalse(mockInteractor.saveProfileCalled, "No se esperaba que saveProfile fuera llamado, pero sí se llamó.")
    }
    
    
    func testDidTapSaveButton_WithEmptyUsername_ShouldCallDisplayError() {
        let emptyUsername = ""
        let validAvatarData = Data()
        
        sut.didTapSaveButton(username: emptyUsername, avatarData: validAvatarData)
        
        XCTAssertTrue(mockView.displayErrorCalled, "Se esperaba que displayError fuera llamado para un username vacío.")
        XCTAssertFalse(mockInteractor.saveProfileCalled, "No se esperaba que saveProfile fuera llamado.")
    }
    
    func testDidTapSaveButton_WithNilAvatar_ShouldCallDisplayError() {
        let validUsername = "Test User"
        let nilAvatarData: Data? = nil
        
        sut.didTapSaveButton(username: validUsername, avatarData: nilAvatarData)
        
        XCTAssertTrue(mockView.displayErrorCalled, "Se esperaba que displayError fuera llamado para un avatar nulo.")
        XCTAssertFalse(mockInteractor.saveProfileCalled, "No se esperaba que saveProfile fuera llamado.")
    }
    
    
    func testIsValidInputExtension_WithVariousStrings() {
        XCTAssertTrue("Testuser".isValidInput(), "La cadena 'Testuser' debería ser válida, pero no lo es.")
        
        XCTAssertFalse("Test User".isValidInput(), "La cadena 'Test User' debería ser inválida, pero es válida.")
        
        XCTAssertTrue("abc".isValidInput(), "La cadena 'abc' debería ser válida.")
        
        XCTAssertFalse("abc1".isValidInput(), "La cadena 'abc1' debería ser inválida.")
    }
    
    
    func testDidRetrieveProfile_FromInteractor_ShouldFormatViewModelForView() {
        let placeholderImage = UIImage(systemName: "person.fill")!
        let profileEntity = Profile(id: "123", fullName: "John Doe", image: placeholderImage)
        
        sut.didRetrieveProfile(profileEntity)
        
        XCTAssertTrue(mockView.displayLastProfileCalled, "Expected displayLastProfile to be called.")
        
        XCTAssertNotNil(mockView.displayedViewModel, "The view model passed to the view should not be nil.")
        
        XCTAssertEqual(mockView.displayedViewModel?.displayName, "John Doe")
        XCTAssertEqual(mockView.displayedViewModel?.avatar, placeholderImage)
    }
    
    func testDidTapShowGraphsButton_ShouldCallRouter() {
        sut.didTapShowGraphsButton()
        
        XCTAssertTrue(mockRouter.navigateToGraphDetailCalled, "Expected navigateToGraphDetail to be called, but it was not.")
    }
    
    
    

}
