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

    typealias ListState = State<CharacterDetailsItem>

    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
    }

    struct Output {
        let character: AnyPublisher<CharacterItem, Never>
        let state: AnyPublisher<ListState, Never>
    }

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

    private func make(from results: [MediaResult]) -> ListState {
        let items = results.enumerated().map { index, result -> CharacterDetailsItem in
            // this is not a good way to get the type
            let type = MediaType.allCases[index]
            switch result {
            case let .success(value):
                let items = value.results.map(CharacterDetailsItem.MediaItem.init)
                return CharacterDetailsItem(type: type, state: .populated(items))

            case let .failure(error):
                return CharacterDetailsItem(type: type, state: .error(error))
            }
        }

        return .populated(items)
    }
}

// MARK: Transformation

extension CharacterDetailViewModel: ViewModel {
    func transform(input: Input) -> Output {
        let loadingState = input.viewDidLoad
            .map { _ in ListState.loading }
            .eraseToAnyPublisher()

        let resultState = MediaType.allCases
            .publisher
            .flatMap { [useCase, character] type in
                useCase.loadMediaItems(with: .init(id: character.model.id, type: type))
            }
            .collect()
            .map { [unowned self] in self.make(from: $0) }
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
