import 'dart:async';

import 'package:fab_circular_menu_plus/fab_circular_menu_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:scholarship_application/modals/map_auto_complete_search.dart';
import 'package:scholarship_application/providers/search_places.dart';
import 'package:scholarship_application/services/map_services.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  Timer? _debounce;

  bool searchToggle = false;
  bool radiusSlider = false;
  bool pressedNear = false;
  bool cardTapped = false;
  bool getDirections = false;

  Set<Marker> _markers = Set<Marker>();

  int markerIdCounter = 1;

  TextEditingController searchController = TextEditingController();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 13,
  );

  _MapPageState() {
    _markers.add(
      Marker(
        markerId: MarkerId("_currentLocation"),
        icon: BitmapDescriptor.defaultMarker,
        position: _kGooglePlex.target,
      ),
    );
  }

  void _setMarker(LatLng point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
      markerId: MarkerId('marker_$counter'),
      position: point,
      onTap: () {},
      icon: BitmapDescriptor.defaultMarker,
    );

    setState(() {
      _markers.add(marker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _MapPageState()._markers,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  ),
                ),
                searchToggle
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(15, 40, 15, 5),
                        child: Column(
                          children: [
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  border: InputBorder.none,
                                  hintText: 'Search',
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        searchToggle = false;
                                        searchController.text = '';
                                        _markers = {};
                                        if (searchFlag.searchToggle) {
                                          searchFlag.toggleSearch();
                                        }
                                      });
                                    },
                                    icon: Icon(Icons.close),
                                  ),
                                ),
                                onChanged: (value) {
                                  if (_debounce?.isActive ?? false) {
                                    _debounce?.cancel();
                                    _debounce = Timer(
                                        Duration(milliseconds: 700), () async {
                                      if (value.length > 2) {
                                        if (!searchFlag.searchToggle) {
                                          searchFlag.toggleSearch();
                                          _markers = {};
                                        }

                                        List<AutoCompleteResult> searchResults =
                                            await MapServices()
                                                .searchPlaces(value);

                                        allSearchResults
                                            .setResults(searchResults);
                                      } else {
                                        List<AutoCompleteResult> emptyList = [];
                                        allSearchResults.setResults(emptyList);
                                      }
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(),
                searchFlag.searchToggle
                    ? allSearchResults.allReturnedResults.isNotEmpty
                        ? Positioned(
                            top: 100,
                            left: 15,
                            child: Container(
                              height: 200,
                              width: screenWidth - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: ListView(
                                children: [
                                  ...allSearchResults.allReturnedResults
                                      .map((e) => buildListItem(e, searchFlag))
                                ],
                              ),
                            ),
                          )
                        : Positioned(
                            top: 100,
                            left: 15,
                            child: Container(
                              height: 200,
                              width: screenWidth - 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white.withOpacity(0.7),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'No result to show',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      width: 125,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          searchFlag.toggleSearch();
                                        },
                                        child: Center(
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FabCircularMenuPlus(
        alignment: Alignment.bottomLeft,
        fabColor: Colors.blue.shade50,
        fabOpenColor: Colors.red.shade100,
        ringDiameter: 250,
        ringWidth: 60,
        ringColor: Colors.blue.shade50,
        fabSize: 60,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                searchToggle = true;
                radiusSlider = false;
                pressedNear = false;
                cardTapped = false;
                getDirections = false;
              });
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                searchToggle = false;
                radiusSlider = false;
                pressedNear = false;
                cardTapped = false;
                getDirections = true;
              });
            },
            icon: Icon(Icons.navigation),
          ),
        ],
      ),
    );
  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 12,
        ),
      ),
    );
    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on,
              color: Colors.green,
              size: 25,
            ),
            SizedBox(width: 4),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width - 75,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
