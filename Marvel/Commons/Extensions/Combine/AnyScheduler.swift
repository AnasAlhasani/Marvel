//
//  AnyScheduler.swift
//  Marvel
//
//  Created by Anas Alhasani on 05/01/2022.
//  Copyright © 2022 Anas Alhasani. All rights reserved.
//

import Combine
import CombineSchedulers

typealias AnyScheduler<S: Scheduler> = AnySchedulerOf<S>
