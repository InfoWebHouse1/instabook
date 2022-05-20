// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instabook/controllers/controller_explore.dart';
import 'package:instabook/controllers/controller_general.dart';
import 'package:instabook/utills/utilities.dart';

class ExploreScreen extends StatelessWidget {
  final generalController = Get.put(GeneralController());
  final exploreController = Get.put(ExploreController());

  @override
  Widget build(BuildContext context) {
    print(
        "${exploreController.update_counter} ${generalController.update_counter}");
    return Obx(
      () => Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: buildSearchUser(context),
        body: buildBody(context),
      ),
    );
  }

  buildBody(context) {
    return exploreController.isExecuted.value
        ? buildSearchResults()
        : buildBoContent(context);
  }

  buildSearchUser(context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      title: TextFormField(
        controller: exploreController.searchController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search User....",
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 16.4,
          ),
          prefixIcon: Icon(Icons.account_box),
          suffixIcon: IconButton(
            icon: exploreController.isExecuted.value == true
                ? Icon(Icons.cancel)
                : Icon(Icons.search),
            onPressed: exploreController.isExecuted.value == true
                ? () {
                    exploreController.isExecuted.value = false;
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => exploreController.searchController.clear());
                  }
                : () {
                    exploreController
                        .queryData(exploreController.searchController.text)
                        .then((value) {
                      exploreController.snapshot = value;
                      exploreController.isExecuted.value = true;
                    });
                  },
          ),
        ),
      ),
    );
  }

  buildBoContent(context) {
    final orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset(
              "assets/images/search_user.jpg",
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            Text(
              "Find Users",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SafeArea(
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: exploreController.snapshot!.docs.length,
          itemBuilder: (context, index) {
            var data = exploreController.snapshot!.docs[index];
            String name = data.get("name");
            String email = data.get("email");
            var emailFirst = email.split("@");
            return GestureDetector(
              onTap: () => print(emailFirst.first),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage:
                            CachedNetworkImageProvider(data.get("imageUrl")),
                      ),
                      title: Text(
                        "${name.capitalizeFirst}",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: generalController.isThemeDark.value
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        "${emailFirst.first}",
                        style: TextStyle(
                          color: generalController.isThemeDark.value
                              ? Colors.white54
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
