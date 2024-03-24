// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:ecommerce_bts/networking/ApiClient.dart';
import 'package:ecommerce_bts/ui/TerminateCommandeSreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:progress_dialog2/progress_dialog2.dart';

class LocationAccess extends StatefulWidget {
  LocationAccess(
      {super.key, this.havlocation, this.lats, this.longs, this.title});
  bool? havlocation;
  double? lats;
  double? longs;
  String? title;

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {
  Location location = Location();
  final Map<String, Marker> _markers = {};

  double latitude = 0;
  double longitude = 0;

  GoogleMapController? _controller;
  final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(5.44648134718451, 10.06249587982893),
    zoom: 13,
  );
  getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    LocationData currentPosition = await location.getLocation();
    latitude = currentPosition.latitude!;
    longitude = currentPosition.longitude!;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'you can add any message here',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        ),
      );
    });
  }

  navigateTolocation() async {
    log("message" + widget.lats!.toString());

    latitude = widget.lats!;
    longitude = widget.longs!;
    final marker = Marker(
      markerId: const MarkerId('myLocation'),
      position: LatLng(latitude, longitude),
      infoWindow: const InfoWindow(
        title: 'you can add any message here',
      ),
    );
    setState(() {
      _markers['myLocation'] = marker;
      _controller?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(latitude, longitude), zoom: 15),
        ),
      );
    });
  }

  @override
  void initState() {
    if (widget.havlocation == null) {
      getCurrentLocation();
    } else {
      log("message");
      navigateTolocation();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    pr.style(
        message: 'Chargement ...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: const CircularProgressIndicator(
          color: Colors.green,
        ),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progressTextStyle: const TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: const TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cliquer sur un endroit de la carte pour choisir ",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(8)),
            child: IconButton(
              onPressed: () {
                pr.show();
                ApiClient.searchCurrentPlaceFromGoogleApi(longitude, latitude)
                    .then((value) {
                  dynamic data;
                  if (value != null) {
                    data = value;
                  } else {
                    data = {
                      'title': "Lieu inconnu",
                      'idLieu': "current['place_id']",
                      'subTitle': "",
                      'longitude': longitude,
                      'latitude': latitude,
                      'status': "Ok"
                    };
                  }
                  if (widget.havlocation != null) {
                    data['title'] = widget.title;
                  }
                  pr.hide();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TerminateCommandeSreen(
                              data: data,
                            )),
                  );
                  log(data.toString());
                });
              },
              icon: const Icon(Icons.check),
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 0),
        width: double.infinity,
        height: double.infinity,
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: widget.havlocation != null
              ? CameraPosition(target: LatLng(latitude, longitude), zoom: 18)
              : _kGooglePlex,
          markers: _markers.values.toSet(),
          onTap: (LatLng latlng) {
            latitude = latlng.latitude;
            longitude = latlng.longitude;
            if (kDebugMode) {
              print(latitude);
              print(longitude);
            }
            final marker = Marker(
              markerId: const MarkerId('myLocation'),
              position: LatLng(latitude, longitude),
              infoWindow: const InfoWindow(
                title: 'Votre position',
              ),
            );
            setState(() {
              _markers['myLocation'] = marker;
            });
            _controller?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(target: LatLng(latitude, longitude), zoom: 18),
              ),
            );
          },
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
