//
//  GnomeModel.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation

struct Gnomes : Decodable {
    let Brastlewark : [Gnome]
}
struct Gnome : Decodable {
    let id : Int
    let name : String
    let thumbnail : String
    let age : Int
    let weight : Float
    let height : Float
    let hair_color : String
    let professions : [String]
    let friends : [String]
}
