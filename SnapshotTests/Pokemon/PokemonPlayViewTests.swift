//
//  RecipeListViewModelTests.swift
//  RecipesTests
//
//  Created by Nitin George on 05/03/2025.
//

//import XCTest
//import SwiftUI
//import SnapshotTesting
//import PokemonNetworking
//
//@testable import Pokemon
//import SwiftUI
//
//@MainActor
//class RecipeDetailViewSnapshotTests: XCTestCase {
//    
//    override class func setUp() {
//        super.setUp()
//        
//        UIView.setAnimationsEnabled(false)
//    }
//        
//    func testDefaultDetailView() {
//        let viewModel = PreviewDetailViewModel.fullRecipe
//        let view = RecipeDetailView(viewModel: viewModel)
//            .frame(width: 375, height: 812)
//        
//        assertSnapshot(
//            matching: view.toVC(),
//            as: .image(on: .iPhone13Mini(.portrait)),
//            named: "DefaultRecipeDetail"
//        )
//    }
//    
//    func testNoImageView() {
//        let viewModel = PreviewDetailViewModel.noImageRecipe
//        let view = RecipeDetailView(viewModel: viewModel)
//            .frame(width: 375, height: 812)
//        
//        assertSnapshot(
//            matching: view.toVC(),
//            as: .image(on: .iPhone13Mini(.portrait)),
//            named: "NoRecipeImage"
//        )
//    }
//    
//    func testNoDescriptionView() {
//        let viewModel = PreviewDetailViewModel.noDescriptionRecipe
//        let view = RecipeDetailView(viewModel: viewModel)
//            .frame(width: 375, height: 812)
//        
//        assertSnapshot(
//            matching: view.toVC(),
//            as: .image(on: .iPhone13Mini(.portrait)),
//            named: "NoRecipeDescription"
//        )
//    }
//    
//    func testFavoriteStateView() {
//        let viewModel = PreviewDetailViewModel.fullRecipe
//        let view = RecipeDetailView(viewModel: viewModel)
//            .frame(width: 375, height: 812)
//        
//        assertSnapshot(
//            matching: view.toVC(),
//            as: .image(on: .iPhone13Mini(.portrait)),
//            named: "DefaultDetail"
//        )
//    }
//    
//    private func assertSnapshot(
//        matching value: UIViewController,
//        as snapshotting: Snapshotting<UIViewController, UIImage>,
//        named name: String? = nil,
//        file: StaticString = #file,
//        testName: String = #function,
//        line: UInt = #line
//    ) {
//        let failure = verifySnapshot(
//            of: value,
//            as: snapshotting,
//            named: name,
//            file: file,
//            testName: testName,
//            line: line
//        )
//        
//        guard let message = failure else { return }
//        XCTFail(message, file: file, line: line)
//    }
//}
