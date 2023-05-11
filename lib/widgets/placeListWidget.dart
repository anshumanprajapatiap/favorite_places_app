import 'package:favorite_places_app/screens/placeDetailScreen.dart';
import 'package:flutter/material.dart';

import '../models/placeModel.dart';

class PlaceListWidget extends StatelessWidget {
  const PlaceListWidget({Key? key, required this.placeList}) : super(key: key);
  final List<PlaceModel> placeList;

  @override
  Widget build(BuildContext context) {
    if (placeList.isEmpty) {
      return Center(
        child: Text(
          'No places added yet',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: placeList.length,
      itemBuilder: (ctx, index) => ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(placeList[index].image),
        ),
        title: Text(
          placeList[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        subtitle: Text(
          placeList[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => PlaceDetailScreen(place: placeList[index]),
            )
          );
        },
      ),
    );
  }
}
