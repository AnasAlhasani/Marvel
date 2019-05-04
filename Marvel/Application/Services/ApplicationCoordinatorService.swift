//
//  ApplicationCoordinatorService.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/4/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import UIKit

final class ApplicationCoordinatorService: ApplicationService {
    
    // MARK: - Properties
    
    private var window: UIWindow?
    private var applicationCoordinator: ApplicationCoordinator?

    // MARK: - Init
    
    init(with window: UIWindow?) {
        self.window = window
    }
    
    // MARK: - ApplicationService
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        let applicationCoordinator = ApplicationCoordinator(window: window)
        self.window = window
        self.applicationCoordinator = applicationCoordinator
        applicationCoordinator.start()
        
        return true
    }
    
}
