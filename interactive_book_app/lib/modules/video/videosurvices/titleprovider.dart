

import 'package:flutter/material.dart';

class selectedtitle extends ChangeNotifier {
 String? selectedTitle;
  void setSelectedTitle(String title) {
    selectedTitle = title;
    notifyListeners();
  }

}
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:graduation_progect/core/theme/app_colors.dart';
// import 'package:graduation_progect/modules/video/videoveiw.dart';
//
// class HomeDrawer extends StatelessWidget {
//   const HomeDrawer();
//
//   // final void Function() goToHome;
//
//   @override
//   Widget build(BuildContext context) {
//     // var homeProvider = Provider.of<HomeProvider>(context);
//     return Drawer(
//       backgroundColor: AppColors.darkColor,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             alignment: Alignment.center,
//             width: double.infinity,
//             height: 166.h,
//
//             color: AppColors.lightColor,
//
//             child: Text(
//               "lesson opject",
//               style: GoogleFonts.inter(
//                 fontSize: 24.sp,
//                 fontWeight: FontWeight.bold,
//                 color:AppColors.darkColor,
//               ),
//             ),
//           ),
//           SizedBox(height: 16.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: InkWell(
//               onTap: () {
//                 Navigator.pop(context);
//                 Navigator.push(context, MaterialPageRoute(builder: (_)=>Videoveiw()));
//                 // homeProvider.goToCategoriesView();
//
//               },
//               child: Row(
//                 children: [
//                   Icon(Icons.video_collection_outlined, color: AppColors.lightColor),
//
//                   SizedBox(width: 12.w),
//                   Text(
//                     "video",
//                     style: GoogleFonts.inter(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.lightColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(height: 24.h),
//           Divider(color:AppColors.lightColor, indent: 14, endIndent: 14),
//           SizedBox(height: 24.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Icon(Icons.picture_as_pdf_rounded, color: AppColors.lightColor),
//
//                 SizedBox(width: 12.w),
//                 Text(
//                   "pdf",
//                   style: GoogleFonts.inter(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.lightColor,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.h),
//
//           SizedBox(height: 24.h),
//           Divider(color: AppColors.lightColor, indent: 14, endIndent: 14),
//           SizedBox(height: 24.h),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Text(
//                   "Qustion",
//                   style: GoogleFonts.inter(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color:AppColors.lightColor,
//                   ),
//                 ),
//                 Spacer(),
//                 // Switch(value: true, onChanged: (_) {}),
//               ],
//             ),
//           ),
//
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Text(
//                   "",
//                   style: GoogleFonts.inter(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.lightColor,
//                   ),
//                 ),
//                 Spacer(),
//                 // Switch(value: true, onChanged: (_) {}),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }