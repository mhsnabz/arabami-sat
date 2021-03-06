//
//  LocationPicker.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 2.04.2021.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore
class LocationPicker: UIViewController  {
   
    
    //MARK:-variables
    var selectedPin:MKPlacemark? = nil
    var currentUser : CurrentUser
    var mapView : MKMapView!
    var isMessageLocation : Bool?
    weak var coordinatDelegate : GetCoordiant?
    weak var choosenAnnotation : MKAnnotation?
    var locationManager : CLLocationManager?
    weak var sendLocationDelegate : SendLocationDelegate?
    weak var route : MKRoute?
    let searchBar = UISearchBar()
    var pickLocationDialog = PickLocationDialog()
    
    var isSearching : Bool = false{
        didSet{
            if isSearching{
                autoComplete.showSuggestion()
            }else{
                autoComplete.handleDismiss()
            }
        }
    }
    var autoComplete = LocaitonAutoComplete()
    //MARK:-properties
    
    let centerMapButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "location").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.layer.borderWidth = 0.75
        btn.addTarget(self, action: #selector(centerMapClick), for: .touchUpInside)
        return btn
    }()
    
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = .white
        enableLocaitonMenager()
        configureViews()
        configureSearchBar()
        autoComplete.delegate = self
        pickLocationDialog.delegate = self
        
    }
    init(currentUser : CurrentUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("denit map")
    }
    //MARK:-handlers
    
    fileprivate func configureSearchBar(){
        searchBar.sizeToFit()
        searchBar.delegate = self
        showSearchBar(shouldShow: true)
    }
    
    func showSearchBar(shouldShow : Bool){
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(searchBarClick))
        }else{
            navigationItem.rightBarButtonItem = nil
            
        }
    }
    func search( shouldShow : Bool ){
        showSearchBar(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        navigationItem.titleView = shouldShow ? searchBar : nil
        isSearching = shouldShow
        if shouldShow {
            autoComplete.showSuggestion()
        }
    }
    fileprivate func configureViews(){
        setNavigationBar()
        navigationItem.title = "Pick Locaiton"
        setMapViewConfiguration()
    }
    fileprivate func setMapViewConfiguration() {
        mapView = MKMapView()
        mapView.userTrackingMode = .follow
        mapView.showsUserLocation = true
        mapView.delegate = self
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 0, marginRigth: 0, width: 0, heigth: 0)
        view.addSubview(centerMapButton)
        centerMapButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, rigth: view.rightAnchor, marginTop: 0, marginLeft: 0, marginBottom: 30, marginRigth: 30, width: 45, heigth: 45)
        centerMapButton.layer.cornerRadius = 45 / 2
    }
    //MARK:-selectors
    @objc func centerMapClick(){
        centerMapInUserLocation(loadAnnotation: false)
    }
    @objc func searchBarClick(){
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        searchBar.backgroundColor = UIColor(white: 0.95, alpha: 0.7)
        navigationItem.rightBarButtonItem = nil
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "Search Location"
        
        
    }
}
extension LocationPicker : CLLocationManagerDelegate {
    func enableLocaitonMenager(){
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        switch CLLocationManager.authorizationStatus(){
        
        case .notDetermined:
            DispatchQueue.main.async {
                let vc = PermissionConroller()
                vc.modalPresentationStyle = .fullScreen
                vc.locationManager = self.locationManager
                self.present(vc, animated: true, completion: nil)
            }
            
        case .restricted:
            print("")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("when used permission")
        @unknown default:
            print("nil")
        }
    }
}

//MARK:-MKMapViewDelegate
extension LocationPicker : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let route = self.route {
            let polyLine = route.polyline
            let lineRenderer = MKPolylineRenderer(overlay: polyLine)
            lineRenderer.strokeColor = .mainColor()
            lineRenderer.lineWidth = 3
            return lineRenderer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotion  = view.annotation else { return }
        let placemark = MKPlacemark(coordinate: annotion.coordinate, addressDictionary: nil)
        if let title = annotion.title , let subTitle = annotion.subtitle {
            pickLocationDialog.show(placeMark: placemark, selectedPlace: title ?? "", selectedAdress: subTitle ?? "")
        }
        
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        pickLocationDialog.handleDismiss()
    }
}

extension LocationPicker{
    func centerMapInUserLocation(loadAnnotation : Bool){
        guard let coordinat = locationManager?.location?.coordinate else { return }
        let coordinateReigon = MKCoordinateRegion(center: coordinat, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateReigon, animated: true)
        if loadAnnotation{
            loadAnnotationByQuery(query: "Market")
        }
    }
    func loadAnnotationByQuery( query : String){
        guard let coordinate = locationManager?.location?.coordinate else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        searchBy(natureLanguage: query, region: region, coordinate: coordinate) {[weak self] (response, err) in
            guard let sself = self else { return }
            if !sself.isSearching{
                response?.mapItems.forEach({ (mapItem) in
                    let annotion = MKPointAnnotation()
                    annotion.title = mapItem.name
                    annotion.coordinate = mapItem.placemark.coordinate
                    sself.mapView.addAnnotation(annotion)
                    
                })
            }
            
            
            
        }
    }
    func searchBy(natureLanguage : String , region : MKCoordinateRegion , coordinate : CLLocationCoordinate2D , completion : @escaping(_ reposponse : MKLocalSearch.Response? , _ Error : NSError?) ->Void){
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = natureLanguage
        request.region = region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (response, err) in
            guard let response = response else {
                completion(nil, err as NSError? )
                return
                
            }
            self.autoComplete.searchResult = response.mapItems
            completion(response,nil)
            
        }
    }
}


extension LocationPicker : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search(shouldShow: false)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("start")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("cancel")
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty || searchText == " " {
            isSearching = false
            
        }
        else
        {
            isSearching = true
            loadAnnotationByQuery(query: searchText)
            
        }
    }
}
extension LocationPicker : PickLocationDelegate{
    func didSelect(placeMark: MKPlacemark , placeName : String) {
   
            let geoPoint = GeoPoint(latitude: placeMark.coordinate.latitude, longitude: placeMark.coordinate.longitude)
            print("DEBUG :: placeName \(placeName)")
        if let delegate = sendLocationDelegate {
            delegate.getLocation(geoPoint: geoPoint , locaitonName: placeName)
            self.pickLocationDialog.handleDismiss()
            self.navigationController?.popViewController(animated: false)
        }
            
        
    }
    
    func dismissDialog() {
        mapView.annotations.forEach { (annotion) in
            if let annotion = annotion as? MKPointAnnotation{
                mapView.removeAnnotation(annotion)
            }
        }
    }
    
    
}
extension LocationPicker : AutoCompleteDelegate {
    func dismisSearchBar(isSearching: Bool) {
        self.isSearching = isSearching
    }
    
    func ZoomInPlace(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) / \(state)"
            annotation.title = placemark.name
        }
        mapView.addAnnotation(annotation)
        let coordinateReigon = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(coordinateReigon, animated: true)
        search(shouldShow: false)
    }
    
  
    
}
