// app/features/tasks/presentation/pages/tasks_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/features/tasks/presentation/pages/addtask_page.dart';
import 'package:listatarefa1/app/utils/constants/colors.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';

class HomePage extends StatefulWidget {
  final String userId;
  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TaskController controller;
  late final String userId;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaskController>();
    userId = widget.userId;
    controller.loadTasks(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
        centerTitle: true,
        backgroundColor: TColors.primary,
        foregroundColor: TColors.textWhite,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddTaskPage(), arguments: userId),
        backgroundColor: TColors.accent,
        elevation: 6,
        child: const Icon(Icons.add, color: TColors.textWhite),
      ),
      body: Obx(() {
        final message = controller.message.value;
        if (message != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.snackbar(
              'Notice',
              message,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: TColors.error,
              colorText: TColors.textWhite,
              margin: const EdgeInsets.all(TSizes.md),
              borderRadius: TSizes.borderRadiusMd,
            );
            controller.message.value = null;
          });
        }

        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: TColors.primary),
          );
        }

        if (controller.tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks found',
              style: TextStyle(fontSize: TSizes.fontSizeMd),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: ListView.separated(
            itemCount: controller.tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: TSizes.sm),
            itemBuilder: (context, index) {
              final task = controller.tasks[index];

              return Slidable(
                key: ValueKey(task.id),
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => Get.to(
                          () => AddTaskPage(existingTask: task),
                          arguments: userId),
                      backgroundColor: TColors.primary,
                      foregroundColor: TColors.textWhite,
                      icon: Icons.edit,
                      label: 'Edit',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (_) => controller.deleteTask(userId, task.id),
                      backgroundColor: TColors.error,
                      foregroundColor: TColors.textWhite,
                      icon: Icons.delete_outline,
                      label: 'Delete',
                    ),
                  ],
                ),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(TSizes.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: task.isDone,
                          activeColor: TColors.primary,
                          onChanged: (value) {
                            controller.updateTask(
                              userId,
                              task.copyWith(isDone: value ?? false),
                            );
                          },
                        ),
                        const SizedBox(width: TSizes.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: TSizes.fontSizeLg,
                                  decoration: task.isDone
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              if (task.description != null &&
                                  task.description!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    task.description!,
                                    style: const TextStyle(
                                      fontSize: TSizes.fontSizeSm,
                                      color: TColors.textSecondary,
                                    ),
                                  ),
                                ),
                              if (task.reminderTime != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    'Reminder: ${task.reminderTime} (${task.repeatType})',
                                    style: const TextStyle(
                                      fontSize: TSizes.fontSizeLg,
                                      color: TColors.textSecondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
