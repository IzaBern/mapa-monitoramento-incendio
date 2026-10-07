import 'package:app/data/mock_data.dart';
import 'package:app/models/actor.dart';
import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';
import 'package:app/styles/app_colors.dart';
import 'package:app/widgets/occurrence_card.dart';
import 'package:app/widgets/role_scaffold.dart';
import 'package:app/widgets/section_title.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: RoleScaffold(
        role: UserRole.admin,
        bottom: const TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.group), text: 'Atores'),
            Tab(icon: Icon(Icons.edit_note), text: 'Ocorrências'),
          ],
        ),
        body: const TabBarView(children: [_ActorsTab(), _OccurrencesTab()]),
      ),
    );
  }
}

class _ActorsTab extends StatefulWidget {
  const _ActorsTab();

  @override
  State<_ActorsTab> createState() => _ActorsTabState();
}

class _ActorsTabState extends State<_ActorsTab> {
  final _nome = TextEditingController();
  final _cpf = TextEditingController();
  final _usuario = TextEditingController();
  final _senha = TextEditingController();
  UserRole _role = UserRole.verificador;

  @override
  void dispose() {
    _nome.dispose();
    _cpf.dispose();
    _usuario.dispose();
    _senha.dispose();
    super.dispose();
  }

  void _aviso(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _cadastrar() {
    final nome = _nome.text.trim();
    final cpf = _cpf.text.trim();
    final usuario = _usuario.text.trim();
    final senha = _senha.text;

    if (nome.isEmpty || cpf.isEmpty || usuario.isEmpty || senha.isEmpty) {
      _aviso('Preencha todos os campos.');
      return;
    }
    final jaExiste = mockActors.any(
      (a) => a.usuario.toLowerCase() == usuario.toLowerCase(),
    );
    if (jaExiste) {
      _aviso('Este usuário já existe.');
      return;
    }

    setState(() {
      mockActors.insert(
        0,
        Actor(
          nome: nome,
          cpf: cpf,
          usuario: usuario,
          senha: senha,
          role: _role,
        ),
      );
      _nome.clear();
      _cpf.clear();
      _usuario.clear();
      _senha.clear();
    });
    _aviso('Ator cadastrado.');
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle("Cadastrar ator"),
                TextField(
                  controller: _nome,
                  decoration: const InputDecoration(
                    labelText: 'Nome completo',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cpf,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: '000.000.000-00',
                    prefixIcon: Icon(Icons.badge_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _usuario,
                  decoration: const InputDecoration(
                    labelText: 'Usuário',
                    prefixIcon: Icon(Icons.alternate_email),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _senha,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Senha provisória',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownMenu<UserRole>(
                  initialSelection: _role,
                  label: const Text('Papel'),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: [
                    UserRole.verificador,
                    UserRole.autoridade,
                    UserRole.admin,
                  ]
                      .map((r) => DropdownMenuEntry(value: r, label: r.label))
                      .toList(),
                  onSelected: (r) {
                    if (r != null) setState(() => _role = r);
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: _cadastrar,
                    child: const Text('Cadastrar ator'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SectionTitle("Atores cadastrados (${mockActors.length})"),
        ...mockActors.map(
          (a) => Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.secondary.withValues(alpha: 0.12),
                child: Icon(a.role.icon, color: AppColors.secondary),
              ),
              title: Text(a.nome),
              subtitle: Text('${a.usuario} · ${a.role.label}'),
              trailing: IconButton(
                tooltip: 'Remover',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => setState(() => mockActors.remove(a)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OccurrencesTab extends StatelessWidget {
  const _OccurrencesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SectionTitle("Todas as ocorrências"),
        ...mockOccurrences.map(
          (o) => OccurrenceCard(
            occurrence: o,
            trailing: PopupMenuButton<OccurrenceStatus>(
              tooltip: 'Alterar status',
              icon: const Icon(Icons.edit),
              onSelected: (_) {}, // TODO: alterar status
              itemBuilder: (_) => OccurrenceStatus.values
                  .map((s) => PopupMenuItem(value: s, child: Text(s.label)))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}