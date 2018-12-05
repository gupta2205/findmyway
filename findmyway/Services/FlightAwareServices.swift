//
//  FlightAwareServices.swift
//  findmyway
//
//  Created by Megha Gupta on 12/4/18.
//  Copyright © 2018 Megha Gupta. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class FlightAwareServices {

    var FlightNumber: String = ""
    
    var z:String = ""
    var delegate:FlightAwareServices?
    
    func AlamofireCall(PNR: String, callback: @escaping (JSON) -> Void )   {
        var returnResponse: JSON = ""
        let username = "kimate"
        let password = "6ea9e24e929403785d2f2bd99684a76fda3aed14"
        let fxmlUrl = "https://flightxml.flightaware.com/json/FlightXML3/FlightInfoStatus?ident=ASA1388&include_ex_data=true"
        //"https://flightxml.flightaware.com/json/FlightXML3/AirlineFlightSchedules?start_date=1543968626&end_date=1544141426&airline=ASA"
        //"https://flightxml.flightaware.com/json/FlightXML3/WeatherConditions?airport_code=KJFK&weather_date=0&howMany=1&offset=0"
        //
       // let credential = URLCredential(user: username, password: password, persistence: URLCredential.Persistence.forSession)
        
        Alamofire.request(fxmlUrl)
           // .authenticate(usingCredential: credential)
            .authenticate(user: username, password: password)
            .responseJSON
            { response in
//            print("Request: \(String(describing: response.request))")   // original url request
//            print("Response: \(String(describing: response.response))") // http url response
//            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
//                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
//
             let swiftyJsonVar = JSON(response.result.value)
             returnResponse = swiftyJsonVar
//             print(swiftyJsonVar)
//             print(PNR)
//
            callback(returnResponse)
          
        }
        
    }
    
}
