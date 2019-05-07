//
//  RealmImage.swift
//  Marvel
//
//  Created by Anas Alhasani on 5/7/19.
//  Copyright © 2019 Anas Alhasani. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmImage: Object {
    @objc dynamic var url = ""
    
    convenience init(_ url: String) {
        self.init()
        self.url = url
    }
}

// MARK: - RealmRepresentable

extension Image: RealmRepresentable {
    func asRealm() -> RealmImage {
        return RealmImage(url?.absoluteString ?? "")
    }
}

// MARK: - CoreConvertible

extension RealmImage: CoreConvertible {
    func asCore() -> Image {
        return Image(URL(string: url))
    }
}
