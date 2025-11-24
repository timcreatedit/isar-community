import 'package:isar_community/isar.dart';
import 'package:isar_test/isar_test.dart';

part 'issue_843_sort_test.g.dart';

@collection
class Issue843Model {
  Issue843Model({required this.id, required this.value});

  Id id;

  int value;
}

void main() {
  isarTest('where(sort: desc) works without explicit where clause', () async {
    final isar = await openTempIsar([Issue843ModelSchema]);
    final col = isar.issue843Models;

    await isar.tWriteTxn(() async {
      await col.tPutAll([
        Issue843Model(id: 1, value: 1),
        Issue843Model(id: 3, value: 3),
        Issue843Model(id: 2, value: 2),
      ]);
    });

    await qEqual(col.where(sort: Sort.desc).idProperty(), [3, 2, 1]);

    await qEqual(
      col
          .where(sort: Sort.desc)
          .filter()
          .valueGreaterThan(1)
          .idProperty(),
      [3, 2],
    );
  });
}
