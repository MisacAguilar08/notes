import 'package:flutter/cupertino.dart';
import 'package:notes/app/model/OfflineSyncTask.dart';
import 'package:notes/app/repository/offline_sync_repository.dart';


import '../../model/task.dart';

class OfflineSyncProvider extends ChangeNotifier {
  List<OfflineSyncTask> _pendingOperationsList = [];
  OfflineSyncRepository offlineSyncRepository = new OfflineSyncRepository();

  Future<void> fetchPendingTask() async {
    _pendingOperationsList = await offlineSyncRepository.getTasks();
    print("fetch get pending");
    print(_pendingOperationsList);
    notifyListeners();
  }

  List<OfflineSyncTask> get pendingOperations => _pendingOperationsList;

  void addPendingOperation(String type, Task task) {
    offlineSyncRepository
        .addPendingTask(OfflineSyncTask(id: task.id ,type: type, task: task));
    fetchPendingTask();
  }

  void deletePendingOperation(String type, Task task) {
    offlineSyncRepository
        .deleteTask(task.id );
    fetchPendingTask();
  }

  void clearOperations() {
    _pendingOperationsList.clear();
    notifyListeners();
  }
}
