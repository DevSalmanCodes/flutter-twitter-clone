import 'package:flutter/material.dart';
import 'package:twitter/screens/feed.dart';
import 'package:twitter/screens/messages.dart';
import 'package:twitter/screens/notifications.dart';
import 'package:twitter/screens/search.dart';


List<Widget> homeItems = [
  const Feed(),
  const Search(),
  const Notifications(),
  const Messages()
];
