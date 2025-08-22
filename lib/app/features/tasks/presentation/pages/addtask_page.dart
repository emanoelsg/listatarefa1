// app/features/tasks/presentation/pages/addtask_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/utils/constants/colors.dart';
import 'package:listatarefa1/app/utils/constants/sizes.dart';
import 'package:listatarefa1/app/utils/validators/validation.dart';
import 'package:uuid/uuid.dart';

enum TaskFrequency { daily, weekly }

class AddTaskPage extends StatefulWidget {
  final TaskEntity? existingTask;
  const AddTaskPage({super.key, this.existingTask});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TaskFrequency frequency = TaskFrequency.daily;
  List<int> selectedWeekDays = []; // store weekdays for weekly tasks
  TimeOfDay? reminderTime;
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  late final TaskController controller;
  late final String userId;
  late final bool isEditing;

  @override
  void initState() {
    super.initState();
    controller = Get.find<TaskController>();
    userId = Get.arguments as String;
    isEditing = widget.existingTask != null;

    if (isEditing) {
      titleController.text = widget.existingTask!.title;
      descriptionController.text = widget.existingTask!.description ?? '';
      if (widget.existingTask!.repeatType == 'daily') {
        frequency = TaskFrequency.daily;
      } else {
        frequency = TaskFrequency.weekly;
        selectedWeekDays = widget.existingTask!.weekDays ?? [];
      }
      if (widget.existingTask!.reminderTime != null) {
        final parts = widget.existingTask!.reminderTime!.split(':');
        reminderTime =
            TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fadeAnimation =
        CurvedAnimation(parent: fadeController, curve: Curves.easeInOut);
    fadeController.forward();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    final repeatType = frequency == TaskFrequency.daily ? 'daily' : 'weekly';
    final weekDays =
        frequency == TaskFrequency.weekly ? selectedWeekDays : null;
    final reminderStr = reminderTime != null
        ? '${reminderTime!.hour.toString().padLeft(2, '0')}:${reminderTime!.minute.toString().padLeft(2, '0')}'
        : null;

    if (isEditing) {
      final updatedTask = widget.existingTask!.copyWith(
        title: title,
        description: description,
        repeatType: repeatType,
        weekDays: weekDays,
        reminderTime: reminderStr,
      );
      await controller.updateTask(userId, updatedTask);
    } else {
      final newTask = TaskEntity(
        id: const Uuid().v4(),
        title: title,
        description: description,
        userId: userId,
        createdAt: DateTime.now(),
        repeatType: repeatType,
        weekDays: weekDays,
        reminderTime: reminderStr,
      );
      await controller.addTask(
          userId, newTask.title, newTask.description ?? '');
    }

    Get.back();
  }

  Widget _buildFrequencySelector() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChoiceChip(
              label: const Text('Daily'),
              selected: frequency == TaskFrequency.daily,
              selectedColor: TColors.primary,
              onSelected: (_) =>
                  setState(() => frequency = TaskFrequency.daily),
            ),
            ChoiceChip(
              label: const Text('Weekly'),
              selected: frequency == TaskFrequency.weekly,
              selectedColor: TColors.primary,
              onSelected: (_) =>
                  setState(() => frequency = TaskFrequency.weekly),
            ),
          ],
        ),
        if (frequency == TaskFrequency.weekly)
          Wrap(
            spacing: 8,
            children: List.generate(7, (index) {
              final day = index + 1; // 1=Mon ... 7=Sun
              final dayLabel =
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][index];
              final isSelected = selectedWeekDays.contains(day);
              return ChoiceChip(
                label: Text(dayLabel),
                selected: isSelected,
                selectedColor: TColors.primary,
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      selectedWeekDays.add(day);
                    } else {
                      selectedWeekDays.remove(day);
                    }
                  });
                },
              );
            }),
          ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(reminderTime != null
                ? 'Reminder: ${reminderTime!.format(context)}'
                : 'Pick Reminder Time'),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: reminderTime ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => reminderTime = picked);
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Task' : 'New Task'),
          centerTitle: true,
          backgroundColor: TColors.primary,
          foregroundColor: TColors.textWhite,
        ),
        body: Padding(
          padding: const EdgeInsets.all(TSizes.md),
          child: Card(
            elevation: TSizes.cardElevation,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TSizes.md),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.inputFieldRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.inputFieldRadius),
                          borderSide: const BorderSide(color: TColors.primary),
                        ),
                      ),
                      validator: (value) {
                        return TValidator.validateEmptyText('Title', value) ??
                            TValidator.validateMaxLength(value, 50,
                                fieldName: 'Title');
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.inputFieldRadius),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(TSizes.inputFieldRadius),
                          borderSide: const BorderSide(color: TColors.primary),
                        ),
                      ),
                      maxLines: 3,
                      validator: (value) => TValidator.validateMaxLength(
                        value,
                        200,
                        fieldName: 'Description',
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwInputFields),
                    _buildFrequencySelector(),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submit,
                        icon: Icon(isEditing ? Icons.save : Icons.check),
                        label: Text(isEditing ? 'Save Changes' : 'Save Task'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.buttonPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(TSizes.buttonRadius),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
