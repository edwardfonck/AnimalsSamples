//
//  ServiceAPI.swift
//  testing
//
//  Created by Familia Fonseca López on 05/08/20.
//  Copyright © 2020 fonseca. All rights reserved.
//

import Foundation
import Combine

class GnomesService
{
    private let urlStr = "https://raw.githubusercontent.com/rrafols/mobile_test/master/data.json"
    
    var gnomesPublishers : AnyPublisher<Gnomes,Error> {
        let url : URL = URL(string: urlStr)!
        return URLSession.shared.dataTaskPublisher(for: url).map{
            $0.data }.decode(type: Gnomes.self, decoder: JSONDecoder()).receive(on: RunLoop.main).eraseToAnyPublisher()
        }
    }
    

