//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class CharacterDetailViewModel {
    // MARK: - Typealias

    typealias CharacterDetailState = State<CharacterDetailsViewItem>

    // MARK: - Properties

    private let mediaUseCase: MediaUseCase
    private(set) var character: Dynamic<CharacterViewItem>
    private(set) lazy var state = Dynamic<CharacterDetailState>(.populated([comicsItem, seriesItem]))
    private lazy var comicsItem = CharacterDetailsViewItem(type: .comics)
    private lazy var seriesItem = CharacterDetailsViewItem(type: .series)

    // MARK: - Init / Deinit

    init(
        mediaUseCase: MediaUseCase,
        character: CharacterViewItem
    ) {
        self.mediaUseCase = mediaUseCase
        self.character = Dynamic(character)
    }
}

// MARK: - UseCase

extension CharacterDetailViewModel {
    func loadItems() {
        loadItem(of: .comics)
        loadItem(of: .series)
    }

    private func loadItem(of type: MediaType) {
        let parameter = MediaParameter(id: character.value.id, type: type)
        mediaUseCase.loadMediaItems(with: parameter).then {
            let viewItems = $0.results.map { MediaViewItem(comic: $0) }
            self.updateItem(type: type, with: .populated(viewItems))
        }.catch {
            self.state.value = .error($0)
        }
    }

    private func updateItem(type: MediaType, with state: State<MediaViewItem>) {
        switch type {
        case .comics:
            comicsItem.state = state
        case .series:
            seriesItem.state = state
        }
        self.state.value = .populated([comicsItem, seriesItem])
    }
}
