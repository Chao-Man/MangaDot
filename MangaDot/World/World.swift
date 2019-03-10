//
//  World.swift
//  MangaDot
//
//  Created by Jian Chao Man on 2/1/19.
//  Copyright © 2019 Jian Chao Man. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

#if DEBUG
    var Current = World()
#else
    let Current = World()
#endif

struct World {
    var sources = Sources()
    var nukeConfig = NukeConfig()
    var nukeWrapper = NukeWrapper()
    var calendar = Calendar.autoupdatingCurrent
    var date = { Date() }
    var locale = Locale.autoupdatingCurrent
    var timeZone = TimeZone.autoupdatingCurrent
    var realm = try! Realm()
}
