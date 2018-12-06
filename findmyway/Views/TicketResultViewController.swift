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
import CoreData

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
        
        
//        ============================ CORE DATA SAVE AND FETCH============
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //create a context from this container.
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AirportEntity", in: context)
        let Airport = NSManagedObject(entity: entity!, insertInto: context)
        
        Airport.setValue("Seattle Airport", forKey: "airportName")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AirportEntity")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                print(data.value(forKey: "airportName") as! String)
               
            }
            
        } catch {
            
            print("Failed")
        }
        
        //=================================================== For Flight Entity setup ===========
        
        
        let FlightEntity = NSEntityDescription.entity(forEntityName: "FlightEntity", in: context)
        let Flight = NSManagedObject(entity: FlightEntity!, insertInto: context)
        
        Flight.setValue(PNR, forKey: "flightNumber")
        Flight.setValue(dates, forKey:"departureDate")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        
        let request1 = NSFetchRequest<NSFetchRequestResult>(entityName: "FlightEntity")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request1.returnsObjectsAsFaults = false
        do {
            
            let result1 = try context.fetch(request1)
            let flightObject : FlightEntity = result1[0] as! FlightEntity
            
               for data in result1 as! [NSManagedObject] {

                if (data.value(forKey: "departureDate") == nil){
                    context.delete(data)
                }
                try context.save()
               // print(data.value(forKey: "flightNumber") as! String)
               
            }
            
        } catch {
            
            print("Failed")
        }
        
        
        
        //====================================================
     
       
        
       var updateTimer = Timer.scheduledTimer(timeInterval:10.0, target: self, selector:"Almofirecalling", userInfo: nil, repeats: true)
       
            
    }
    
    
    @objc func Almofirecalling () {
        print("Almofirecalling========================")
        let flightAware = FlightAwareServices()
        flightAware.AlamofireCall(PNR: PNR, dates: dates)
        { (results) in
            
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
