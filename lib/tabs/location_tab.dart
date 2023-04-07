import 'package:flutter/material.dart';
import 'package:flutter_application_demo/providers/location_provider.dart';
import 'package:provider/provider.dart';

class LocationTab extends StatelessWidget {
  const LocationTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    List<Location> locations = Provider.of<LocationProvider>(context).locations;

    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              itemCount: locations.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: const Icon(Icons.location_city),
                  title: Text(locations[index].name),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              margin: const EdgeInsets.only(right: 20),
              child: ElevatedButton(
                onPressed: locations.isEmpty
                    ? () {
                        Provider.of<LocationProvider>(context, listen: false)
                            .resetLocations();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(100.0, 40.0),
                ),
                child: const Text('Reset', style: TextStyle(fontSize: 18.0)),
              ),
            ),
            ElevatedButton(
              onPressed: locations.isNotEmpty
                  ? () {
                      Provider.of<LocationProvider>(context, listen: false)
                          .omitFirstLocation();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(100.0, 40.0),
              ),
              child:
                  const Text('Remove First', style: TextStyle(fontSize: 18.0)),
            )
          ]),
        )
      ],
    );
  }
}
