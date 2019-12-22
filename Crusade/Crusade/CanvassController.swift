//
//  CanvassController.swift
//  Crusade
//
//  Created by Eric Ziegler on 12/22/19.
//  Copyright © 2019 Zigabytes. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

// MARK: - Constants

// TODO: EZ - Remove test code
let coord1 = CLLocationCoordinate2D(latitude: 39.186138, longitude: -84.419120) // 6428 montgomery
let coord2 = CLLocationCoordinate2D(latitude: 39.185561, longitude: -84.418072) // 6233 beech view
let coord3 = CLLocationCoordinate2D(latitude: 39.186082, longitude: -84.418373) // 6249 beech view
let coord4 = CLLocationCoordinate2D(latitude: 39.184947, longitude: -84.417002) // 6201 beech view
let coord5 = CLLocationCoordinate2D(latitude: 39.185525, longitude: -84.416428) // 6228 rogers park
let coord6 = CLLocationCoordinate2D(latitude: 39.185783, longitude: -84.416428) // 6238 rogers park
let coord7 = CLLocationCoordinate2D(latitude: 39.186267, longitude: -84.417206) // 6257 rogers park
let coord8 = CLLocationCoordinate2D(latitude: 39.186080, longitude: -84.415406) // 3510 zinsle
let coord9 = CLLocationCoordinate2D(latitude: 39.185652, longitude: -84.415135) // 3519 zinsle
let CanvassControllerId = "CanvassControllerId"
let MapPinStandardIdentifier = "MapPinStandardIdentifier"
let MapDirectionIdentifier = "MapDirectionIdentifier"
let MapSourceIdentifier = "MapSourceIdentifier"
let MapDestinationIdentifier = "MapDestinationIdentifier"

class CanvassController: UIViewController {

    // MARK: - Properties

    @IBOutlet var map: MKMapView!
    var sourceAnnotation: MKPointAnnotation?
    var destinationAnnotation: MKPointAnnotation?
    var directions: [MKRoute.Step]?
    let locationManager = CLLocationManager()
    let annotationManager = MapAnnotationManager()
    var currentLocation: CLLocation?
    var selectedCoord: CLLocationCoordinate2D?

    // MARK: - Init

    class func createController() -> CanvassController {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController: CanvassController = storyboard.instantiateViewController(withIdentifier: CanvassControllerId) as! CanvassController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        initMap()
    }

    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }

    private func initMap() {
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
        addAnnotations()
    }

    // MARK: - Actions

    @IBAction func curLocationTapped(_ sender: AnyObject) {
        moveToCurrentLocation(animated: true)
    }

    // MARK: - Map Drawing

    private func addAnnotations() {
        var annotation = MKPointAnnotation()
        annotation.coordinate = coord1
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord2
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord3
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord4
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord5
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord6
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord7
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord8
        map.addAnnotation(annotation)

        annotation = MKPointAnnotation()
        annotation.coordinate = coord9
        map.addAnnotation(annotation)

        annotationManager.removeAll()
        for curAnnotation in map.annotations {
            annotationManager.add(annotation: curAnnotation)
        }
    }

    private func updateDirectionAnnotations(source: CLLocationCoordinate2D?, destination: CLLocationCoordinate2D?) {
        var annotation = MKPointAnnotation()

        // remove previous source
        if let sourceCoord = sourceAnnotation {
            map.removeAnnotation(sourceCoord)
            sourceAnnotation = nil
        }
        // add new source
        if let source = source {
            annotation.title = NSLocalizedString(MapSourceIdentifier, comment: "Direction source marker")
            annotation.coordinate = source
            map.addAnnotation(annotation)
            sourceAnnotation = annotation
        }

        // remove previous destination
        if let destinationCoord = destinationAnnotation {
            map.removeAnnotation(destinationCoord)
            destinationAnnotation = nil
        }
        // add new destination
        if let destination = destination {
            annotation = MKPointAnnotation()
            annotation.title = NSLocalizedString(MapDestinationIdentifier, comment: "Direction destination marker")
            annotation.coordinate = destination
            map.addAnnotation(annotation)
            destinationAnnotation = annotation
        }
    }

    private func updateDirectionInstructions() {
        if let directions = directions {
            for curDirection in directions {
                // TODO: Handle displaying directions as step-by-step text
                print(curDirection.instructions)
            }
        }
    }

    private func drawRouteBetweenSelectedCoordinates() {
        if let selection = selectedCoord, let userLocation = currentLocation {
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selection, addressDictionary: nil))
            request.transportType = .walking

            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }

                var firstCoordinate: CLLocationCoordinate2D?
                var lastCoordinate: CLLocationCoordinate2D?
                self.map.removeOverlays(self.map.overlays)
                for route in unwrappedResponse.routes {
                    self.map.addOverlay(route.polyline)
                    if firstCoordinate == nil {
                        firstCoordinate = route.polyline.coordinates.first!
                    }
                    lastCoordinate = route.polyline.coordinates.last!
                    self.directions = route.steps
                }
                self.updateDirectionInstructions()
                self.updateDirectionAnnotations(source: firstCoordinate, destination: lastCoordinate)
                self.selectedCoord = nil
            }
        }
    }

    private func moveToCurrentLocation(animated: Bool = false) {
        let diameter: Double = 200
        let region = MKCoordinateRegion(center: currentLocation!.coordinate, latitudinalMeters: diameter, longitudinalMeters: diameter)
        map.setRegion(region, animated: animated)
    }

}

// MARK: - MKMapViewDelegate

extension CanvassController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation, let referencedAnnotation = annotationManager.annotationFor(guid: MapAnnotationManager.guidFor(annotation: annotation)), !(annotation is MKUserLocation) {
            selectedCoord = referencedAnnotation.coordinate
        }
        drawRouteBetweenSelectedCoordinates()
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            renderer.strokeColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.6)
            renderer.lineWidth = 5
        }
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        if let _ = annotationManager.annotationFor(guid: MapAnnotationManager.guidFor(annotation: annotation)) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MapAnnotationManager.guidFor(annotation: annotation))
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MapAnnotationManager.guidFor(annotation: annotation))
                annotationView?.canShowCallout = true
                annotationView?.image = UIImage(named: "MapPin")
            } else {
                annotationView?.annotation = annotation
            }

            return annotationView
        } else {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MapDirectionIdentifier)
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: MapDirectionIdentifier)
                annotationView?.canShowCallout = false
            } else {
                annotationView?.annotation = annotation
            }
            if annotation.title == MapDestinationIdentifier {
                annotationView?.image = UIImage(named: "DestinationPin")
            } else {
                annotationView?.image = UIImage(named: "SourcePin")
            }
            annotationView?.centerOffset = CGPoint(x: 0, y: -20)
            return annotationView
        }
    }

}

// MARK: - CLLocationManagerDelegate

extension CanvassController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let noPreviousLocation = (currentLocation == nil)
        currentLocation = locations.last
        if noPreviousLocation == true {
            moveToCurrentLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        map.camera.heading = newHeading.magneticHeading
        map.setCamera(map.camera, animated: true)
    }

}

// MARK: - MapAnnotationManager

class MapAnnotationManager {

    // MARK: - Properties

    private var annotations = [String : MKAnnotation]()
    var annotationCount: Int {
        return annotations.count
    }

    // MARK: - Helpers

    func add(annotation: MKAnnotation) {
        let guid = MapAnnotationManager.guidFor(annotation: annotation)
        annotations[guid] = annotation
    }

    func remove(annotation: MKAnnotation) {
        let guid = MapAnnotationManager.guidFor(annotation: annotation)
        annotations.removeValue(forKey: guid)
    }

    func removeAll() {
        annotations.removeAll()
    }

    func annotationFor(guid: String) -> MKAnnotation? {
        return annotations[guid]
    }

    class func guidFor(annotation: MKAnnotation) -> String {
        return "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
    }

}
