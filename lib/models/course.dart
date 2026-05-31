import 'package:flutter/material.dart';

class Course {
  const Course({
    required this.title,
    required this.imagePath,
    required this.pdfPath,
    this.subtitle,
  });

  final String title;
  final String imagePath;
  final String pdfPath;
  final String? subtitle;
}

class CourseCategory {
  const CourseCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.courses,
    this.accentColor = const Color(0xFF7C4DFF),
  });

  final String id;
  final String title;
  final IconData icon;
  final List<Course> courses;
  final Color accentColor;
}
