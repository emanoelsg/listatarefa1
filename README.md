# Lista Tarefa

> Aplicativo de gerenciamento de tarefas com notificações e autenticação, desenvolvido em Flutter com integração Firebase.

---

## 🛠 Tecnologias

- **Flutter & Dart** – Frontend cross-platform.
- **GetX** – Gerenciamento de estado e navegação.
- **Firebase Auth & Firestore** – Autenticação e banco de dados em tempo real.
- **Notifications Service** – Agendamento de lembretes para tarefas.
- **Testes Unitários** – Flutter Test, Mocktail, FakeFirestore.

---

## ⚡ Funcionalidades

- **Cadastro e Login**  
  Autenticação de usuários com email e senha via Firebase Auth.  

- **CRUD de Tarefas**  
  Criar, atualizar, excluir e listar tarefas associadas ao usuário.

- **Lembretes/Notificações**  
  Agendamento de notificações para tarefas com horário definido.  

- **Estado reativo**  
  Atualização automática da UI usando GetX sempre que uma tarefa ou usuário é alterado.

---

## 🧪 Testes

O projeto inclui testes unitários robustos, cobrindo:  

- **AuthRepository & AuthController**  
  - Login, cadastro, logout  
  - Casos de sucesso e falha  

- **TaskRepository & TaskController**  
  - CRUD de tarefas  
  - Atualização e cancelamento de notificações  

- **TaskEntity**  
  - Conversão `toMap` / `fromMap`  
  - `copyWith`  

- **NotificationController**  
  - Verifica agendamento e cancelamento de notificações

💡 Testes garantem confiabilidade do código e facilitam futuras implementações.

---

## 🚀 Estrutura do Projeto

lib/ ├─ app/ │   ├─ features/ │   │   ├─ auth/ │   │   │   ├─ data/ │   │   │   ├─ domain/ │   │   │   └─ presentation/ │   │   ├─ tasks/ │   │   │   ├─ data/ │   │   │   ├─ domain/ │   │   │   └─ presentation/ │   │   └─ notifications/ │   │       ├─ controller/ │   │       └─ service/

- **Data** – Implementações de repositório e integração com Firebase.  
- **Domain** – Entidades e interfaces (abstração do repositório).  
- **Presentation** – Controllers e lógica de UI (GetX).  
- **Service** – Funcionalidades externas, como notificações.  

---

## 🎯 Diferenciais

- Projeto modular e escalável, seguindo princípios de **Clean Architecture**.  
- Cobertura de testes completa, demonstrando **qualidade e confiabilidade do código**.  
- Integração real com Firebase e notificações locais.  
- Código testável, fácil de manter e estender.

---

## 💻 Como rodar

1. Clone o repositório:  
```bash
git clone <seu-repositorio>
cd listatarefa1

2. Instale dependências:



flutter pub get

3. Configure Firebase:



Adicione google-services.json (Android) / GoogleService-Info.plist (iOS).


4. Rode o app:



flutter run

5. Execute testes:



flutter test

