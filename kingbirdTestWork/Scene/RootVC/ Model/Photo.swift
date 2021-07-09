//
//  Photo.swift
//  kingbirdTestWork
//
//  Created by Oleg on 7/8/21.
//

import UIKit

struct Photo: Decodable {
    let id: String?
    let author: String?
    let width: Int?
    let height: Int?
    let url: String?
    let downloadUrl: String?
}
