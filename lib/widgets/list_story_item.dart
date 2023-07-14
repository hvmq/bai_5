
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:bai_5_/models/date_model.dart' as date_utils;
import 'package:intl/intl.dart';

import '../models/hive/story.dart';

class ListStoryItem extends StatelessWidget {
  final Story story;
  const ListStoryItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse("${story.modifiedAt}");
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(children: [
            Stack(
              children:[ CachedNetworkImage(
                imageUrl: story.image!,
                imageBuilder: (context, imageProvider) => Container(
                  width: 160,
                  height: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image:imageProvider,
                        fit: BoxFit.cover,
                      )),
                ),
                       placeholder: (context, url) => Container(
                width: 160,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey, 
              ),),
              errorWidget: (context, url, error) => Container(
                width: 160,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey, 
              ),),
              ),
              Positioned(
                width: 24,
                height: 24,
                bottom: 10,
                right: 10,
                child: InkWell(child: Image.asset("assets/detail.png")))
              ]
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                    width: 200,
                    child: Text(
                      "${story.title}",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 51, 46, 134),
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    )),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: 200,
                    child: Text(
                      "${(story.summary)?.substring(0, 50)}...",
                      style: const TextStyle(
                          color: Color.fromARGB(255, 51, 46, 134),
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    )),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "${date_utils.Date_Utils.months[dateTime.month]} ${dateTime.day}, ${dateTime.year}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 51, 46, 134),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ]),
          const Divider()
        ],
      ),
    );
  }
}
