import 'dart:convert';

import 'package:notes/app/model/task.dart';

OfflineSyncTask offlineSyncTaskFromJson(String str) => OfflineSyncTask.fromJson(json.decode(str));

String offlineSyncTaskToJson(OfflineSyncTask data) => json.encode(data.toJson());

class OfflineSyncTask {
  String type;
  String id;
  Task task;

  OfflineSyncTask({
    required this.id,
    required this.type,
    required this.task,
  });

  factory OfflineSyncTask.fromJson(Map<String, dynamic> json) => OfflineSyncTask(
    id: json["id"],
    type: json["type"],
    task: Task.fromJson(json["task"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "task": task.toJson(),
  };
}