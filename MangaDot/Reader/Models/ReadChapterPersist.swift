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

class ReadChapterPersist: Object {
    @objc dynamic var titleId: Int = 0
    @objc dynamic var chapterId: Int = 0
    
//    init(titleId: Int, chapterId: Int) {
//        self.titleId = titleId
//        self.chapterId = chapterId
//        super.init()
//    }
//
//    required init() {
//        super.init()
////        fatalError("init() has not been implemented")
//    }
//    
//    required init(realm: RLMRealm, schema: RLMObjectSchema) {
//        fatalError("init(realm:schema:) has not been implemented")
//    }
//    
//    required init(value: Any, schema: RLMSchema) {
//        fatalError("init(value:schema:) has not been implemented")
//    }
}
