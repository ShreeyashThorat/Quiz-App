import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/repositories/quiz_repo.dart';
import 'package:quiz_app/utils/color_theme.dart';
import 'package:quiz_app/utils/constant_assets.dart';
import 'package:quiz_app/widgets/my_button.dart';
import 'package:quiz_app/widgets/my_textfield.dart';

import '../../models/tech_stack_model.dart';
import '../quiz/quiz_waiting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Future<List<TechStackModel>>? techStacksFuture;

  @override
  void initState() {
    super.initState();
    techStacksFuture = QuizRepo().getTechStack();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onSearchChanged() {
    if (searchController.text.trim().isNotEmpty) {
      setState(() {
        techStacksFuture = QuizRepo().getTechStack(q: searchController.text);
      });
    } else {
      setState(() {
        techStacksFuture = QuizRepo().getTechStack();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 2,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade200,
              child: Icon(
                Icons.person_rounded,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Shreeyash Thorat",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                Text(
                  "shreeyashthorat5@gmail.com",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.black),
                )
              ],
            )
          ],
        ),
      ),
      body: ListView(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * 0.05, vertical: 15),
        children: [
          Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.055, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(ConstantAssets.frame1))),
            child: SizedBox(
              width: size.width * 0.5,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '''Test Your Knowledge with 
Quizzes''',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '''You're just looking for a playful way to learn 
new facts, our quizzes are designed to 
entertain and educate.''',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w300,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MyElevatedButton(
                      onPress: () {},
                      buttonColor: Colors.white,
                      borderRadius: 4,
                      buttonContent: Text(
                        "Play Now",
                        style: TextStyle(
                            fontSize: 14, color: ColorTheme.primaryColor),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          MyTextField(
            controller: searchController,
            hintText: "Search",
            filled: true,
            fillColor: const Color(0XFFE8E8E8),
            verticalPadding: 10,
            suffix: Icon(
              Icons.search_rounded,
              color: Colors.grey.shade500,
              size: 18,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Text(
            "Categories",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder<List<TechStackModel>>(
              future: techStacksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No categories found'));
                } else {
                  final techStacks = snapshot.data!;
                  return Row(
                    children: [
                      ...List.generate(techStacks.length, (index) {
                        final stack = techStacks[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => QuizWaitingScreen(
                                            stack: stack,
                                          )));
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade200),
                                  alignment: Alignment.center,
                                  child: CachedNetworkImage(
                                    cacheKey: stack.id,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    width: 25,
                                    height: 25,
                                    fadeInDuration:
                                        const Duration(milliseconds: 200),
                                    fadeInCurve: Curves.easeInOut,
                                    imageUrl: stack.icon!,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    progressIndicatorBuilder:
                                        (context, url, progress) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  stack.category!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        );
                      })
                    ],
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
