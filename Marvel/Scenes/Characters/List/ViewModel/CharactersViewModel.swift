//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

// swiftlint:disable trailing_closure

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

final class CharactersViewModel: ObservableObject {
    // MARK: Types

    typealias ListState = State<CharacterItem>

    // MARK: Properties

    private let router: CharactersListRoutable
    private let characterUseCase: CharacterUseCase
    private(set) var state: ListState = .idle
    private var cancellable = Set<AnyCancellable>()

    // MARK: Init / Deinit

    init(
        router: CharactersListRoutable,
        characterUseCase: CharacterUseCase
    ) {
        self.router = router
        self.characterUseCase = characterUseCase
    }
}

// MARK: ViewModel - Input/Output

extension CharactersViewModel: ViewModel {
    struct Input {
        private(set) var viewDidLoad: AnyPublisher<Void, Never>
        private(set) var nextPage: AnyPublisher<Int, Never>
        private(set) var didSelectRow: AnyPublisher<CharacterItem, Never>
        private(set) var search: AnyPublisher<String, Never> = .passthroughSubject
        private(set) var didTapSearch: AnyPublisher<Void, Never> = .passthroughSubject
        private(set) var didDismissSearch: AnyPublisher<Void, Never> = .passthroughSubject
    }

    typealias Output = AnyPublisher<State<CharacterItem>, Never>

    func transform(input: Input) -> Output {
        input.didTapSearch
            .sink { [router] in router.showSearch() }
            .store(in: &cancellable)

        input.didDismissSearch
            .sink { [router] in router.dismissSearch() }
            .store(in: &cancellable)

        input.didSelectRow
            .sink { [router] in router.showDetails(for: $0) }
            .store(in: &cancellable)

        let loadingState = input.viewDidLoad
            .map { _ in ListState.loading }
            .eraseToAnyPublisher()

        let searchText = input.search
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()

        let searchState: AnyPublisher<ListState, Never> = searchText
            .map { $0.isEmpty ? .idle : .loading }
            .eraseToAnyPublisher()

        let nextPage = input.nextPage
            .merge(with: .just(.zero))
            .removeDuplicates()
            .eraseToAnyPublisher()

        let result = searchText
            .filter(\.isNotEmpty)
            .combineLatest(nextPage)
            .flatMapLatest { [characterUseCase] query, offset -> AnyPublisher<Result<CharacterPaginator, Error>, Never> in
                let parameter = CharacterParameter(offset: offset, query: query)
                return characterUseCase.loadCharacters(with: parameter)
            }
            .map { [unowned self] in self.makeListState(from: $0) }
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()

        return Publishers
            .Merge3(loadingState, result, searchState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}

private extension CharactersViewModel {
    func makeListState(from result: Result<CharacterPaginator, Error>) -> State<CharacterItem> {
        switch result {
        case let .success(value):
            let items = value.results.map(CharacterItem.init)

            var allItems = state.items
            allItems.append(contentsOf: items)

            if value.hasMorePages {
                return .paging(allItems, next: value.nextOffset)
            } else {
                return .populated(allItems)
            }

        case let .failure(error):
            return .error(error)
        }
    }
}
