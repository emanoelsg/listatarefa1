// app/features/tasks/presentation/task_controller.dart
import 'package:get/get.dart';
import '../domain/task_entity.dart';
import '../domain/task_repository.dart';

class TaskController extends GetxController {
  final TaskRepository _repository;

  TaskController({required TaskRepository repository})
      : _repository = repository;

  var tasks = <TaskEntity>[].obs;
  var isLoading = false.obs;

  Future<void> loadTasks(String userId) async {
    try {
      isLoading.value = true;
      tasks.value = await _repository.getTasks(userId);
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar tarefas');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTask(String userId, String title) async {
    final task = TaskEntity(
      id: '',
      title: title,
      userId: userId,
      createdAt: DateTime.now(),
    );
    try {
      await _repository.addTask(userId, task);
      await loadTasks(userId);
      Get.snackbar('Sucesso', 'Tarefa adicionada');
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao adicionar tarefa');
    }
  }

  Future<void> updateTask(String userId, TaskEntity task) async {
    try {
      await _repository.updateTask(userId, task);
      tasks[tasks.indexWhere((t) => t.id == task.id)] = task;
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao atualizar tarefa');
    }
  }

  Future<void> deleteTask(String userId, String taskId) async {
    try {
      await _repository.deleteTask(userId, taskId);
      tasks.removeWhere((t) => t.id == taskId);
    } catch (e) {
      Get.snackbar('Erro', 'Falha ao excluir tarefa');
    }
  }
}
