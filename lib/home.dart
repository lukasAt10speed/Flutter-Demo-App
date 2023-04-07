import 'package:cunning_document_scanner/cunning_document_scanner.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_demo/documents/documents_screen.dart';
import 'package:flutter_application_demo/providers/location_provider.dart';

import 'package:flutter_application_demo/tabs/documents_tab.dart';
import 'package:flutter_application_demo/tabs/location_tab.dart';
import 'package:flutter_application_demo/types.dart';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<TabsContent> widgetOptions = [
    TabsContent(
      title: const Text("Location"),
      widget: const LocationTab(),
    ),
    TabsContent(
      title: const Text("Documents"),
      widget: const DocumentsTab(),
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) return;
      _selectedIndex = index;
    });
  }

  void onScanDocuments() async {
    List<String> pictures;
    try {
      pictures = await CunningDocumentScanner.getPictures() ?? [];
      if (!mounted || pictures.isEmpty) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DocumentsScreen(
            documents: pictures,
          ),
        ),
      );

      setState(() {});
    } catch (exception) {
      // Handle exception here
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    bg.BackgroundGeolocation.onGeofence((geofence) {
      print('[geofence] - $geofence');

      bg.BackgroundGeolocation.geofences;
    });

    bg.BackgroundGeolocation.ready(bg.Config(
            desiredAccuracy: bg.Config.DESIRED_ACCURACY_HIGH,
            distanceFilter: 10.0,
            geofenceProximityRadius: 100,
            stopOnTerminate: false,
            startOnBoot: true,
            debug: true,
            logLevel: bg.Config.LOG_LEVEL_VERBOSE))
        .then((bg.State state) {
      if (!state.enabled) {
        bg.BackgroundGeolocation.start();
      }
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {}

  @override
  Widget build(BuildContext context) {
    final TabsContent currentTab = widgetOptions.elementAt(_selectedIndex);

    List<Location> locations = Provider.of<LocationProvider>(context).locations;

    // Setup geofences from provider locations
    for (Location location in locations) {
      bg.BackgroundGeolocation.addGeofence(bg.Geofence(
        identifier: location.name,
        latitude: location.latlon[0],
        longitude: location.latlon[1],
        radius: 200,
        notifyOnEntry: true,
        notifyOnExit: true,
        notifyOnDwell: true,
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: currentTab.title,
      ),
      body: Center(
        child: currentTab.widget,
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: onScanDocuments,
              child: const Icon(Icons.add_a_photo),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Documents',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
