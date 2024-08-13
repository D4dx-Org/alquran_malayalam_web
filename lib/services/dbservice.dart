import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';
import 'package:archive/archive_io.dart';

class DBService {
  static final DBService dbProvider = DBService();
  Database? db;
  static const NEW_DB_VERSION = 3;

  Future<Database> initDB(
      {String path = "alquran3.db",
      bool absolutePath = false,
      bool verbose = true,
      String fromAsset = "assets/alquran.zip",
      bool debug = false}) async {
    /// The [path] is where the database file will be stored. It is by
    /// default relative to the documents directory unless [absolutePath]
    /// is true.
    /// [queries] is a list of queries to run at initialization
    /// and [debug] set Sqflite debug mode on
    if (debug) Sqflite.setDebugModeOn(true);
    String dbpath = path;
    String zippath = 'alquran.zip';
    String oldDbPath = "alquran2.db";
    if (!absolutePath) {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      oldDbPath = "${documentsDirectory.path}/alquran2.db";
      dbpath = "${documentsDirectory.path}/$path";
      zippath = "${documentsDirectory.path}/$zippath";
    }

    /// delete if version is old
    var thafdb = await openDatabase(dbpath);
    //if database does not exist yet it will return version 0
    if (await databaseExists(oldDbPath)) await deleteDatabase(oldDbPath);
    if (await thafdb.getVersion() < NEW_DB_VERSION) {
      thafdb.close();
      //delete the old database so you can copy the new one
      if (verbose) {}
      if (await databaseExists(dbpath)) await deleteDatabase(dbpath);
    }

    if (verbose) {}
    // copy the database from an asset if necessary
    if (fromAsset != "") {
      File file = File(dbpath);
      File zipFile = File(zippath);
      if (!file.existsSync()) {
        if (verbose) {}
        List<int> bytes;
        try {
          // read zip file
          ByteData data = await rootBundle.load(fromAsset);
          bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        } catch (e) {
          throw ("Unable to read database from asset: $e");
        }
        try {
          // create the directories path if necessary
          if (!file.parent.existsSync()) {
            file.parent.createSync(recursive: true);
          }
          // write zip file
          await zipFile.writeAsBytes(bytes);
        } catch (e) {
          throw ("Unable to write database zip from asset: $e");
        }
        // Read the Zip file from disk.
        bytes = File(zipFile.path).readAsBytesSync();

        // Decode the Zip file
        Archive archive = ZipDecoder().decodeBytes(bytes);

        // Extract the contents of the Zip archive to disk.
        for (ArchiveFile dbfile in archive) {
          //String filename = dbfile.name;
          if (dbfile.isFile) {
            List<int> data = dbfile.content;
            File(dbpath)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          }
        }
        await zipFile.delete(recursive: false);
      }
    }
    var myDatabase = await openDatabase(dbpath, version: 3, readOnly: false,
        onCreate: (Database db, int version) async {
      db.setVersion(NEW_DB_VERSION);
      this.db = db;
    });
    if (verbose) {}
    return myDatabase;
  }

  Future openDB() async {
    try {
      // Get a location using getDatabasesPath
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'alquran3.db');
      final exist = await databaseExists(path);
      if (exist) {
        var db = await openDatabase(
          path,
          version: 3,
        );
        this.db = db;
      }
      // open the database
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }

  get database async {
    db ??= await initDB();
    return db!;
  }

  close() async {
    var db = database;
    var result = db.close();
    return result;
  }
}
