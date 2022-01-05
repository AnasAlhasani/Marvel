//
//  PassthroughSubject.swift
//  Marvel
//
//  Created by Anas Alhasani on 19/12/2021.
//  Copyright © 2021 Anas Alhasani. All rights reserved.
//

import Combine

extension PassthroughSubject where Output == Void {
    func send() {
        send(())
    }
}
