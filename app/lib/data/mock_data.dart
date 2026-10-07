import 'package:app/models/actor.dart';
import 'package:app/models/occurrence.dart';
import 'package:app/models/user_role.dart';

const mockOccurrences = [
  Occurrence(
    id: 1,
    local: "Gameleira II - Rio Verde, GO",
    vegetacao: 'Cerrado',
    dataHora: '05/10/2026 14:32',
    status: OccurrenceStatus.pending,
  ),
  Occurrence(
    id: 2,
    local: "Jardim das Amélias - Jataí, GO",
    vegetacao: "Pastagem",
    dataHora: "05/10/2026 11:10",
    status: OccurrenceStatus.verified,
  ),
  Occurrence(
    id: 3,
    local: "Avenida Juscelino Kubitschek - Mineiros, GO",
    vegetacao: "Lavoura",
    dataHora: "04/10/2026 18:45",
    status: OccurrenceStatus.denied,
  ),
  Occurrence(
    id: 4,
    local: "Setor Universitário - Rio Verde, GO",
    vegetacao: "Mata",
    dataHora: "06/10/2026 08:15",
    status: OccurrenceStatus.pending,
  ),
  Occurrence(
    id: 5,
    local: "Centro - Montividiu, GO",
    vegetacao: "Pastagem",
    dataHora: "06/10/2026 09:40",
    status: OccurrenceStatus.verified,
  ),
  Occurrence(
    id: 6,
    local: "Zona Rural - Caiapônia, GO",
    vegetacao: "Cerrado",
    dataHora: "04/10/2026 09:20",
    status: OccurrenceStatus.mobilized,
  ),
  Occurrence(
    id: 7,
    local: "Setor Sul - Santa Helena de Goiás, GO",
    vegetacao: "Cerrado",
    dataHora: "03/10/2026 16:05",
    status: OccurrenceStatus.completed,
  ),
];

final mockMyOccurrences = mockOccurrences.take(3).toList();

final List<Actor> mockActors = [
  Actor(
    nome: 'João Verificador',
    cpf: '222.222.222-22',
    usuario: 'verificador',
    senha: '123456',
    role: UserRole.verificador,
  ),
  Actor(
    nome: 'Cap. Ana Autoridade',
    cpf: '333.333.333-33',
    usuario: 'autoridade',
    senha: '123456',
    role: UserRole.autoridade,
  ),
  Actor(
    nome: 'Admin Teste',
    cpf: '444.444.444-44',
    usuario: 'admin',
    senha: '123456',
    role: UserRole.admin,
  ),
];