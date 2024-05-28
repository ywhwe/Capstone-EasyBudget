import 'package:easybudget/constant/color.dart';
import 'package:easybudget/screen/logo_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:easybudget/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easybudget/screen/category_display_widget.dart';
import 'package:easybudget/screen/calender_screen.dart';
import 'firebase_options.dart';

void main() async{
  initializeDateFormatting();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        fontFamily: 'NotoSansKR',
        textTheme: TextTheme(
          labelMedium: TextStyle(
            color: blueColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blueColor), // 포커스됐을 때의 테두리 색상 지정
          ),
          // 포커스 되었을 때와 되지 않았을 때의 텍스트 색상 설정
          labelStyle: TextStyle(color: Colors.grey), // 포커스됐을 때의 텍스트 색상 지정
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      //home: TabView(),
      //home: LogoScreen(),
      home: CategoryDisplayWidget(),
    ),
  );
}