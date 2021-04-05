//
//  LocaitonCell.swift
//  Cars
//
//  Created by mahsun abuzeyitoğlu on 5.04.2021.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation
import SDWebImage
class LocaitonCell: UITableViewCell {
    private weak var snapshotter: MKMapSnapshotter?
  

    var geoPoint : GeoPoint?{
        didSet{
            setStaticMapView()
        }
    }
   
    let image_View : UIImageView = {
       let img = UIImageView()
        img.backgroundColor = .darkGray
      return img
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "id")
        addSubview(image_View)
      
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func takeSnapshot(of location: CLLocation) {
        snapshotter?.cancel()                         // cancel prior one, if any

        let options = MKMapSnapshotter.Options()

        options.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        options.mapType = .hybridFlyover
        options.size = image_View.bounds.size

        let snapshotter = MKMapSnapshotter(options: options)

        snapshotter.start() { snapshot, _ in
            self.image_View.image = snapshot?.image
        }

        self.snapshotter = snapshotter
    }

    private func setStaticMapView(){
       guard let coordinat = geoPoint else { return }
        
        takeSnapshot(of: CLLocation(latitude: coordinat.latitude, longitude: coordinat.longitude))
    }
   
}
