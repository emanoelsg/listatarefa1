// app/features/tasks/presentation/pages/addtask_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listatarefa1/app/features/tasks/domain/task_entity.dart';
import 'package:listatarefa1/app/features/tasks/presentation/controller/task_controller.dart';
import 'package:listatarefa1/app/utils/constants/colors.dart';
import 'package:listatarefa1/app/utils/validators/validation.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  final TaskEntity? existingTask;

  const AddTaskPage({super.key, this.existingTask});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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
    }

    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fadeAnimation = CurvedAnimation(parent: fadeController, curve: Curves.easeInOut);
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

    if (isEditing) {
      final updatedTask = widget.existingTask!.copyWith(
        title: title,
        description: description,
      );
      await controller.updateTask(userId, updatedTask);
    } else {
      final newTask = TaskEntity(
        id: widget.existingTask?.id ?? const Uuid().v4(),
        title: title,
        description: description,
        userId: userId,
        createdAt: DateTime.now(),
        isDone: false,
      );
      await controller.addTask(userId, newTask.title, newTask.description ?? '');
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fadeAnimation,
      child: Scaffold(
       // backgroundColor: TColors.primaryBackground,
        appBar: AppBar(
          title: Text(isEditing ? 'Editar Tarefa' : 'Nova Tarefa'),
          centerTitle: true,
          backgroundColor: TColors.primary,
          foregroundColor: TColors.textWhite,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Título',
                    filled: true,
                    // fillColor: TColors.lightContainer,
                    // labelStyle: const TextStyle(color: TColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                     // borderSide: const BorderSide(color: TColors.borderPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                  ),
                  validator: (value) {
                    return TValidator.validateEmptyText('Título', value) ??
                        TValidator.validateMaxLength(value, 50, fieldName: 'Título');
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição',
                    filled: true,
                    // fillColor: TColors.lightContainer,
                    // labelStyle: const TextStyle(color: TColors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                     // borderSide: const BorderSide(color: TColors.borderPrimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: TColors.primary),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) =>
                      TValidator.validateMaxLength(value, 200, fieldName: 'Descrição'),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: Icon(isEditing ? Icons.save : Icons.check),
                    label: Text(isEditing ? 'Salvar Alterações' : 'Salvar Tarefa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.buttonPrimary,
                     // foregroundColor: TColors.textWhite,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}