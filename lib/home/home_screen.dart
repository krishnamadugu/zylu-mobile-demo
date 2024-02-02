import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo/home/home_repo.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var employeeData;

  @override
  void initState() {
    Timer(Duration.zero, () async {
      var data = await HomeRepository.getData();
      setState(() {
        employeeData = data?.value as List;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Employee Info",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: employeeData != null
          ? SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: employeeData.length,
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var itemVal = employeeData[index];

                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SharedContainerProfileWidget(
                              onTap: () {},
                              imgUrl:
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTRHuBGu8xmYX1stZy4uMuNX3VIR5qzz10mB09vOBuCvQ&s",
                              screenWidth: MediaQuery.of(context).size.width,
                              screenHeight: MediaQuery.of(context).size.height,
                              userName:
                                  '${itemVal['firstName']} ${itemVal['lastName']}',
                              textTheme: Theme.of(context).textTheme,
                              status: itemVal['status'].toString(),
                              timeSpent: itemVal['time_spent'].toString(),
                              email: itemVal['email'].toString(),
                              containerBackgroundColor:
                                  itemVal['time_spent'] > 5 &&
                                          itemVal['status'] == 'active'
                                      ? Colors.greenAccent.withOpacity(0.3)
                                      : Colors.redAccent.withOpacity(0.3),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class SharedContainerProfileWidget extends StatelessWidget {
  const SharedContainerProfileWidget({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
    required this.userName,
    required this.textTheme,
    required this.status,
    required this.timeSpent,
    required this.email,
    required this.containerBackgroundColor,
    required this.onTap,
    required this.imgUrl,
  });

  final double screenWidth;
  final double screenHeight;
  final String userName;
  final TextTheme textTheme;
  final String status;
  final String timeSpent;
  final String email;
  final String imgUrl;
  final Color containerBackgroundColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fill,
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.15,
        decoration: BoxDecoration(
          color: containerBackgroundColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(-2, 8),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: imgUrl,
                  imageBuilder: (context, imageProvider) => Container(
                    width: screenWidth * 0.22,
                    height: boxConstraints.maxHeight * 0.7,
                    margin: const EdgeInsets.only(left: 18, top: 18),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: imageProvider,
                      ),
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "$status | joined $timeSpent years ago",
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w300,
                              fontSize: 18,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // const SizedBox(
                //   width: 8,
                // ),
                // IconButton(
                //   onPressed: onTap,
                //   icon: Padding(
                //     padding: const EdgeInsets.only(top: 14),
                //     child: Icon(
                //       Icons.arrow_forward_ios,
                //       color: Colors.black.withOpacity(0.5),
                //     ),
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
