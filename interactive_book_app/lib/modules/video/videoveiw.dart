import 'package:flutter/material.dart';
import 'package:interactive_book_app/core/resources/ap_constants.dart';
import 'package:interactive_book_app/core/theme/app_colors.dart';
import 'package:interactive_book_app/modules/video/videosurvices/playerprovider.dart';
import 'package:interactive_book_app/modules/video/videosurvices/videoprovider.dart';
import 'package:interactive_book_app/modules/video/widgets/iconbotton.dart';

import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'widgets/dropdown.dart';

class Videoveiw extends StatefulWidget {
  const Videoveiw();

  @override
  State<Videoveiw> createState() => _VideoveiwState();
}

class _VideoveiwState extends State<Videoveiw> {
  Offset? tapPosition;
  late VideoProvider videoProvider;
  // VideoProvider videoProvider = VideoProvider();
  VideoPlayerProvider playerProvider = VideoPlayerProvider();

  String selected = "transcript";
  String selectedlanguage = AppConstants.defult_language;
  String? selectedsubtitle = AppConstants.defult_language;
  String? selectedaudio;
  List<AudioTrack> audioTracks = [];
  @override
  void initState() {
    super.initState();
    videoProvider = context.read<VideoProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      fetchData();
    });
  }

  void fetchData() async {
    await videoProvider.fetchvideodata();
    if (!mounted) return;
    // await videoviewModel.loadvediodetails(videoProvider.selectedTitle!);
    playerProvider.initialize(videoProvider.url!);
  }

  @override
  void dispose() {
    playerProvider.player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(AppConstants.defult_language);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: videoProvider),
        ChangeNotifierProvider.value(value: playerProvider),
      ],
      child: Consumer<VideoProvider>(
        builder: (context, videoProvider, child) {
          if (videoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Scaffold(
            backgroundColor: AppColors.lightColor,
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Consumer<VideoPlayerProvider>(
                    builder: (context, playerProvider, child) {
                      return AspectRatio(
                        aspectRatio: 16 / 10,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Video(controller: playerProvider.controller),
                            Row(
                              children: [
                                VideoControlButton(
                                  icon:
                                      playerProvider.isMuted
                                          ? Icons.volume_off
                                          : Icons.volume_up,
                                  onPressed: playerProvider.toggleMute,
                                ),

                                VideoControlButton(
                                  icon: Icons.replay_10,
                                  onPressed: playerProvider.seekBackward,
                                ),

                                VideoControlButton(
                                  icon: Icons.forward_10,
                                  onPressed: playerProvider.seekForward,
                                ),

                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      tapPosition = details.globalPosition;
                                    },
                                    child: Icon(
                                      Icons.headphones,
                                      color: AppColors.lightColor,
                                    ),
                                    onTap: () async {
                                      final overlay =
                                          Overlay.of(
                                                context,
                                              ).context.findRenderObject()
                                              as RenderBox;

                                      final result = await showMenu<String>(
                                        color: AppColors.lightColor,
                                        context: context,
                                        position: RelativeRect.fromRect(
                                          Rect.fromPoints(
                                            tapPosition!,
                                            tapPosition!,
                                          ),
                                          Offset.zero & overlay.size,
                                        ),
                                        items:
                                            videoProvider.audiolanguageCodes!
                                                .map(
                                                  (e) => PopupMenuItem<String>(
                                                    value: e,
                                                    child: Text(e),
                                                  ),
                                                )
                                                .toList(),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          selectedaudio = result;
                                        });

                                        for (
                                          int i = 0;
                                          i < videoProvider.audioList!.length;
                                          i++
                                        ) {
                                          if (selectedaudio ==
                                              videoProvider
                                                  .audioList![i]
                                                  .langCode) {
                                            await playerProvider.player
                                                .setAudioTrack(
                                                  AudioTrack.uri(
                                                    videoProvider
                                                        .audioList![i]
                                                        .url!,
                                                  ),
                                                );
                                            await playerProvider.player.seek(
                                              playerProvider.position,
                                            );

                                            break;
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTapDown: (TapDownDetails details) {
                                      tapPosition = details.globalPosition;
                                    },
                                    child: Icon(
                                      Icons.subtitles,
                                      color: AppColors.lightColor,
                                      size: 25,
                                    ),
                                    // onDoubleTap: () {
                                    //   for (var vtt in videoProvider.vttList!) {
                                    //     if (AppConstants.defult_language ==
                                    //         vtt.langCode) {
                                    //       playerProvider.player.setSubtitleTrack(
                                    //         SubtitleTrack.uri(vtt.url!),
                                    //       );
                                    //       break;
                                    //     }
                                    //   }
                                    // },
                                    onTap: () async {
                                      final overlay =
                                          Overlay.of(
                                                context,
                                              ).context.findRenderObject()
                                              as RenderBox;

                                      final result = await showMenu<String>(
                                        color: AppColors.lightColor,
                                        context: context,
                                        position: RelativeRect.fromRect(
                                          Rect.fromPoints(
                                            tapPosition!,
                                            tapPosition!,
                                          ),
                                          Offset.zero & overlay.size,
                                        ),
                                        items:
                                            videoProvider.subtitlelangcode!
                                                .map(
                                                  (e) => PopupMenuItem<String>(
                                                    value: e,
                                                    child: Text(e),
                                                  ),
                                                )
                                                .toList(),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          selectedsubtitle = result;
                                        });

                                        for (var vtt
                                            in videoProvider.vttList!) {
                                          if (result == vtt.langCode) {
                                            playerProvider.player
                                                .setSubtitleTrack(
                                                  SubtitleTrack.uri(vtt.url!),
                                                );
                                            break;
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.key,
                                    color: AppColors.lightColor,
                                    size: 25,
                                  ),
                                  onPressed:
                                      () => showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Expanded(
                                            child: Dialog(
                                              backgroundColor:
                                                  AppColors.lightColor,
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children:
                                                      videoProvider.keywords!
                                                          .map(
                                                            (e) => Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    8.0,
                                                                  ),
                                                              child: Column(
                                                                children: [
                                                                  Text(
                                                                    e ?? '',
                                                                    style: TextStyle(
                                                                      color:
                                                                          AppColors
                                                                              .darkColor,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                    height: 3,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )
                                                          .toList(),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // SizedBox(width: 39,),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomDropdown(
                                hint: 'data language',
                                value: videoProvider.selectedLanguage,
                                items: videoProvider.languageCodes,
                                onChanged: (value) {
                                  if (value != null) {
                                    videoProvider.changeLanguage(value);
                                  }
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomDropdown(
                                hint: 'data format',
                                value: selected,
                                items: const [
                                  "summary25",
                                  "summary50",
                                  "transcript",
                                ],
                                onChanged: (value) {
                                  videoProvider.selected(value!);
                                  setState(() {
                                    selected = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: Text(
                          videoProvider.selectedvalue ??
                              videoProvider.defultseletedvalue()!,
                          style: TextStyle(
                            color: AppColors.darkColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:graduation_progect/modules/video/videosurvices/playerprovider.dart';
// import 'package:graduation_progect/modules/video/videosurvices/videoprovider.dart';
// import 'package:graduation_progect/modules/video/widgets/dropdown.dart';
// import 'package:graduation_progect/modules/video/widgets/iconbotton.dart';
// import 'package:provider/provider.dart';
// import 'package:media_kit/media_kit.dart';
// import 'package:media_kit_video/media_kit_video.dart';
//
// import '../../core/theme/app_colors.dart';
//
// class Videoveiw extends StatefulWidget {
//   const Videoveiw();
//
//   @override
//   State<Videoveiw> createState() => _VideoveiwState();
// }
//
// class _VideoveiwState extends State<Videoveiw> {
//
//   late VideoPlayerProvider playerProvider;
//
//   String selectedFormat = "transcript";
//   String? selectedSubtitle;
//   String? selectedAudio;
//
//   Offset? tapPosition;
//
//   @override
//   void initState() {
//     super.initState();
//
//     playerProvider = VideoPlayerProvider();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       loadVideo();
//     });
//   }
//
//   Future<void> loadVideo() async {
//
//     final videoProvider = context.read<VideoProvider>();
//
//     await videoProvider.fetchvideodata();
//
//     if (videoProvider.url != null) {
//       playerProvider.initialize(videoProvider.url!);
//     }
//
//     videoProvider.isLoading = false;
//     videoProvider.notifyListeners();
//   }
//
//   @override
//   void dispose() {
//     playerProvider.player.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final videoProvider = context.watch<VideoProvider>();
//
//     if (videoProvider.isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return ChangeNotifierProvider(
//       create: (_) => playerProvider,
//       child: Scaffold(
//
//         appBar: AppBar(),
//
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//
//               Consumer<VideoPlayerProvider>(
//                 builder: (context, playerProvider, child) {
//
//                   if (playerProvider.controller == null) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   return AspectRatio(
//                     aspectRatio: 16 / 9,
//                     child: Stack(
//                       alignment: Alignment.topCenter,
//                       children: [
//
//                         Video(
//                           controller: playerProvider.controller!,
//                         ),
//
//                         Row(
//                           children: [
//
//                             VideoControlButton(
//                               icon: playerProvider.isMuted
//                                   ? Icons.volume_off
//                                   : Icons.volume_up,
//                               onPressed: playerProvider.toggleMute,
//                             ),
//
//                             VideoControlButton(
//                               icon: Icons.replay_10,
//                               onPressed: playerProvider.seekBackward,
//                             ),
//
//                             VideoControlButton(
//                               icon: Icons.forward_10,
//                               onPressed: playerProvider.seekForward,
//                             ),
//
//                             const Spacer(),
//
//                             /// AUDIO TRACK
//                             GestureDetector(
//                               onTapDown: (details) {
//                                 tapPosition = details.globalPosition;
//                               },
//                               child: const Icon(Icons.headphones),
//                               onTap: () async {
//
//                                 final overlay = Overlay.of(context)
//                                     .context
//                                     .findRenderObject() as RenderBox;
//
//                                 final result = await showMenu<String>(
//                                   context: context,
//                                   position: RelativeRect.fromRect(
//                                     Rect.fromPoints(tapPosition!, tapPosition!),
//                                     Offset.zero & overlay.size,
//                                   ),
//                                   items: videoProvider.audiolanguageCodes!
//                                       .map((e) => PopupMenuItem<String>(
//                                     value: e,
//                                     child: Text(e),
//                                   ))
//                                       .toList(),
//                                 );
//
//                                 if (result != null) {
//
//                                   setState(() {
//                                     selectedAudio = result;
//                                   });
//
//                                   for (var audio in videoProvider.audioList!) {
//
//                                     if (audio.langCode == result) {
//
//                                       await playerProvider.player.setAudioTrack(
//                                         AudioTrack.uri(audio.url!),
//                                       );
//
//                                       break;
//                                     }
//                                   }
//                                 }
//                               },
//                             ),
//
//                             const SizedBox(width: 10),
//
//                             /// SUBTITLE TRACK
//                             GestureDetector(
//                               onTapDown: (details) {
//                                 tapPosition = details.globalPosition;
//                               },
//                               child: const Icon(Icons.subtitles),
//                               onTap: () async {
//
//                                 final overlay = Overlay.of(context)
//                                     .context
//                                     .findRenderObject() as RenderBox;
//
//                                 final result = await showMenu<String>(
//                                   context: context,
//                                   position: RelativeRect.fromRect(
//                                     Rect.fromPoints(tapPosition!, tapPosition!),
//                                     Offset.zero & overlay.size,
//                                   ),
//                                   items: videoProvider.subtitlelangcode!
//                                       .map((e) => PopupMenuItem<String>(
//                                     value: e,
//                                     child: Text(e),
//                                   ))
//                                       .toList(),
//                                 );
//
//                                 if (result != null) {
//
//                                   setState(() {
//                                     selectedSubtitle = result;
//                                   });
//
//                                   for (var sub in videoProvider.vttList!) {
//
//                                     if (sub.langCode == result) {
//
//                                       playerProvider.player.setSubtitleTrack(
//                                         SubtitleTrack.uri(sub.url!),
//                                       );
//
//                                       break;
//                                     }
//                                   }
//                                 }
//                               },
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//
//               const SizedBox(height: 20),
//
//               /// DROPDOWNS
//               Row(
//                 children: [
//
//                   Expanded(
//                     child: CustomDropdown(
//                       hint: 'Data Language',
//                       value: videoProvider.selectedLanguage,
//                       items: videoProvider.languageCodes,
//                       onChanged: (value) {
//                         if (value != null) {
//                           videoProvider.changeLanguage(value);
//                         }
//                       },
//                     ),
//                   ),
//
//                   Expanded(
//                     child: CustomDropdown(
//                       hint: 'Data Format',
//                       value: selectedFormat,
//                       items: const [
//                         "summary25",
//                         "summary50",
//                         "transcript"
//                       ],
//                       onChanged: (value) {
//
//                         if (value == null) return;
//
//                         videoProvider.selected(value);
//
//                         setState(() {
//                           selectedFormat = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//
//               /// TEXT DATA
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text(
//                   videoProvider.selectedvalue ??
//                       videoProvider.defultseletedvalue() ??
//                       "",
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               IconButton(
//                               icon: Icon(
//                                 Icons.keyboard_alt_rounded,
//                                 color: Colors.black,
//                                 size: 25,
//                               ),
//                               onPressed: () => showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return Expanded(
//                                       child: Dialog(
//                                         backgroundColor: AppColors.primaryColor,
//                                         child: SingleChildScrollView(
//                                           scrollDirection: Axis.vertical,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: videoProvider.keywords!
//                                                 .map(
//                                                   (e) => Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Text(
//                                                           e ?? '',
//                                                           style: TextStyle(
//                                                               color: AppColors
//                                                                   .darkColor,
//                                                               fontSize: 20),
//                                                         ),
//                                                         Divider(
//                                                           height: 3,
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                           ),
//                                         ),
//                                       ),);
//                                   }
//
//                                         ),),
//
//               /// KEYWORDS
//               /// KEYWORDS
//               // if (videoProvider.keywords != null && videoProvider.keywords!.isNotEmpty)
//               //   Padding(
//               //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//               //     child: Row(
//               //       crossAxisAlignment: CrossAxisAlignment.start,
//               //       children: [
//               //
//               //         const Icon(
//               //           Icons.key,
//               //           size: 20,
//               //         ),
//               //
//               //         const SizedBox(width: 8),
//               //
//               //         Expanded(
//               //           child: Wrap(
//               //             spacing: 8,
//               //             runSpacing: 6,
//               //             children: videoProvider.keywords!
//               //                 .map(
//               //                   (k) => Text(
//               //                 "#$k",
//               //                 style: const TextStyle(
//               //                   fontWeight: FontWeight.w500,
//               //                 ),
//               //               ),
//               //             )
//               //                 .toList(),
//               //           ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//==================================================================================================

// import 'package:flutter/material.dart';
// import 'package:graduation_progect/core/theme/app_colors.dart';
// import 'package:graduation_progect/modules/video/models/Data.dart';
//
// import 'package:graduation_progect/modules/video/videoviewmodel.dart';
// import 'package:graduation_progect/modules/video/widgets/dailog.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import 'videosurvices/videoprovider.dart';
// import 'widgets/dropdown.dart';
// import 'models/AvailableLanguages.dart';
// import 'models/Videoresponse.dart';
// import 'models/VttList.dart';
//
// class Videoveiw extends StatefulWidget {
//   const Videoveiw();
//
//   @override
//   State<Videoveiw> createState() => _VideoveiwState();
// }
//
// class _VideoveiwState extends State<Videoveiw> {
//   late VideoPlayerController _controller;
//   VideoProvider videoProvider = VideoProvider();
//   Duration _currentPosition = Duration.zero;
//   bool isMuted = false;
//   late String selected = "summary25";
//   late String? selectedlanguage = "ar";
//   // late Data? selecteddata =videoProvider.availableLanguages![0].data;
//   //  late String? selectedvalue=selecteddata!.transcript;
//   // videoProvider.availableLanguages![0].data!.transcript!.toString();
//
//   void toggleMute() {
//     setState(() {
//       isMuted = !isMuted;
//       _controller.setVolume(isMuted ? 0.0 : 1.0);
//     });
//   }
//
//   void seekBackward() {
//     final currentPosition = _controller.value.position;
//     final newPosition = currentPosition - Duration(seconds: 10);
//     _controller
//         .seekTo(newPosition > Duration.zero ? newPosition : Duration.zero);
//   }
//
//   void seekForward() {
//     final currentPosition = _controller.value.position;
//     final duration = _controller.value.duration;
//     final newPosition = currentPosition + Duration(seconds: 10);
//     _controller.seekTo(newPosition < duration ? newPosition : duration);
//   }
//
//   void init() {
//     print("hona al enet");
//     _controller =
//         VideoPlayerController.networkUrl(Uri.parse(videoProvider.url));
//     _controller.initialize().then(
//         //استخدمت then عشان انا مش محتاجه اوقف اللي بعده لحد ما ايخلص انما await بستخدمها لما اكون عايزه اوقف الل بعد كده
//         (Value) {
//       // _controller.setLooping(true);
//       _controller.addListener(() {
//         setState(() {
//           _currentPosition=_controller.value.position;
//         });
//       });
//
//       setState(() {});
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//     init();
//
//     print(" ana d5alt el enaite");
//   }
//   void fetchData() async {
//     await videoProvider.fetchvideodata();
//     Videoresponse video = await videoviewModel.loadvediodetails();
//   }
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ChangeNotifierProvider.value(
//       value: videoProvider,
//       child: Consumer<VideoProvider>(builder: (context, videoProvider, child) {
//         if (videoProvider.isLoading) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return Scaffold(
//           appBar: AppBar(),
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 AspectRatio(
//                   aspectRatio: _controller.value.aspectRatio,
//                   child: Stack(alignment: Alignment.bottomCenter, children: [
//                     VideoPlayer(_controller),
//                     Row(
//                         // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           IconButton(
//                               icon: Icon(_controller.value.isPlaying
//                                   ? Icons.pause
//                                   : Icons.play_arrow),
//                               onPressed: () {
//                                 _controller.value.isPlaying
//                                     ? _controller.pause()
//                                     : _controller.play();
//                                 setState(() {});
//                               }),
//                           IconButton(
//                             icon: Icon(
//                               isMuted ? Icons.volume_off : Icons.volume_up,
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: toggleMute,
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               Icons.replay_10,
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: seekBackward,
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               Icons.forward_10,
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: seekForward,
//                           ),
//                           Expanded(child: SizedBox()),
//                           IconButton(
//                             icon: Icon(
//                               Icons.headphones,
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: () => showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return CustomDialog(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       Text(
//                                         'عنوان',
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       SizedBox(height: 10),
//                                       Text(videoProvider.availableLanguages
//                                           .toString()),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           IconButton(
//                             icon: Icon(
//                               Icons.subtitles,
//                               color: Colors.black,
//                               size: 25,
//                             ),
//                             onPressed: () => showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return CustomDialog(
//                                     child: Container(
//                                       padding: EdgeInsets.all(20),
//                                       width: 200, // عرض صغير
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Text('عنوان',
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.bold)),
//                                           SizedBox(height: 10),
//                                           Text(videoProvider.url),
//                                           SizedBox(height: 15),
//                                           ElevatedButton(
//                                             onPressed: () =>
//                                                 Navigator.pop(context),
//                                             child: Text('إغلاق'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                           IconButton(
//                               icon: Icon(
//                                 Icons.keyboard_alt_rounded,
//                                 color: Colors.black,
//                                 size: 25,
//                               ),
//                               onPressed: () => showDialog(
//                                   context: context,
//                                   builder: (BuildContext context) {
//                                     return Expanded(
//                                       child: Dialog(
//                                         backgroundColor: AppColors.primaryColor,
//                                         child: SingleChildScrollView(
//                                           scrollDirection: Axis.vertical,
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: videoProvider.keywords!
//                                                 .map(
//                                                   (e) => Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Text(
//                                                           e ?? '',
//                                                           style: TextStyle(
//                                                               color: AppColors
//                                                                   .darkColor,
//                                                               fontSize: 20),
//                                                         ),
//                                                         Divider(
//                                                           height: 3,
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                                 .toList(),
//                                           ),
//                                         ),
//                                       ),
//                                     );
//                                   })),
//                         ]),
//                   ]),
//                 ),
//                 Row(
//
//                     children: [
//                       Text(formatDuration(_currentPosition)),
//                     Slider(
//                         value: _controller.value.position.inSeconds.toDouble(),
//                         min: 0,
//                         max: _controller.value.duration.inSeconds.toDouble(),
//                         onChanged: (value) {
//                           _controller.seekTo(Duration(seconds: value.toInt()));
//                           setState(() {});
//                         }),
//                       Text(formatDuration(_controller.value.duration)),
//
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     Text(videoProvider.selectedvalue),
//                     Row(
//                       children: [
//
//                         Expanded(
//                           child: CustomDropdown(
//                             hint: 'language',
//                             value: selectedlanguage,
//                             items: videoProvider.languageCodes,
//                             onChanged: (value) {
//                               int length = videoProvider.availableLanguages!.length;
//                               for (int i = 0; i < length; i++) {
//                                 if (value ==
//                                     videoProvider
//                                         .availableLanguages![i].languageCode) {
//                                   videoProvider.selecctdata(i);
//                                   // videoProvider.availableLanguages![i].data!;
//                                 }
//                               }
//                               setState(() {
//                                 selectedlanguage = value!;
//                               });
//                             },
//                           ),
//                         ),
//                         Expanded(
//                           child: CustomDropdown(
//                             hint: 'transcript',
//                             value: selected,
//                             items: ["summary25", "summary50", "transcript"],
//                             onChanged: (value) {
//                               videoProvider.selected(value!);
//                               setState(() {
//                                 selected = value!;
//                               });
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
