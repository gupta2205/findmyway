//
//  ViewController.swift
//  findmyway
//
//  Created by Megha Gupta on 12/3/18.
//  Copyright © 2018 Megha Gupta. All rights reserved.
//

import UIKit

class TicketFinderViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var CalenderDate: UIDatePicker!
    @IBOutlet weak var SubmitButton: UIButton!
    @IBOutlet weak var TicketTextView: UITextView!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print("CalenderDate.date----",CalenderDate.date)
        print(CalenderDate.date.timeIntervalSince1970)
        
        TicketTextView.delegate = self
    }
    
    func isValidPNR() -> Bool {
        let ticket = TicketTextView.text!
        if(ticket.count == 6){
            return true
        } else {
            return false
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    @IBAction func ticketButtonDidBeginEditing(_ sender: Any) {
        
        let ticket = TicketTextView.text!
        
        if ticket.isEmpty {
            SubmitButton.backgroundColor = UIColor.red
            SubmitButton.isEnabled = false
        }
        if(ticket.count)>0 {
            SubmitButton.backgroundColor = UIColor.green
            SubmitButton.isEnabled = true
        }
    }
    
    
    @IBAction func CaldenderDateSelectEndEditing(_ sender: Any) {
        let newDate = CalenderDate.date.addingTimeInterval(1970)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.destination is TicketResultViewController {
            if let vc = segue.destination as? TicketResultViewController {
                vc.PNR = TicketTextView.text!
                vc.dates = CalenderDate.date
            }
        }
    }
    
    
    
}

