//
//  ChapterPersist.swift
//  MangaDot
//
//  Created by Jian Chao Man on 8/3/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class ChapterPersist: Object {
    @objc dynamic private let titleId: Int
    @objc dynamic var chapterId: Int
    
    init(titleId: Int, chapterId: Int) {
        self.titleId = titleId
        self.chapterId = chapterId
        super.init()
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
}
