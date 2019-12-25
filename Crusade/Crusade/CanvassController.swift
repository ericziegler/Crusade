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

let CanvassControllerId = "CanvassControllerId"
let MapPinStandardIdentifier = "MapPinStandardIdentifier"
let MapDirectionIdentifier = "MapDirectionIdentifier"
let MapSourceIdentifier = "MapSourceIdentifier"
let MapDestinationIdentifier = "MapDestinationIdentifier"
let CheckmarkAlpha: CGFloat = 0.3
let InfoHeightConstant: CGFloat = 90

class CanvassController: UIViewController {

    // MARK: - Properties

    @IBOutlet var map: MKMapView!
    @IBOutlet var instructionsView: UIView!
    @IBOutlet var progressView: UIView!
    @IBOutlet var progressLabel: RegularLabel!
    @IBOutlet var infoHeightConstraint: NSLayoutConstraint!
    @IBOutlet var infoLabel: BoldLabel!
    @IBOutlet var checkButton: UIButton!
    var sourceAnnotation: MKPointAnnotation?
    var destinationAnnotation: MKPointAnnotation?
    var directions: [MKRoute.Step]?
    let locationManager = CLLocationManager()
    let routeManager = RouteManager.shared
    var currentLocation: CLLocation?
    var selectedLocation: Location?
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
        initOverlayViews()
        displaySelectedLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateAnnotations()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        instructionsView.isHidden = (routeManager.locationCount == 0) ? false : true
        updateProgressLabel()
    }

    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()
        // TODO: Implement handling user location header
//        locationManager.startUpdatingHeading()
    }

    private func initMap() {
        map.userTrackingMode = MKUserTrackingMode.followWithHeading
    }

    private func initOverlayViews() {
        let cornerRadius: CGFloat = 12
        progressView.layer.cornerRadius = cornerRadius
        instructionsView.layer.cornerRadius = cornerRadius
    }

    // MARK: - Actions

    @IBAction func curLocationTapped(_ sender: AnyObject) {
        moveToCurrentLocation(animated: true)
    }

    @IBAction func checkTapped(_ sender: AnyObject) {
        if let selection = selectedLocation {
            selection.hasKnocked = !selection.hasKnocked
            routeManager.saveRoute()
            checkButton.alpha = (selection.hasKnocked == true) ? 1 : CheckmarkAlpha
            updateProgressLabel()
        }
    }

    @IBAction func addressListTapped(_ sender: AnyObject) {
        displayAddressList()
    }

    private func displayAddressList() {
        let controller = AddressListController.createController()
        let navController = BaseNavigationController(rootViewController: controller)
        navController.modalPresentationStyle = .fullScreen
        self.present(navController, animated: true, completion: nil)
    }

    private func updateProgressLabel() {
        if routeManager.locationCount > 0 {
            progressView.isHidden = false
            progressLabel.text = "Doors Knocked: \(routeManager.knockedCount)/\(routeManager.locationCount)"
        } else {
            progressView.isHidden = true
        }
    }

    // MARK: - Map Drawing

    func updateAnnotations() {
        selectedLocation = nil
        displaySelectedLocation()
        map.removeOverlays(map.overlays)
        map.removeAnnotations(map.annotations)
        for curKey in routeManager.allKeys {
            if let location = routeManager.locationFor(guid: curKey) {
                map.addAnnotation(location.annotation)
            }
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

    private func displaySelectedLocation() {
        var height: CGFloat = 0
        if let loc = selectedLocation {
            height = InfoHeightConstant
            infoLabel.text = "\(loc.streetNumber) \(loc.streetName)"
            checkButton.alpha = (loc.hasKnocked == true) ? 1 : CheckmarkAlpha
        }
        UIView.animate(withDuration: 0.15) {
            self.infoHeightConstraint.constant = height
            self.view.layoutIfNeeded()
        }
    }

}

// MARK: - MKMapViewDelegate

extension CanvassController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation, let selectedLocation = routeManager.locationFor(guid: RouteManager.guidFor(annotation: annotation)), !(annotation is MKUserLocation) {
            selectedCoord = annotation.coordinate
            self.selectedLocation = selectedLocation
            displaySelectedLocation()
            drawRouteBetweenSelectedCoordinates()
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            renderer.strokeColor = UIColor(hex: 0xf2192e, alpha: 0.75)
            renderer.lineWidth = 5
        }
        return renderer
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        if let _ = routeManager.locationFor(guid: RouteManager.guidFor(annotation: annotation)) {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: RouteManager.guidFor(annotation: annotation))
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: RouteManager.guidFor(annotation: annotation))
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

    // TODO: Implement handling user location header
//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//        map.camera.heading = newHeading.magneticHeading
//        map.setCamera(map.camera, animated: true)
//    }

}
