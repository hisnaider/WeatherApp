import 'package:flutter/material.dart';

InputDecoration kTextFieldDecoration = InputDecoration(
  hintText: "Procurar cidade",
  hintStyle: const TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      fontSize: 15,
      fontWeight: FontWeight.normal),
  contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
);
