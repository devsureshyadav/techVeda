import 'package:flutter/material.dart';
import 'package:tech_veda/models/course.dart';

const allCategoryId = 'all';

final List<CourseCategory> courseCategories = [
  CourseCategory(
    id: 'basics',
    title: 'Basics',
    icon: Icons.terminal_rounded,
    accentColor: const Color(0xFF64B5F6),
    courses: [
      Course(
        title: 'C Programming',
        imagePath: 'assets/images/c-programming.jpg',
        pdfPath: 'assets/pdfs/C_programming.pdf',
        subtitle: 'Foundations & syntax',
      ),
    ],
  ),
  CourseCategory(
    id: 'app_dev',
    title: 'App Development',
    icon: Icons.phone_android_rounded,
    accentColor: const Color(0xFF7C4DFF),
    courses: [
      Course(
        title: 'Dart',
        imagePath: 'assets/images/dart.png',
        pdfPath: 'assets/pdfs/Introduction to Dart.pdf',
        subtitle: 'Language essentials',
      ),
      Course(
        title: 'Flutter',
        imagePath: 'assets/images/flutter.png',
        pdfPath: 'assets/pdfs/Introduction to Flutter.pdf',
        subtitle: 'UI toolkit intro',
      ),
      Course(
        title: 'Flutter Basics',
        imagePath: 'assets/images/flutter1.png',
        pdfPath: 'assets/pdfs/Flutter Basics.pdf',
        subtitle: 'Widgets & layout',
      ),
      Course(
        title: 'Android',
        imagePath: 'assets/images/android.jpeg',
        pdfPath: 'assets/pdfs/JAVA.pdf',
        subtitle: 'Java for Android',
      ),
    ],
  ),
  CourseCategory(
    id: 'python',
    title: 'Python',
    icon: Icons.code_rounded,
    accentColor: const Color(0xFF4DD0E1),
    courses: [
      Course(
        title: 'Learn Python',
        imagePath: 'assets/images/python.jpg',
        pdfPath: 'assets/pdfs/Python.pdf',
        subtitle: 'Core concepts',
      ),
      Course(
        title: 'Web Python',
        imagePath: 'assets/images/webpython.jpg',
        pdfPath: 'assets/pdfs/Web Python.pdf',
        subtitle: 'Backend & APIs',
      ),
    ],
  ),
  CourseCategory(
    id: 'hacking',
    title: 'Hacking',
    icon: Icons.security_rounded,
    accentColor: const Color(0xFFFF6B6B),
    courses: [
      Course(
        title: 'Learn Python',
        imagePath: 'assets/images/neonPython.jpeg',
        pdfPath: 'assets/pdfs/Python.pdf',
        subtitle: 'Scripting basics',
      ),
      Course(
        title: 'Ethical Hacking Roadmap',
        imagePath: 'assets/images/ethicalHacking.jpg',
        pdfPath: 'assets/pdfs/Sources.pdf',
        subtitle: 'Career path guide',
      ),
      Course(
        title: 'Kali Linux Commands',
        imagePath: 'assets/images/kali.jpeg',
        pdfPath: 'assets/pdfs/Commands.pdf',
        subtitle: 'CLI reference',
      ),
      Course(
        title: 'Python for Hackers',
        imagePath: 'assets/images/pythonHacker.jpg',
        pdfPath: 'assets/pdfs/Python for Hacker.pdf',
        subtitle: 'Offensive scripting',
      ),
    ],
  ),
  CourseCategory(
    id: 'database',
    title: 'Database',
    icon: Icons.storage_rounded,
    accentColor: const Color(0xFF81C784),
    courses: [
      Course(
        title: 'MySQL',
        imagePath: 'assets/images/MySQL.png',
        pdfPath: 'assets/pdfs/MySQL.pdf',
        subtitle: 'Relational SQL',
      ),
      Course(
        title: 'MongoDB',
        imagePath: 'assets/images/MongoDB1.jpg',
        pdfPath: 'assets/pdfs/MongoDB.pdf',
        subtitle: 'NoSQL documents',
      ),
      Course(
        title: 'PostgreSQL',
        imagePath: 'assets/images/PostgreSQL-Tutorial.png',
        pdfPath: 'assets/pdfs/PostgreSQL.pdf',
        subtitle: 'Advanced SQL',
      ),
      Course(
        title: 'SQLite',
        imagePath: 'assets/images/sqlite.jpg',
        pdfPath: 'assets/pdfs/SQLite.pdf',
        subtitle: 'Embedded DB',
      ),
    ],
  ),
];

int get totalCourseCount =>
    courseCategories.fold(0, (sum, c) => sum + c.courses.length);

List<CourseCategory> categoriesForFilter(String categoryId) {
  if (categoryId == allCategoryId) return courseCategories;
  return courseCategories.where((c) => c.id == categoryId).toList();
}

List<CourseCategory> filterCategories({
  required String categoryId,
  required String query,
}) {
  final q = query.trim().toLowerCase();
  final cats = categoriesForFilter(categoryId);

  if (q.isEmpty) return cats;

  return cats
      .map(
        (cat) => CourseCategory(
          id: cat.id,
          title: cat.title,
          icon: cat.icon,
          accentColor: cat.accentColor,
          courses: cat.courses
              .where(
                (c) =>
                    c.title.toLowerCase().contains(q) ||
                    (c.subtitle?.toLowerCase().contains(q) ?? false),
              )
              .toList(),
        ),
      )
      .where((c) => c.courses.isNotEmpty)
      .toList();
}
