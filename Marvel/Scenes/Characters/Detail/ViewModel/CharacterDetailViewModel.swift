//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {
    // MARK: Types

    typealias ListState = Marvel.ListState<CharacterDetailsItem>

    // MARK: Properties

    private let useCase: MediaUseCase
    private(set) var character: CharacterItem

    // MARK: Init / Deinit

    init(
        useCase: MediaUseCase,
        character: CharacterItem
    ) {
        self.useCase = useCase
        self.character = character
    }

    // MARK: Helpers

    private func make(from result: MediaResult, ofType type: MediaType) -> CharacterDetailsItem {
        switch result {
        case let .success(value) where value.results.isEmpty:
            return .init(type: type, state: .empty)

        case let .success(value):
            let items = value.results.map(CharacterDetailsItem.MediaItem.init)
            return .init(type: type, state: .populated(items))

        case let .failure(error):
            return .init(type: type, state: .failed(error))
        }
    }
}

// MARK: ViewModel

extension CharacterDetailViewModel: ViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Output {
        let character: AnyPublisher<CharacterItem, Never>
        let state: AnyPublisher<ListState, Never>
    }

    func transform(input: Input) -> Output {
        let loadingState = input.viewDidLoad
            .map { _ in ListState.loading }
            .eraseToAnyPublisher()

        let resultState = MediaType
            .allCases
            .publisher
            .flatMap { [useCase, character] type in
                useCase
                    .loadMediaItems(with: .init(id: character.model.id, type: type))
                    .map { [unowned self] in self.make(from: $0, ofType: type) }
            }
            .collect()
            .map { $0.sorted { $0.type.isHigherThan($1.type) } }
            .map(ListState.populated)
            .eraseToAnyPublisher()

        return Output(
            character: .just(character),
            state: Publishers
                .Merge(loadingState, resultState)
                .removeDuplicates()
                .eraseToAnyPublisher()
        )
    }
}
