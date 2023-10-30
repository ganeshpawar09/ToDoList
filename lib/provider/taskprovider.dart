import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/provider/notification.dart';

Future<sql.Database> _getDatabase() async {
  final dbpath = await sql.getDatabasesPath();
  final database = await sql.openDatabase(
    path.join(dbpath, 'totals.db'),
    onCreate: (db, version) {
      db.execute('''
        CREATE TABLE totals(
          id TEXT PRIMARY KEY,
          title TEXT,
          taskid TEXT,
          note TEXT,
          day INTEGER,
          weekday INTEGER,
          startingDate TEXT,
          dueDate TEXT,
          color INTEGER,
          isCompleted INTEGER,
          priority TEXT,
          wantsReminder INTEGER,
          startingTime TEXT,
          endTime TEXT,
          remindBefore INTEGER,
          remindAfterEvery INTEGER
        )
      ''');
    },
    version: 1,
  );
  return database;
}

class TotalNotifier extends StateNotifier<List<Task>> {
  TotalNotifier() : super([]);

  Future<void> addTotal(Task task, bool atLast) async {
    
        
    final db = await _getDatabase();
    await db.insert(
      'totals',
      task.toMap(),
    );
    if (atLast) {
      state = [...state, task];
    } else {
      state = [task, ...state];
    }
  }

  Future<void> deleteTotal(String id) async {
    final db = await _getDatabase();
    await db.delete('totals', where: 'taskid = ?', whereArgs: [id]);
    state = state.where((element) => id != element.taskid).toList();
  }

  Future<void> getTotals() async {
    final db = await _getDatabase();
    final data = await db.query('totals');

    final total = data.map((map) => Task.fromMap(map)).toList();
    state = total;
  }
  Future<void> updateTotal(Task updatedTask) async {
    final db = await _getDatabase();

    // Update the task in the database
    await db.update(
      'totals',
      updatedTask.toMap(),
      where: 'taskid = ?',
      whereArgs: [updatedTask.taskid],
    );

    // Find the index of the updated task in the state
    final index = state.indexWhere((task) => task.taskid == updatedTask.taskid);

    if (index != -1) {
      // Create a new list with the updated task at the same index
      final updatedState = List<Task>.from(state);
      updatedState[index] = updatedTask;

      // Update the state with the new list
      state = updatedState;
    }
  }
}

final taskProvider = StateNotifierProvider<TotalNotifier, List<Task>>(
  (ref) => TotalNotifier(),
);
