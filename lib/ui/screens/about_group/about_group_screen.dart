import 'package:book/data/models/group_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AboutGroupScreen extends StatelessWidget {
  const AboutGroupScreen({
    Key? key,
    required this.group,
  }) : super(key: key);
  final GroupModel group;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Hero(
                  tag: group.id!,
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(10))),
                    child: CachedNetworkImage(
                      imageUrl: group.groupImage!,
                      fit: BoxFit.cover,
                      errorWidget: (context, s, d) =>
                          const Icon(Icons.error_outline),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  group.name!,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "الأعضاء +${group.members!.length.toString()}",
                  style: Theme.of(context).textTheme.labelLarge,
                ),const SizedBox(
                  height: 20,
                ),
                Text(
                  group.groupBio!,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
