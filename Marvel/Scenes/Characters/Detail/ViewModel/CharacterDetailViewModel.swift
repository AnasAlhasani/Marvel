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
    
    typealias DetaiItemState = State<DetailViewItem>
    
    // MARK: - Properties

    private let comicUseCase: ComicUseCase
    private(set) var character: Dynamic<CharacterViewItem>
    private(set) lazy var state: Dynamic<DetaiItemState> = {
        let items = [DetailViewItem(type: .comics)]
        return Dynamic<DetaiItemState>(.populated(items))
    }()
    
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
        let parameter = ComicParameter(id: character.value.id)
        comicUseCase.loadComics(with: parameter).then {
            let viewItems = $0.results.map { ComicViewItem(comic: $0) }
            let items = [DetailViewItem(type: .comics, state: .populated(viewItems))]
            self.state.value = .populated(items)
        }.catch {
            self.state.value = .error($0)
        }
    }
}
