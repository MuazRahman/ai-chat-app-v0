import 'package:flutter/material.dart';

import 'chat_page.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "AI Chat Assistant",
      home: const ChatPage(),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white24,
          titleTextStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 28, color: Colors.black),
        ),
        textTheme: TextTheme(
          titleSmall: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.green,
          selectionColor: Colors.green.shade200,
          selectionHandleColor: Colors.green.shade400,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.green),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.green),
          ),
          hintStyle: TextStyle(
            color: Colors.black45,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
