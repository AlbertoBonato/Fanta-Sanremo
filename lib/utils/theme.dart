import 'dart:ui';

import 'package:flutter/material.dart';

const color_b1 = Color(0xFF2c0703);
const color_b2 = Color(0xFF890620);
const color_b3 = Color(0xFFB67771);
const color_b4 = Color(0xFFda9f93);
const color_b5 = Color(0xFFebd4cb);

const color_b1_lighter = Color(0xFF3F0A03);
const color_b5_lighter = Color(0xFFFAE3DA);

const Color grey = Color(0xFF3A5160);

const String secondFont = 'Roboto';

ThemeData mTheme = ThemeData(
  primaryColor: color_b5,
  fontFamily: 'Saira',
  primaryIconTheme: IconThemeData(color: color_b5),
  textTheme: TextTheme(bodyText2: TextStyle(color: color_b5, fontSize: 22)),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  canvasColor: color_b2,
  accentColor: color_b5,
  appBarTheme: AppBarTheme(
      textTheme: TextTheme(
          headline6: TextStyle(
              fontFamily: 'Saira',
              color: color_b5,
              fontSize: 22,
              fontWeight: FontWeight.w700)),
      iconTheme: IconThemeData(color: color_b5),
      color: color_b1),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          backgroundColor: color_b1,
          elevation: 6,
          primary: color_b5,
          textStyle: TextStyle(
            fontFamily: 'Saira',
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ))),
  errorColor: Colors.white,
);
