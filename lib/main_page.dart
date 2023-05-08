import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<SwipeItem> swipeItems = <SwipeItem>[];
  List<int> imageIndexList = List.generate(10, (index) => 0);
  MatchEngine matchEngine = MatchEngine();
  bool isNope = false;
  bool isLike = false;
  bool isSuperLike = false;

  @override
  void initState() {
    swipeItems = List.generate(
      10,
      (index) => SwipeItem(
        content: TinderCard(
          name: Faker().person.firstName(),
          photos: [
            'https://i.pravatar.cc/${800 + index}',
            ...List.generate(Random().nextInt(5) + 1,
                (photoIndex) => 'https://picsum.photos/${800 + photoIndex}'),
          ],
          age: Random().nextInt(20) + 18,
          km: Random().nextInt(30) + 1,
        ),
        onSlideUpdate: (SlideRegion? region) async {
          if (region == SlideRegion.inLikeRegion) {
            setState(() {
              isLike = true;
            });
          } else if (region == SlideRegion.inNopeRegion) {
            setState(() {
              isNope = true;
            });
          } else if (region == SlideRegion.inSuperLikeRegion) {
            setState(() {
              isSuperLike = true;
            });
          } else {
            setState(() {
              isLike = false;
              isNope = false;
              isSuperLike = false;
            });
          }
        },
      ),
    );

    setState(() {
      matchEngine = MatchEngine(swipeItems: swipeItems);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'asset/icons/text_logo.png',
                    width: 100,
                  ),
                  const Icon(
                    CupertinoIcons.bell_fill,
                    color: Color(0xFF7E858F),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 10,
                    ),
                    child: SwipeCards(
                      matchEngine: matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTapDown: (details) {
                            var position = details.globalPosition;
                            if (position.dx <
                                MediaQuery.of(context).size.width / 2) {
                              if (imageIndexList[index] > 0) {
                                setState(() {
                                  imageIndexList[index]--;
                                });
                              }
                            } else {
                              if (imageIndexList[index] <
                                  swipeItems[index].content.photos.length - 1) {
                                setState(() {
                                  imageIndexList[index]++;
                                });
                              }
                            }
                          },
                          child: Container(
                            height: double.infinity,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    swipeItems[index]
                                        .content
                                        .photos[imageIndexList[index]],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.7),
                                    blurRadius: 5,
                                    spreadRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ]),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 4,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Row(
                                    children: List.generate(
                                      swipeItems[index].content.photos.length,
                                      (stepIndex) => Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: Container(
                                            height: imageIndexList[index] ==
                                                    stepIndex
                                                ? 2.5
                                                : 2,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              color: imageIndexList[index] ==
                                                      stepIndex
                                                  ? Colors.white
                                                  : Colors.black
                                                      .withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black
                                        ],
                                        stops: [
                                          0.5,
                                          1.0,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 18),
                                          child: RichText(
                                            text: TextSpan(
                                                text: swipeItems[index]
                                                        .content
                                                        .name +
                                                    " ",
                                                style: GoogleFonts.roboto(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 28,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: swipeItems[index]
                                                        .content
                                                        .age
                                                        .toString(),
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 20,
                                                    ),
                                                  )
                                                ]),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 12,
                                            left: 18,
                                            right: 10,
                                            bottom: 10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.location_on_outlined,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                  Text(
                                                    " ${swipeItems[index].content.km} km away",
                                                    style: GoogleFonts.roboto(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color: Colors.black,
                                                  size: 16,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 70,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {},
                      itemChanged: (SwipeItem item, int index) {
                        setState(() {
                          imageIndexList[index] = 0;
                        });
                      },
                      likeTag: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFF6EE6BA),
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "LIKE",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF6EE6BA),
                            fontSize: 40,
                          ),
                        ),
                      ),
                      nopeTag: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFFEC5E6A),
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "NOPE",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFEC5E6A),
                            fontSize: 40,
                          ),
                        ),
                      ),
                      superLikeTag: Transform.rotate(
                        angle: -15 * pi / 180,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 70),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color(0xFF66C4F2),
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "SUPER\nLIKE",
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF66C4F2),
                              fontSize: 40,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      upSwipeAllowed: true,
                      fillSpace: true,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 18,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'asset/icons/return.svg',
                                  color: Colors.white,
                                  width: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFEC5E6A),
                                  ),
                                  color: isNope
                                      ? const Color(0xFFEC5E6A)
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                  'asset/icons/cross.svg',
                                  width: 24,
                                  color: isNope ? Colors.white : null,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF66C4F2),
                                  ),
                                  color: isSuperLike
                                      ? const Color(0xFF66C4F2)
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'asset/icons/star.svg',
                                  width: 20,
                                  color: isSuperLike ? Colors.white : null,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF6EE6BA),
                                  ),
                                  color: isLike
                                      ? const Color(0xFF6EE6BA)
                                      : Colors.transparent,
                                ),
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                  'asset/icons/heart.svg',
                                  width: 26,
                                  color: isLike ? Colors.white : null,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFA64AE9),
                                  ),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: SvgPicture.asset(
                                  'asset/icons/thunder.svg',
                                  width: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                padding: const EdgeInsets.only(top: 14),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFD0D2D8),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'asset/icons/logo.png',
                        height: 20,
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        'asset/icons/search.svg',
                        width: 22,
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        'asset/icons/menu_star.svg',
                        width: 20,
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        'asset/icons/chat.svg',
                        width: 24,
                      ),
                    ),
                    Expanded(
                      child: SvgPicture.asset(
                        'asset/icons/person.svg',
                        width: 16,
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}

class TinderCard {
  final String name;
  final List<String> photos;
  final int age;
  final int km;
  final String? aboutMe;
  final List<String>? interests;

  TinderCard({
    required this.name,
    required this.photos,
    required this.age,
    required this.km,
    this.aboutMe,
    this.interests,
  });
}
