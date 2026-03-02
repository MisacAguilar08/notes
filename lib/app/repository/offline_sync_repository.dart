import 'dart:convert';

import 'package:notes/app/model/OfflineSyncTask.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OfflineSyncRepository{

  Future<List<OfflineSyncTask>> getTasks() async {
    print('buscar datos pending');
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("pendingTask");
    final jsonTasks = prefs.getStringList('pendingTask') ?? [];
    print('------------');
    print(jsonTasks);
    print('------------');
    return jsonTasks.map((e) => OfflineSyncTask.fromJson(jsonDecode(e))).toList();
  }

  Future<bool> addPendingTask(OfflineSyncTask task) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonPendingTasks = prefs.getStringList('pendingTask') ?? [];
    jsonPendingTasks.add(jsonEncode(task.toJson()));
    return prefs.setStringList('pendingTask', jsonPendingTasks);
  }

  Future<bool> deleteTask(String id) async{
    final prefs = await SharedPreferences.getInstance();
    final jsonTasks = prefs.getStringList('pendingTask') ?? [];
    // jsonTasks.remove(jsonEncode(task.toJson()));
    // return prefs.setStringList('pendingTask', jsonTasks);
    // Decodificar las tareas a una lista de mapas
    final tasks = jsonTasks.map((task) => json.decode(task) as Map<String, dynamic>).toList();

    // Buscar y eliminar la tarea con el id especificado
    tasks.removeWhere((task) => task['id'] == id);

    // Volver a codificar la lista a JSON y guardarla
    final updatedJsonTasks = tasks.map((task) => json.encode(task)).toList();
    return  prefs.setStringList('pendingTask', updatedJsonTasks);
  }
}