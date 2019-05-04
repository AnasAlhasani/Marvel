//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation

final class CharactersViewModel {
    
    // MARK: - Typealias
    
    typealias CharacterItemState = State<CharacterViewItem>
    
    // MARK: - Properties
    
    private let useCase: CharacterUseCase
    private(set) var state = Dynamic<CharacterItemState>(.default)
    private let throttler = Throttler(minimumDelay: 0.5)
    private var shouldLoadCharecters = true
    private var query: String?
    
    // MARK: - Init / Deinit
    
    init(useCase: CharacterUseCase) {
        self.useCase = useCase
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
        let isDefaultState = query != nil && text?.nilIfEmpty == nil
        guard !isDefaultState else { state.value = .default; return }
        query = text?.nilIfEmpty?.lowercased()
        state.value = .loading
        throttler.throttle { [weak self] in self?.loadCharecters(at: 0) }
    }
    
    func loadCharecters(at offset: Int) {
        guard shouldLoadCharecters else { return }
        shouldLoadCharecters = false
        let parameter = CharacterParameter(query: query, limit: Constant.limit, offset: offset)
        useCase.loadCharacters(with: parameter).then {
            self.handleCharecters(paginator: $0)
        }.catch {
            self.state.value = .error($0)
        }.always {
            self.shouldLoadCharecters = true
        }
    }
    
    private func handleCharecters(paginator: Paginator<[ComicCharacter]>) {
        let viewItems = paginator.results.map { CharacterViewItem($0) }

        var allItems = state.value.items
        allItems.append(contentsOf: viewItems)
        
        if paginator.hasMorePages {
            state.value = .paging(allItems, next: paginator.nextOffset)
        } else {
            state.value = .populated(allItems)
        }
    }
}
