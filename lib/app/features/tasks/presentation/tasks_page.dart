import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Lista compartilhada de tarefas
  final List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(children: [
          ListTile(
            title: Text('listTile'),
          ),
          Divider(
            height: 10,
            thickness: 3,
          ),
          Card(
            child: ListTile(
              title: Text(
                'listTile',
              ),
            ),
          ),
          Card(
            child: ListTile(
              title: Text(
                'listTile',
              ),
            ),
          ),
        ]),
      ),
      // Botão flutuante para adicionar tarefas
      floatingActionButton: FloatingActionButton.large(
        onPressed: addList, // Chama a função que adiciona uma nova tarefa
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Lista de Tarefa'), // Título da aplicação
      ),
      // Passa a lista de tarefas para o widget filho
      body: AddList(tasks: tasks),
    );
  }

  // Função que adiciona uma nova tarefa à lista
  void addList() {
    setState(() {
      tasks.add(
          'Lista ${tasks.length + 1}'); // Adiciona uma nova tarefa numerada
    });
  }
}

class AddList extends StatefulWidget {
  // Recebe a lista de tarefas do componente pai
  final List<String> tasks;

  const AddList({super.key, required this.tasks});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  // Variável que controla o estado do checkbox
  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    // Inicializar a lista de booleanos com o mesmo tamanho da lista de tarefas
    _isChecked = List<bool>.filled(widget.tasks.length, false);
  }

  // Função que remove uma tarefa da lista pelo índice
  void deleteList(index) {
    setState(() {
      widget.tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // Define a quantidade de itens na lista
      itemCount: widget.tasks.length,
      itemBuilder: (context, index) {
        return Padding(
          // Espaçamento entre os itens
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            // Decoração do container
            decoration: BoxDecoration(
              color: Colors.indigoAccent[300],
            ),
            child: Card(
              child: ListTile(
                // Checkbox para marcar/desmarcar a tarefa
                leading: Checkbox(
                  value: _isChecked[index],
                  onChanged: (newBool) {
                    setState(() {
                      _isChecked[index] =
                          newBool!; // Atualiza o estado do checkbox
                    });
                  },
                ),
                dense: false, // Reduz o espaçamento interno do ListTile
                // Ícone para deletar a tarefa
                trailing: IconButton(
                  iconSize: 40.0, // Tamanho do ícone
                  onPressed: () {
                    deleteList(index); // Remove a tarefa ao clicar no ícone
                  },
                  icon: const Icon(Icons.delete),
                ),
                // Campo de texto para editar a tarefa
                title: const TextField(
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(fontSize: 13.0), // Estilo do texto do rótulo
                    labelText: ('tarefa'), // Texto do rótulo
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
