//
//  ViewController.swift
//  DivvyBike
//
//  Created by Emmett Hasley on 9/3/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit
import MapKit

struct Divvy : Decodable {
    let station_name : String
    let address : String
    let latitude : String
    let longitude : String
    let location : Location
    let total_docks : String
    let docks_in_service : String
    
}

struct Location : Decodable {
    let coordinates : [Float]
}

class ViewController: UIViewController, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var segmentBoy: UISegmentedControl!
    
    var stations : [String] = []
    
    var places : [MKMapItem] = []
    
    var divvy : [Divvy] = []
    
    let center = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.7)
    
    let span = MKCoordinateSpan(latitudeDelta: 0.30, longitudeDelta: 0.30)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        mapView.delegate = self
        getDivvy()
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = stations[indexPath.row]
        return cell
    }
    
    func getDivvy() {
        let url = URL(string: "https://data.cityofchicago.org/resource/aavc-b2wj.json")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    self.divvy = try JSONDecoder().decode([Divvy].self, from: data)
                    for x in self.divvy {
                        self.stations.append(x.station_name)
                        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(x.location.coordinates[1]), longitude: CLLocationDegrees(x.location.coordinates[0]))
                        let mark = MKPlacemark(coordinate: coordinate)
                        let item = MKMapItem(placemark: mark)
                        item.name = x.station_name
                        self.places.append(item)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        for x in self.places {
                            let annotation = MKPointAnnotation()
                            annotation.coordinate = x.placemark.coordinate
                            annotation.title = x.name
                            self.mapView.addAnnotation(annotation)
                        
                        }
                    }
                } catch let err {
                    print(err)
                }
            } else {
                print("yuh oh")
            }
            
        }.resume()
        
    }
    @IBAction func whenSegment(_ sender: Any) {
        if segmentBoy.selectedSegmentIndex == 0 {
            tableView.alpha = 1.0
            mapView.alpha = 0.0
        } else {
            mapView.alpha = 1.0
            tableView.alpha = 0.0
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        pin.canShowCallout = true
        return pin
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nvc = segue.destination as? NewViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let div = divvy[indexPath.row]
                nvc.divvySent = div
            }
        }
    }
}

