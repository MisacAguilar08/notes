
import 'package:flutter/material.dart';
import 'package:notes/app/model/task.dart';
import 'package:notes/app/pages/task_list/task_provider.dart';
import 'package:notes/app/pages/task_page/task_page.dart';
import 'package:notes/app/services/notifications.dart';
import 'package:notes/app/utils/app_images.dart';
import 'package:notes/app/utils/app_texts.dart';
import 'package:notes/app/widgtes/title_task_list.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../utils/constant.dart';
import '../../widgtes/images_task_list.dart';
import 'offline_sync_provider.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  void initState() {
    super.initState();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.fetchTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _Header(),
          Expanded(child: _TaskList()),
        ],
      ),
      floatingActionButton: buildModalTaskList(),
    );
  }

  Builder buildModalTaskList() {
    return Builder(
        builder: (context) => SizedBox(
              width: 45,
              height: 45,
              child: FloatingActionButton(
                onPressed: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return TaskPage();
                })),
                child: Icon(Icons.add),
              ),
            ));
  }
}


class _NewTaskModal extends StatefulWidget {
  _NewTaskModal(this.editTask);

  final Task? editTask;

  @override
  State<_NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<_NewTaskModal> {
  late TextEditingController _controller;

  bool isSave = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.editTask?.title ?? "",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(21)),
          color: Colors.white),
      padding: EdgeInsets.symmetric(horizontal: 33, vertical: 23),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleTaskList(
            text: AppTexts.taskListModalTitle,
          ),
          SizedBox(
            height: 26,
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                hintMaxLines: 8,
                filled: true,
                fillColor: Colors.white,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                hintText: AppTexts.taskListModalInputDescription),
          ),
          SizedBox(
            height: 26,
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  final taskTitle = _controller.text.trim();
                  var uuid = Uuid();
                  if (taskTitle.isNotEmpty) {
                    String timeStamp = widget.editTask?.date ??
                        DateTime.timestamp().toString();
                    bool status = widget.editTask?.done ?? false;
                    String id = widget.editTask?.id ?? uuid.v4();
                    final newTask =
                        Task(timeStamp, taskTitle, done: status, id: id);

                    if (widget.editTask == null) {
                      // await addNote(id, timeStamp, status);
                      context.read<TaskProvider>().addTask(newTask);
                    } else {
                      context.read<TaskProvider>().editTask(newTask);
                      // await addNote(id, timeStamp, status);
                    }

                    if (!isSave) {
                      context
                          .read<OfflineSyncProvider>()
                          .addPendingOperation("create", newTask);
                      isSave = false;
                    }
                  }
                  Navigator.of(context).pop();
                } catch (e) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppTexts.taskListModalButton))
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _TaskList extends StatelessWidget {
  late bool isDelete = false;
  _TaskList();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleTaskList(text: AppTexts.taskListBody),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (_, provider, __) {
                if (provider.taskList.isEmpty) {
                  return Center(
                    child: Text(AppTexts.taskListEmpty),
                  );
                }

                return ListView.separated(
                    itemBuilder: (_, index) => _taskItem(
                        task: provider.taskList[index],
                        onTap: (_) async {
                          NotificationService ns = NotificationService();
                          provider.onTaskDoneChange(provider.taskList[index]);
                          if (provider.taskList[index].done) {
                            await ns.cancelNotification(
                                provider.taskList[index].notification);
                          } else {
                            int keyType = listNotification.entries
                                .firstWhere((entry) =>
                                    entry.value ==
                                    provider.taskList[index].recordatorio)
                                .key;
                            if (keyType != 4) {
                              await ns.periodicallyNotification(
                                  provider.taskList[index].notification,
                                  provider.taskList[index].title,
                                  notificationOption.values.elementAt(keyType));
                            }
                          }
                        },
                        onDelete: () async {
                          provider.deleteTask(provider.taskList[index]);
                          NotificationService ns = new NotificationService();
                          await ns.cancelNotification(
                              provider.taskList[index].notification);
                        },
                        onEdit: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return TaskPage(
                              task: provider.taskList[index],
                            );
                          }));
                        }),
                    separatorBuilder: (_, __) => const SizedBox(
                          height: 16,
                        ),
                    itemCount: provider.taskList.length);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Row(
            children: [
              ImagesTaskList(
                nameImages: AppImages.shape,
                imageWidth: 141,
                imageHeight: 129,
              ),
            ],
          ),
          Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              ImagesTaskList(
                nameImages: AppImages.taskList,
                imageWidth: 120,
                imageHeight: 120,
              ),
              SizedBox(
                height: 16,
              ),
              TitleTaskList(
                text: AppTexts.taskListHeader,
                color: Colors.white,
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _taskItem extends StatelessWidget {
  const _taskItem(
      {required this.task, this.onTap, this.onDelete, this.onEdit});

  final Task task;
  final ValueChanged? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 30,
                  child: Checkbox(value: task.done, onChanged: onTap)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(task.title),
              ),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  child: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
