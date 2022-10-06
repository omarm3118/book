import 'dart:async';

import 'package:book/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);

  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? currentLocation;

  BitmapDescriptor bookIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor userIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;


  List marks=[
  LatLng(32.015477544450526, 35.86606691403308),
  LatLng(32.024619755335976, 35.86870266084874),
  LatLng(32.0167777492649, 35.86844384596919),
  LatLng(31.997900319807535, 35.85676043242173),
  LatLng(31.95675135505313, 35.931730333089384),
  LatLng(31.96957735677554, 35.87694954716848),
  LatLng(31.955695016246526, 35.856139962906326),
  LatLng(31.971647448729495, 35.93085483596239),
  LatLng(31.961838569435276, 35.916420834782926),
  LatLng(31.958481161042855, 35.890039068067836),
  LatLng(31.968801691817472, 35.90879943550968),
  ];
  void initState() {
    setCustomMarkerIcon();
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: currentLocation == null
          ?  Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Loading"),
              SizedBox(height: 20,),
              CircularProgressIndicator(color: MyColors.defaultBackgroundPurple,),
            ],
          ))
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 13.5,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  icon: userIcon,
                  position: LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                ),
                ...List.generate(marks.length, (index) =>  Marker(
                  markerId: MarkerId("source$index"),
                  position: marks[index],
                  icon: bookIcon,

                ),)

              },
              onMapCreated: (mapController) {
                _controller.complete(mapController);
              },
            ),
    );
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/book_location.png")
        .then(
          (icon) {
        bookIcon = icon;

      },
    );
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, "assets/images/user_location.png")
        .then(
          (icon) {
            userIcon = icon;
            setState(() {

            });
      },
    );
    // BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration.empty, "assets/Badge.png")
    //     .then(
    //       (icon) {
    //     currentLocationIcon = icon;
    //   },
    // );
  }
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
        setState(() {});
      },
    );
    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen(
      (newLoc) {
        currentLocation = newLoc;
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              zoom: 13.5,
              target: LatLng(
                newLoc.latitude!,
                newLoc.longitude!,
              ),
            ),
          ),
        );
        setState(() {});
      },
    );
  }
}
