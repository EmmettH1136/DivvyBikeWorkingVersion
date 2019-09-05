//
//  NewViewController.swift
//  DivvyBike
//
//  Created by Emmett Hasley on 9/5/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit

class NewViewController: UIViewController {
    @IBOutlet weak var longL: UILabel!
    @IBOutlet weak var latL: UILabel!
    @IBOutlet weak var addressL: UILabel!
    @IBOutlet weak var stationNL: UILabel!
    @IBOutlet weak var tDocksL: UILabel!
    @IBOutlet weak var dInServiceL: UILabel!
    
    var divvySent : Divvy = Divvy(station_name: "", address: "", latitude: "", longitude: "", location: Location(coordinates: [0.0, 0.0]), total_docks: "", docks_in_service: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stationNL.text = divvySent.station_name
        addressL.text = divvySent.address
        tDocksL.text = "Total Docks: \(divvySent.total_docks)"
        dInServiceL.text = "Docks Available: \(divvySent.docks_in_service)"
        latL.text = divvySent.latitude
        longL.text = divvySent.longitude

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
