import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/common/constants/asset_constants.dart';
import 'package:flutter/material.dart';

import '../../common/constants/color_constants.dart';
import '../../common/constants/string_constants.dart';
import '../../common/utils/utility_methods.dart';

class BusinessServiceDetailsScreen extends StatefulWidget {
  final Object heroTag;
  final Map<String, dynamic> data;
  const BusinessServiceDetailsScreen({
    super.key,
    required this.heroTag,
    required this.data,
  });

  @override
  State<BusinessServiceDetailsScreen> createState() =>
      _BusinessServiceDetailsScreenState();
}

class _BusinessServiceDetailsScreenState
    extends State<BusinessServiceDetailsScreen> {
  late ScrollController _scrollController;
  bool isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset > 55 && !isCollapsed) {
        setState(() {
          isCollapsed = true;
        });
      } else if (_scrollController.offset <= 55 && isCollapsed) {
        setState(() {
          isCollapsed = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 2.0,
              floating: false,
              snap: false,
              pinned: true,
              iconTheme: IconThemeData(
                shadows: [
                  Shadow(
                    color: ColorConstants.white,
                    blurRadius: 60.0,
                  ),
                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: isCollapsed
                    ? Text(
                        widget.data['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                          color: ColorConstants.white,
                          shadows: const [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 15.0,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      )
                    : const SizedBox.shrink(),
                background: Stack(
                  children: [
                    Hero(
                      tag: widget.heroTag,
                      child: CachedNetworkImage(
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        imageUrl: widget.data['imageUrl'],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 8.0,
                        ),
                        color: Colors.black26,
                        child: Column(
                          children: [
                            Text(
                              widget.data['name'],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: ColorConstants.white,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "(${widget.data['category']})",
                              style: TextStyle(
                                fontFamily: AssetConstants.robotoFont,
                                fontSize: 14.0,
                                color: ColorConstants.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 15.0, top: 15.0, right: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.data['timing'],
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.add,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.data['servicesAndProducts'],
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${widget.data['address']}, ${widget.data['city']} (${widget.data['state']})",
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.star_border,
                          size: 24.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            "${widget.data['rating']}/5.0 (${UtilityMethods.formatNumberToKMB(double.tryParse(widget.data['peopleRated'].toString()) ?? 0.0)})",
                            style: const TextStyle(
                              fontFamily: AssetConstants.robotoFont,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomSheet: Container(
        width: MediaQuery.of(context).size.width,
        height: 60.0,
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(5.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 2.0,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: SizedBox(
                width: 80.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(height: 5.0),
                    Text(
                      StringConstants.location,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SizedBox(
                width: 80.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(height: 5.0),
                    Text(
                      StringConstants.call,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: SizedBox(
                width: 80.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat),
                    const SizedBox(height: 5.0),
                    Text(
                      StringConstants.message,
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w600,
                        color: ColorConstants.black,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
