//
//  CharactersViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/3/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Combine
import Foundation

final class CharactersViewModel: ObservableObject {
    // MARK: Types

    typealias ListState = State<CharacterItem>

    // MARK: Properties

    private let router: CharactersListRoutable
    private let useCase: CharacterUseCase
    private let scheduler: AnyScheduler<DispatchQueue>
    private var state: ListState = .idle
    private var cancellable = Set<AnyCancellable>()

    // MARK: Init / Deinit

    init(
        router: CharactersListRoutable,
        useCase: CharacterUseCase,
        scheduler: AnyScheduler<DispatchQueue>
    ) {
        self.router = router
        self.useCase = useCase
        self.scheduler = scheduler
    }

    // MARK: Helpers

    private func makeState(from result: Result<CharacterPaginator, Error>) -> ListState {
        switch result {
        case let .success(value) where value.results.isEmpty:
            return .empty

        case let .success(value):
            var items = state.items
            items.append(contentsOf: value.results.map(CharacterItem.init))
            return value.hasMorePages ? .paging(items, nextPage: value.nextOffset) : .populated(items)

        case let .failure(error):
            return .failed(error)
        }
    }
}

// MARK: ViewModel

extension CharactersViewModel: ViewModel {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let nextPage: AnyPublisher<Int, Never>
        let didSelectRow: AnyPublisher<IndexPath, Never>
        let search: AnyPublisher<String, Never>
        let didTapSearch: AnyPublisher<Void, Never>
        let didDismissSearch: AnyPublisher<Void, Never>
    }

    typealias Output = AnyPublisher<ListState, Never>

    func transform(input: Input) -> Output {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()

        input.didTapSearch.sink { [router] in router.showSearch() }.store(in: &cancellable)
        input.didDismissSearch.sink { [router] in router.dismissSearch() }.store(in: &cancellable)
        input.didSelectRow.sink { [unowned self] in self.router.showDetails(for: self.state.items[$0.row]) }.store(in: &cancellable)

        let loadingState: Output = input.viewDidLoad
            .map { _ in .loading }
            .eraseToAnyPublisher()

        let searchText = input.search
            .debounce(for: 0.3, scheduler: scheduler)
            .removeDuplicates()

        let searchState: Output = searchText
            .map { $0.isEmpty ? .idle : .loading }
            .eraseToAnyPublisher()

        let nextPage = input.nextPage
            .merge(with: .just(.zero))
            .removeDuplicates()
            .eraseToAnyPublisher()

        let characters = input.viewDidLoad
            .combineLatest(nextPage)
            .flatMapLatest { [useCase] _, offset in
                useCase.loadCharacters(with: .init(offset: offset))
            }

        let filteredCharacters = searchText
            .filter(\.isNotEmpty)
            .combineLatest(nextPage)
            .flatMapLatest { [useCase] query, offset in
                useCase.loadCharacters(with: .init(offset: offset, query: query))
            }

        // swiftlint:disable:next trailing_closure
        let resultState = Publishers
            .Merge(characters, filteredCharacters)
            .map { [unowned self] in self.makeState(from: $0) }
            .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
            .eraseToAnyPublisher()

        return Publishers
            .MergeMany(loadingState, searchState, resultState)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
