import 'package:flutter/material.dart';

class NotificationModel {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String time;
  final bool hasBorder;
  final bool isUnread;

  NotificationModel({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.time,
    required this.hasBorder,
    required this.isUnread,
  });

  // Nanti kalau pakai API, tambahkan factory method 'fromJson' here
  // factory NotificationModel.fromJson(Map<String, dynamic> json) { ... }
}