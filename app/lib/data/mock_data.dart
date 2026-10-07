import 'package:app/models/occurrence.dart';

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
];