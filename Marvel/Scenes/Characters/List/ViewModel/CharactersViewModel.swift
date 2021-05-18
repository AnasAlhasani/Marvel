//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

protocol CharactersCoordinatorDelegate: AnyObject {
    func didTapSearch()
    func didTapCancelSearch()
    func didSelect(character: CharacterItem)
}

final class CharactersViewModel {
    // MARK: - Typealias

    typealias CharacterItemState = State<CharacterItem>

    // MARK: - Properties

    private weak var coordinator: CharactersCoordinatorDelegate?
    private let characterUseCase: CharacterUseCase
    private(set) var state = Dynamic<CharacterItemState>(.idle)
    private(set) var throttler: Throttler
    private(set) var shouldLoadCharecters = true
    private(set) var query: String?

    // MARK: - Init / Deinit

    init(
        coordinator: CharactersCoordinatorDelegate,
        characterUseCase: CharacterUseCase,
        throttler: Throttler
    ) {
        self.coordinator = coordinator
        self.characterUseCase = characterUseCase
        self.throttler = throttler
    }
}

// MARK: - Interactions

extension CharactersViewModel {
    func didSelectRow(at indexPath: IndexPath) {
        let item = state.value.items[indexPath.row]
        coordinator?.didSelect(character: item)
    }

    func didTapSearch() {
        coordinator?.didTapSearch()
    }

    func didTapCancelSearch() {
        coordinator?.didTapCancelSearch()
    }
}

// MARK: - Constants

private extension CharactersViewModel {
    enum Constant {
        static let limit = 20
    }
}

// MARK: - UseCase

extension CharactersViewModel {
    func loadCharecters(with text: String? = nil) {
        let isIdle = query != nil && text?.nilIfEmpty == nil
        guard !isIdle else { return state.value = .idle }
        query = text?.nilIfEmpty?.lowercased()
        state.value = .loading
        throttler.throttle { [weak self] in self?.loadCharecters(at: 0) }
    }

    func loadCharecters(at offset: Int) {
        guard shouldLoadCharecters else { return }
        shouldLoadCharecters = false
        let parameter = CharacterParameter(query: query, limit: Constant.limit, offset: offset)
        characterUseCase.loadCharacters(with: parameter).then {
            self.handleCharecters(paginator: $0)
        }.catch {
            self.state.value = .error($0)
        }.always {
            self.shouldLoadCharecters = true
        }
    }

    private func handleCharecters(paginator: Paginator<MarvelCharacter>) {
        let items = paginator.results.map(CharacterItem.init)

        var allItems = state.value.items
        allItems.append(contentsOf: items)

        if paginator.hasMorePages {
            state.value = .paging(allItems, next: paginator.nextOffset)
        } else {
            state.value = .populated(allItems)
        }
    }
}
