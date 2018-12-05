//
//  TicketResultViewController.swift
//  findmyway
//
//  Created by Megha Gupta on 12/3/18.
//  Copyright © 2018 Megha Gupta. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class TicketResultViewController: UIViewController {
    
    var PNR: String = ""
   var dates: Date = Date()
    @IBOutlet weak var LabelValue: UILabel!
    @IBOutlet weak var DepartureGateLabel: UILabel!
    @IBOutlet weak var ArrivalgateLabel: UILabel!
    @IBOutlet weak var FlightNumberLabel: UILabel!
    @IBOutlet weak var FlightOandDLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       // LabelValue.text = PNR
     
        let flightAware = FlightAwareServices()
        flightAware.AlamofireCall(PNR: PNR) { (results) in
            
           var flightDetails: JSON = ""
            
          
            for i in 0...14 {
                var testDate = results["FlightInfoStatusResult"]["flights"][i]["filed_departure_time"]["date"].stringValue
                
                //convert json dates to Calender date formate
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "MM/dd/yyyy"
                let showDate = inputFormatter.date(from: testDate)
                inputFormatter.dateFormat = "yyyy-MM-dd"
                let resultString = inputFormatter.string(from: showDate!)
                let resultString2 = inputFormatter.string(from: self.dates)
                
                if (resultString == resultString2){
                     flightDetails = results["FlightInfoStatusResult"]["flights"][i]

                }
            }

            self.LabelValue.text = (flightDetails["gate_orig"]).stringValue
            self.DepartureGateLabel.text = "Departure gate : " + (flightDetails["gate_orig"]).stringValue
            self.ArrivalgateLabel.text =  "Arrival gate :" + (flightDetails["gate_dest"]).stringValue
            self.FlightNumberLabel.text = "For your Flight :" + (flightDetails["flightnumber"]).stringValue
            self.FlightOandDLabel.text = "You are flying from: " + (flightDetails["origin"]["city"]).stringValue + "To :" + (flightDetails["destination"]["city"]).stringValue
//            self.LabelValue.text = newName.stringValue;
        }
       
            
    }
    
    
    
}
