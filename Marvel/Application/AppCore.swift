//
//  AppCore.swift
//  Marvel
//
//  Created by Anas Alhasani on 29/07/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import CoreNetwork
import Foundation

// MARK: - AppCore

protocol AppCore {
    func theme() -> Theme

    func scheduler() -> AnyScheduler<DispatchQueue>

    func apiConfiguration() -> ServiceConfigurator
    func apiClient() -> APIClient

    func repository<Entity: IdentifiableEntity>() -> AnyRepository<Entity>

    func characterGateway() -> CharacterGateway
    func mediaGateway() -> MediaGateway

    func characterUseCase() -> CharacterUseCase
    func mediaUseCase() -> MediaUseCase
}

// MARK: Theme

extension AppCore {
    func theme() -> Theme {
        AppTheme()
    }
}

// MARK: Scheduler

extension AppCore {
    func scheduler() -> AnyScheduler<DispatchQueue> {
        .main
    }
}

// MARK: APIClient

extension AppCore {
    func apiConfiguration() -> ServiceConfigurator {
        ServiceConfigurator(baseURL: Config.apiURL)
    }

    func apiClient() -> APIClient {
        DefaultAPIClient(apiConfiguration())
    }
}

// MARK: Repository

extension AppCore {
    func repository<Entity: IdentifiableEntity>() -> AnyRepository<Entity> {
        RealmRepository().eraseToAnyRepository()
    }
}

// MARK: Gateway

extension AppCore {
    func characterGateway() -> CharacterGateway {
        APICharacterGateway(apiClient: apiClient())
    }

    func mediaGateway() -> MediaGateway {
        APIMarvelMediaGateway(apiClient: apiClient())
    }
}

// MARK: UseCase

extension AppCore {
    func characterUseCase() -> CharacterUseCase {
        DefaultCharacterUseCase(
            gateway: characterGateway(),
            repository: repository()
        )
    }

    func mediaUseCase() -> MediaUseCase {
        DefaultMediaUseCase(
            gateway: mediaGateway(),
            repository: repository()
        )
    }
}

// MARK: - DefaultAppCore

struct DefaultAppCore: AppCore {}
