//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
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

    private let router: CharactersListRoutable
    private let characterUseCase: CharacterUseCase
    private(set) var state = Dynamic<CharacterItemState>(.idle)
    private(set) var throttler: Throttler
    private(set) var shouldLoadCharecters = true
    private(set) var query: String?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init / Deinit

    init(
        router: CharactersListRoutable,
        characterUseCase: CharacterUseCase,
        throttler: Throttler
    ) {
        self.router = router
        self.characterUseCase = characterUseCase
        self.throttler = throttler
    }
}

// MARK: - Interactions

extension CharactersViewModel {
    func didSelectRow(at indexPath: IndexPath) {
        let item = state.value.items[indexPath.row]
        router.showDetails(for: item)
    }

    func didTapSearch() {
        router.showSearch()
    }

    func didTapCancelSearch() {
        router.dismissSearch()
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
        let parameter = CharacterParameter(offset: offset, query: query)

        characterUseCase.loadCharacters(with: parameter)
            .convertToResult()
            .sink { [weak self] result in
                self?.shouldLoadCharecters = true
                switch result {
                case let .success(value):
                    self?.handleCharecters(paginator: value)
                case let .failure(error):
                    self?.state.value = .error(error)
                }
            }.store(in: &cancellables)
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
