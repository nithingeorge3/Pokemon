//
//  GameviewTests.swift
//  PokemonTests
//
//  Created by Nitin George on 13/03/2025.
//

import XCTest
import SwiftUI
import SnapshotTesting

@testable import Pokemon

@MainActor
final class PokemonGameViewTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        
        UIView.setAnimationsEnabled(false)
    }
       
    func testPokemonPlayView_loading() {
        let viewModel = PreviewPlayViewModel.loading
        let view = PokemonPlayView(viewModel: viewModel)
            .frame(width: 375, height: 812)
        
        assertSnapshot(
            matching: view.toVC(),
            as: .image(on: .iPhone13Mini(.portrait)),
            named: "PokemonPlay_loading"
        )
    }

    func testPokemonPlayView_correctAnswer() {
        let viewModel = PreviewPlayViewModel.correctAnswer
        let view = PokemonPlayView(viewModel: viewModel)
            .frame(width: 375, height: 812)
        
        assertSnapshot(
            matching: view.toVC(),
            as: .image(on: .iPhone13Mini(.portrait)),
            named: "PokemonPlay_correctAnswer"
        )
    }
    
    func testPokemonPlayView_wrongAnswer() {
        let viewModel = PreviewPlayViewModel.wrongAnswer
        let view = PokemonPlayView(viewModel: viewModel)
            .frame(width: 375, height: 812)
        
        assertSnapshot(
            matching: view.toVC(),
            as: .image(on: .iPhone13Mini(.portrait)),
            named: "PokemonPlay_wrongAnswer"
        )
    }
}
