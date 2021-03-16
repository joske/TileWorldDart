#!/usr/bin/env dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Grid.dart';
import 'View.dart';

void main() {
  final Grid grid = Grid(6, 20, 20, 20);
  runApp(MyApp(grid));
  const delay = const Duration(milliseconds:200);
  new Timer.periodic(delay, (Timer t) => grid.update());
}

class MyApp extends StatelessWidget {
  late final Grid grid;

  MyApp(Grid grid) {
    this.grid = grid;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Grid>(create: (context) => grid),
      ],
      child: MaterialApp(home: CustomView()),
    );
  }
}

class CustomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var grid = Provider.of<Grid>(context);
    return Container(
      color: Colors.white,
      child: CustomPaint(
        size: Size(Grid.COLS * Grid.MAG, Grid.ROWS * Grid.MAG),
        painter: View(grid),
      ),
    );
  }
}
