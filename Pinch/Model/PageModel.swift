//
//  PageModel.swift
//  Pinch
//
//  Created by Murad on 9/8/24.
//

import Foundation

struct Page: Identifiable  {
    let id: Int
    let imageName : String
}

extension Page {
    var thumbnailName : String  {
        return "thumb-" + imageName
    }
}
