import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/constants.dart';

Future<void> getImage(BuildContext context, ImageSource source, Function(File) onImageSelected) async {
  final ImagePicker picker = ImagePicker();
  XFile? image = await picker.pickImage(source: source, imageQuality: 50);
  onImageSelected(File(image == null ? $EMPTY : image.path));
}