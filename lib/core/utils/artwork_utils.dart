import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

Future<Uri?> saveArtworkToFile(Uint8List? bytes, String id) async {
  if (bytes == null) return null;

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/art_$id.jpg');

  await file.writeAsBytes(bytes, flush: true);
  return file.uri;
}
