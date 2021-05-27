//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

final class CharacterDetailViewModel {
    // MARK: - Typealias

    typealias CharacterDetailState = State<CharacterDetailsItem>

    // MARK: - Properties

    private let mediaUseCase: MediaUseCase
    private(set) var character: Dynamic<CharacterItem>
    private(set) lazy var state = Dynamic<CharacterDetailState>(.populated([comicsItem, seriesItem]))
    private(set) lazy var comicsItem = CharacterDetailsItem(type: .comics)
    private(set) lazy var seriesItem = CharacterDetailsItem(type: .series)
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init / Deinit

    init(
        mediaUseCase: MediaUseCase,
        character: CharacterItem
    ) {
        self.mediaUseCase = mediaUseCase
        self.character = Dynamic(character)
    }
}

// MARK: - UseCase

extension CharacterDetailViewModel {
    func loadItems() {
        MediaType.allCases.forEach(loadItem)
    }

    private func loadItem(of type: MediaType) {
        let parameter = MediaParameter(id: character.value.model.id, type: type)
        mediaUseCase.loadMediaItems(with: parameter)
            .convertToResult()
            .sink { [weak self] result in
                switch result {
                case let .success(value):
                    let items = value.results.map(CharacterDetailsItem.MediaItem.init)
                    self?.updateItem(type: type, with: .populated(items))
                case let .failure(error):
                    self?.state.value = .error(error)
                }
            }.store(in: &cancellables)
    }

    private func updateItem(type: MediaType, with state: State<CharacterDetailsItem.MediaItem>) {
        switch type {
        case .comics:
            comicsItem.state = state
        case .series:
            seriesItem.state = state
        }
        self.state.value = .populated([comicsItem, seriesItem])
    }
}
