import 'package:favorite_places_app/models/placeModel.dart';
import 'package:favorite_places_app/providers/userPlaceProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/placeListWidget.dart';
import 'addPlacesScreen.dart';

class PlaceScreen extends ConsumerStatefulWidget {
  const PlaceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlaceScreen> createState() {
    return _PlaceScreenState();
  }

}

class _PlaceScreenState extends ConsumerState<PlaceScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    super.initState();
    _placesFuture = ref.read(userPlacesProvider.notifier).loadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    final userPlaces = ref.watch(userPlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Place'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlaceScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // child: PlaceListWidget(
        //   placeList: userPlaces,
        // ),
        child: FutureBuilder(
          future: _placesFuture,
          builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator(),)
              : PlaceListWidget(placeList: userPlaces,)
          ),
        ),
    );
  }
}
