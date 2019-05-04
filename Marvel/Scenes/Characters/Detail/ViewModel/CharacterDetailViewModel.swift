//
//  CharacterDetailViewModel.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import Promises

final class CharacterDetailViewModel {
    
    // MARK: - Properties

    private let comicUseCase: ComicUseCase
    private(set) var character: Dynamic<CharacterViewItem>
    private(set) var state = Dynamic<State<DetailViewItem>>(.loading)

    // MARK: - Init / Deinit
    
    init(
        comicUseCase: ComicUseCase,
        character: CharacterViewItem
    ) {
        self.comicUseCase = comicUseCase
        self.character = Dynamic(character)
    }
}

// MARK: - UseCase

extension CharacterDetailViewModel {

    func loadComics() {
        let parameters = character.value.comicIds.map { ComicParameter(id: $0) }
        let promises = parameters.map { comicUseCase.loadComics(with: $0) }
        all(promises).then {
            let comics = $0.map { $0.results }.flatMap { $0 }
            let viewItems = comics.map { ComicViewItem(comic: $0) }
            let items = [DetailViewItem(title: "Comics", state: .populated(viewItems))]
            self.state.value = .populated(items)
        }.catch {
            self.state.value = .error($0)
        }
    }
}
