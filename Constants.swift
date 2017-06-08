//
//  Constants.swift
//  UnderTheWeather
//
//  Created by Kitish on 07/06/2017.
//  Copyright © 2017 Kitish. All rights reserved.
//

import Foundation

struct Endpoints {
    
   static let API = "http://api.openweathermap.org/data/2.5/weather?appid=3e1a6d585c2c85855f8b07cc2c1e9525&units=metric&"
    
    //"http://api.openweathermap.org/data/2.5/weather?lat=-26.17775&lon=28.026279&appid=3e1a6d585c2c85855f8b07cc2c1e9525&units=metric"
    
    enum CLError : Int {
        case LocationUnknown // location is currently unknown, but CL will keep trying
        case Denied // Access to location or ranging has been denied by the user

    }
}

