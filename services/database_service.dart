import 'package:sqflite/sqflite.dart' hide ConflictAlgorithm;
import 'package:sqflite/sqflite.dart' as sqflite show ConflictAlgorithm;
import 'package:path/path.dart';
import '../models/user.dart';
import '../models/consultation.dart';
import '../models/acupoint.dart';
import '../models/fortune.dart';
import '../models/community.dart';
import '../models/transaction.dart';
import '../models/feedback.dart';
import '../models/wuyun_model.dart';
import '../models/mingli_model.dart';
import '../config/constants.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'lingji_tcm.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        phone TEXT UNIQUE,
        nickname TEXT,
        avatar TEXT,
        member_level INTEGER DEFAULT 0,
        member_expire_date TEXT,
        lingji_balance INTEGER DEFAULT 0,
        invitation_code TEXT,
        invited_by TEXT,
        cloud_backup_enabled INTEGER DEFAULT 0,
        created_at TEXT,
        updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE consultations (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        symptoms TEXT,
        tongue TEXT,
        pulse TEXT,
        diagnosis TEXT,
        prescription TEXT,
        master_id TEXT,
        created_at TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE prescriptions (
        id TEXT PRIMARY KEY,
        name TEXT,
        origin TEXT,
        composition TEXT,
        indications TEXT,
        usage TEXT,
        contraindications TEXT,
        master_id TEXT,
        category TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE masters (
        id TEXT PRIMARY KEY,
        name TEXT,
        dynasty TEXT,
        era TEXT,
        bio TEXT,
        theory TEXT,
        features TEXT,
        is_default INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE acupoints (
        id TEXT PRIMARY KEY,
        name TEXT,
        name_en TEXT,
        meridian TEXT,
        location TEXT,
        indication TEXT,
        technique TEXT,
        image_url TEXT,
        model_3d_path TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE fortunes (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        name TEXT,
        birth_time TEXT,
        gender TEXT,
        chart_type TEXT,
        chart_data TEXT,
        interpretation TEXT,
        created_at TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE wuyunliuqi (
        id TEXT PRIMARY KEY,
        year INTEGER,
        tiangans TEXT,
        dizhis TEXT,
        yun TEXT,
        qi TEXT,
        weather TEXT,
        disease TEXT,
        prevention TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE mingli_records (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        type TEXT,
        birth_year INTEGER,
        birth_month INTEGER,
        birth_day INTEGER,
        birth_hour INTEGER,
        chart_data TEXT,
        interpretation TEXT,
        member_level INTEGER,
        created_at TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE profiles (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        bio TEXT,
        bio_updated_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE communities (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        avatar TEXT,
        member_count INTEGER DEFAULT 0,
        owner_id TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE messages (
        id TEXT PRIMARY KEY,
        community_id TEXT,
        sender_id TEXT,
        sender_name TEXT,
        content TEXT,
        type TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        seller_id TEXT,
        buyer_id TEXT,
        amount INTEGER,
        price REAL,
        total_amount REAL,
        payment_screenshot TEXT,
        status TEXT,
        created_at TEXT,
        completed_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE feedbacks (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        type TEXT,
        content TEXT,
        images TEXT,
        status TEXT,
        reply TEXT,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE payment_methods (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        type TEXT,
        qr_code TEXT,
        account_name TEXT
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    for (var master in AppConstants.masters) {
      await db.insert('masters', {
        'id': master['id'],
        'name': master['name'],
        'dynasty': master['dynasty'],
        'era': '',
        'bio': '',
        'theory': '',
        'features': '',
        'is_default': master['is_default'] ? 1 : 0,
      });
    }

    await _insertSamplePrescriptions(db);
    await _insertSampleAcupoints(db);
  }

  Future<void> _insertSamplePrescriptions(Database db) async {
    final samplePrescriptions = [
      {
        'id': 'rx_001',
        'name': '桂枝汤',
        'origin': '《伤寒论》',
        'composition': '[{"herb":"桂枝","dosage":"9g"},{"herb":"白芍","dosage":"9g"},{"herb":"生姜","dosage":"9g"},{"herb":"大枣","dosage":"4枚"},{"herb":"甘草","dosage":"6g"}]',
        'indications': '外感风寒表虚证。头痛发热，汗出恶风，鼻鸣干呕，苔白不渴，脉浮缓或浮弱。',
        'usage': '水煎服，日一剂，分两次温服。',
        'contraindications': '表实无汗，或下利清谷者忌用。',
        'master_id': 'master_2',
        'category': '解表剂',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'rx_002',
        'name': '麻黄汤',
        'origin': '《伤寒论》',
        'composition': '[{"herb":"麻黄","dosage":"9g"},{"herb":"桂枝","dosage":"6g"},{"herb":"杏仁","dosage":"9g"},{"herb":"甘草","dosage":"3g"}]',
        'indications': '外感风寒表实证。恶寒发热，头身疼痛，无汗而喘，舌苔薄白，脉浮紧。',
        'usage': '水煎服，日一剂，分两次温服。',
        'contraindications': '表虚自汗、外感风热、体虚外感、产后血虚、失血病人均不宜用。',
        'master_id': 'master_2',
        'category': '解表剂',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'rx_003',
        'name': '小柴胡汤',
        'origin': '《伤寒论》',
        'composition': '[{"herb":"柴胡","dosage":"12g"},{"herb":"黄芩","dosage":"9g"},{"herb":"人参","dosage":"6g"},{"herb":"半夏","dosage":"9g"},{"herb":"甘草","dosage":"6g"},{"herb":"生姜","dosage":"9g"},{"herb":"大枣","dosage":"4枚"}]',
        'indications': '伤寒少阳证。往来寒热，胸胁苦满，默默不欲饮食，心烦喜呕，口苦，咽干，目眩，舌苔薄白，脉弦者。',
        'usage': '水煎服，日一剂，分两次温服。',
        'contraindications': '阴虚血少者慎用。',
        'master_id': 'master_2',
        'category': '和解剂',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'rx_004',
        'name': '四君子汤',
        'origin': '《太平惠民和剂局方》',
        'composition': '[{"herb":"人参","dosage":"10g"},{"herb":"白术","dosage":"10g"},{"herb":"茯苓","dosage":"10g"},{"herb":"甘草","dosage":"6g"}]',
        'indications': '脾胃气虚证。面色萎白，语声低微，气短乏力，食少便溏，舌淡苔白，脉虚弱。',
        'usage': '水煎服，日一剂，分两次温服。',
        'contraindications': '实热证者慎用。',
        'master_id': 'master_2',
        'category': '补益剂',
        'created_at': DateTime.now().toIso8601String(),
      },
      {
        'id': 'rx_005',
        'name': '补中益气汤',
        'origin': '《脾胃论》',
        'composition': '[{"herb":"黄芪","dosage":"18g"},{"herb":"人参","dosage":"9g"},{"herb":"白术","dosage":"9g"},{"herb":"甘草","dosage":"9g"},{"herb":"当归","dosage":"3g"},{"herb":"陈皮","dosage":"6g"},{"herb":"升麻","dosage":"6g"},{"herb":"柴胡","dosage":"6g"}]',
        'indications': '脾胃气虚证。食少腹胀，倦怠乏力，或发热，自汗，渴喜温饮，大便稀溏，舌淡，脉虚大无力。',
        'usage': '水煎服，日一剂，分两次温服。',
        'contraindications': '阴虚内热者慎用。',
        'master_id': 'master_1',
        'category': '补益剂',
        'created_at': DateTime.now().toIso8601String(),
      },
    ];

    for (var rx in samplePrescriptions) {
      await db.insert('prescriptions', rx);
    }
  }

  Future<void> _insertSampleAcupoints(Database db) async {
    final sampleAcupoints = [
      {'id': 'ac_001', 'name': '足三里', 'name_en': 'Zusanli', 'meridian': '足阳明胃经', 'location': '小腿外侧，犊鼻下3寸，犊鼻与解溪连线上', 'indication': '胃痛、呕吐、腹胀、腹泻、便秘等胃肠疾病；虚劳羸弱。', 'technique': '直刺1-2寸，艾灸为主。'},
      {'id': 'ac_002', 'name': '合谷', 'name_en': 'Hegu', 'meridian': '手阳明大肠经', 'location': '手背，第1、2掌骨间，当第2掌骨桡侧的中点处', 'indication': '头痛、牙痛、发热、口眼歪斜等头面五官疾病；闭经、滞产。', 'technique': '直刺0.5-1寸，孕妇禁用。'},
      {'id': 'ac_003', 'name': '关元', 'name_en': 'Guanyuan', 'meridian': '任脉', 'location': '下腹部，前正中线上，脐下3寸', 'indication': '遗尿、小便不利、疝气、遗精、阳痿、月经不调等。', 'technique': '直刺1-2寸，艾灸为主。'},
      {'id': 'ac_004', 'name': '气海', 'name_en': 'Qihai', 'meridian': '任脉', 'location': '下腹部，前正中线上，脐下1.5寸', 'indication': '腹痛、泄泻、便秘、遗尿、遗精、阳痿、月经不调等。', 'technique': '直刺1-2寸，艾灸为主。'},
      {'id': 'ac_005', 'name': '中脘', 'name_en': 'Zhongwan', 'meridian': '任脉', 'location': '上腹部，前正中线上，脐上4寸', 'indication': '胃痛、呕吐、吞酸、腹胀、泄泻等脾胃疾病。', 'technique': '直刺1-1.5寸。'},
      {'id': 'ac_006', 'name': '内关', 'name_en': 'Neiguan', 'meridian': '手厥阴心包经', 'location': '前臂掌侧，腕横纹上2寸，掌长肌腱与桡侧腕屈肌腱之间', 'indication': '心痛、心悸、胸闷、胃痛、呕吐、呃逆、失眠等。', 'technique': '直刺0.5-1寸。'},
      {'id': 'ac_007', 'name': '三阴交', 'name_en': 'Sanyinjiao', 'meridian': '足太阴脾经', 'location': '小腿内侧，足内踝尖上3寸，胫骨内侧缘后方', 'indication': '月经不调、痛经、带下、遗精、阳痿、遗尿等。', 'technique': '直刺1-1.5寸，孕妇禁用。'},
      {'id': 'ac_008', 'name': '太冲', 'name_en': 'Taichong', 'meridian': '足厥阴肝经', 'location': '足背，第1、2跖骨结合部前方凹陷处', 'indication': '头痛、眩晕、目赤肿痛、胁痛、郁证等。', 'technique': '直刺0.5-1寸。'},
      {'id': 'ac_009', 'name': '百会', 'name_en': 'Baihui', 'meridian': '督脉', 'location': '头部，前发际正中直上5寸，或两耳尖连线中点处', 'indication': '头痛、眩晕、失眠、健忘、癫狂、脱肛、阴挺等。', 'technique': '平刺0.5-1寸。'},
      {'id': 'ac_010', 'name': '大椎', 'name_en': 'Dazhui', 'meridian': '督脉', 'location': '后正中线上，第7颈椎棘突下凹陷中', 'indication': '热病、感冒、咳嗽、气喘、项强、癫痫等。', 'technique': '斜刺0.5-1寸。'},
    ];

    for (var ac in sampleAcupoints) {
      await db.insert('acupoints', ac);
    }
  }

  Future<User?> getUser(String phone) async {
    final db = await database;
    final maps = await db.query('users', where: 'phone = ?', whereArgs: [phone]);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<User?> getUserById(String id) async {
    final db = await database;
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return User.fromMap(maps.first);
  }

  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<List<Prescription>> getPrescriptions({String? masterId, String? category}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;
    if (masterId != null && category != null) {
      where = 'master_id = ? AND category = ?';
      whereArgs = [masterId, category];
    } else if (masterId != null) {
      where = 'master_id = ?';
      whereArgs = [masterId];
    } else if (category != null) {
      where = 'category = ?';
      whereArgs = [category];
    }
    final maps = await db.query('prescriptions', where: where, whereArgs: whereArgs);
    return maps.map((m) => Prescription.fromMap(m)).toList();
  }

  Future<List<Master>> getMasters() async {
    final db = await database;
    final maps = await db.query('masters');
    return maps.map((m) => Master.fromMap(m)).toList();
  }

  Future<List<Acupoint>> getAcupoints({String? meridian}) async {
    final db = await database;
    final maps = meridian != null
        ? await db.query('acupoints', where: 'meridian = ?', whereArgs: [meridian])
        : await db.query('acupoints');
    return maps.map((m) => Acupoint.fromMap(m)).toList();
  }

  Future<void> insertFortune(Fortune fortune) async {
    final db = await database;
    await db.insert('fortunes', fortune.toMap());
  }

  Future<List<Fortune>> getFortunes(String userId) async {
    final db = await database;
    final maps = await db.query('fortunes', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return maps.map((m) => Fortune.fromMap(m)).toList();
  }

  Future<void> insertConsultation(Consultation consultation) async {
    final db = await database;
    await db.insert('consultations', consultation.toMap());
  }

  Future<List<Consultation>> getConsultations(String userId) async {
    final db = await database;
    final maps = await db.query('consultations', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
    return maps.map((m) => Consultation.fromMap(m)).toList();
  }

  Future<void> insertTransaction(LingjiTransaction transaction) async {
    final db = await database;
    await db.insert('transactions', transaction.toMap());
  }

  Future<void> updateTransaction(LingjiTransaction transaction) async {
    final db = await database;
    await db.update('transactions', transaction.toMap(), where: 'id = ?', whereArgs: [transaction.id]);
  }

  Future<List<LingjiTransaction>> getTransactions({String? userId, String? status}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;
    if (userId != null && status != null) {
      where = '(seller_id = ? OR buyer_id = ?) AND status = ?';
      whereArgs = [userId, userId, status];
    } else if (userId != null) {
      where = 'seller_id = ? OR buyer_id = ?';
      whereArgs = [userId, userId];
    } else if (status != null) {
      where = 'status = ?';
      whereArgs = [status];
    }
    final maps = await db.query('transactions', where: where, whereArgs: whereArgs, orderBy: 'created_at DESC');
    return maps.map((m) => LingjiTransaction.fromMap(m)).toList();
  }

  Future<List<LingjiTransaction>> getOpenOrders() async {
    final db = await database;
    final maps = await db.query('transactions', where: 'status = ?', whereArgs: ['open'], orderBy: 'price ASC');
    return maps.map((m) => LingjiTransaction.fromMap(m)).toList();
  }

  Future<void> insertFeedback(Feedback feedback) async {
    final db = await database;
    await db.insert('feedbacks', feedback.toMap());
  }

  Future<List<Community>> getCommunities() async {
    final db = await database;
    final maps = await db.query('communities', orderBy: 'member_count DESC');
    return maps.map((m) => Community.fromMap(m)).toList();
  }

  Future<void> insertCommunity(Community community) async {
    final db = await database;
    await db.insert('communities', community.toMap());
  }

  Future<void> insertMessage(Message message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
  }

  Future<List<Message>> getMessages(String communityId) async {
    final db = await database;
    final maps = await db.query('messages', where: 'community_id = ?', whereArgs: [communityId], orderBy: 'created_at ASC');
    return maps.map((m) => Message.fromMap(m)).toList();
  }

  Future<WuYunLiuQi?> getWuYunLiuQi(int year) async {
    final db = await database;
    final maps = await db.query('wuyunliuqi', where: 'year = ?', whereArgs: [year]);
    if (maps.isEmpty) return null;
    return WuYunLiuQi.fromMap(maps.first);
  }

  Future<Map<String, dynamic>> calculateWuYunLiuQi(int year) async {
    int tianganIndex = (year - 4) % 10;
    int dizhiIndex = (year - 4) % 12;
    String tiangan = AppConstants.tiangan[tianganIndex];
    String dizhi = AppConstants.dizhi[dizhiIndex];
    int yunIndex = tianganIndex ~/ 2;
    String yun = AppConstants.yunNames[yunIndex];
    int qiIndex = (tianganIndex + dizhiIndex) % 6;
    String qi = AppConstants.qiNames[qiIndex];
    
    String weather;
    String disease;
    String prevention;
    
    switch (qi) {
      case '厥阴风木':
        weather = '风邪偏盛，多风气候变化';
        disease = '肝病多发，易患风疹、抽搐等';
        prevention = '养肝息风，疏肝理气';
        break;
      case '少阴君火':
        weather = '气候偏热，多炎热天气';
        disease = '心病多发，易患心悸、失眠等';
        prevention = '清心降火，养心安神';
        break;
      case '少阳相火':
        weather = '气候温热，少阳当令';
        disease = '胆病多发，易患口苦、胁痛等';
        prevention = '和解少阳，清热泻火';
        break;
      case '太阴湿土':
        weather = '湿气偏盛，雨水较多';
        disease = '脾病多发，易患腹胀、腹泻等';
        prevention = '健脾祛湿，芳香化浊';
        break;
      case '阳明燥金':
        weather = '气候干燥，燥邪当令';
        disease = '肺病多发，易患咳嗽、咽干等';
        prevention = '润燥养肺，清热生津';
        break;
      case '太阳寒水':
        weather = '气候寒冷，寒邪当令';
        disease = '肾病多发，易患腰膝酸痛、畏寒等';
        prevention = '温肾散寒，补肾益精';
        break;
      default:
        weather = '气候变化';
        disease = '疾病多发';
        prevention = '调养身体';
    }
    
    return {
      'id': 'wuyun_$year',
      'year': year,
      'tiangans': tiangan,
      'dizhis': dizhi,
      'yun': yun,
      'qi': qi,
      'weather': weather,
      'disease': disease,
      'prevention': prevention,
    };
  }

  Future<Map<String, dynamic>> calculateBazi(DateTime birthTime, String gender) async {
    int year = birthTime.year;
    int month = birthTime.month;
    int day = birthTime.day;
    int hour = birthTime.hour;

    int tianganYear = (year - 4) % 10;
    int dizhiYear = (year - 4) % 12;
    int tianganMonth = ((month + 1) * 2 + (year % 5) + 2) % 10;
    int dizhiMonth = (month + 2) % 12;
    int tianganDay = (year % 100 + year ~/ 100 + day) % 10;
    int dizhiDay = (year % 100 + year ~/ 100 + day + 3) % 12;
    int tianganHour = (tianganDay * 2 + (hour + 1) ~/ 2) % 10;
    int dizhiHour = (hour + 3) % 12;

    List<String> tianGan = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸'];
    List<String> diZhi = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥'];

    return {
      'year_gan': tianGan[tianganYear < 0 ? tianganYear + 10 : tianganYear],
      'year_zhi': diZhi[dizhiYear < 0 ? dizhiYear + 12 : dizhiYear],
      'month_gan': tianGan[tianganMonth < 0 ? tianganMonth + 10 : tianganMonth],
      'month_zhi': diZhi[dizhiMonth < 0 ? dizhiMonth + 12 : dizhiMonth],
      'day_gan': tianGan[tianganDay < 0 ? tianganDay + 10 : tianganDay],
      'day_zhi': diZhi[dizhiDay < 0 ? dizhiDay + 12 : dizhiDay],
      'hour_gan': tianGan[tianganHour < 0 ? tianganHour + 10 : tianganHour],
      'hour_zhi': diZhi[dizhiHour < 0 ? dizhiHour + 12 : dizhiHour],
      'gender': gender,
    };
  }

  Future<void> insertMingLiRecord(String userId, MingLiType type, int birthYear, int birthMonth, int birthDay, int birthHour, String chartData, String interpretation, int memberLevel) async {
    final db = await database;
    await db.insert('mingli_records', {
      'id': '${type.name}_${DateTime.now().millisecondsSinceEpoch}',
      'user_id': userId,
      'type': type.name,
      'birth_year': birthYear,
      'birth_month': birthMonth,
      'birth_day': birthDay,
      'birth_hour': birthHour,
      'chart_data': chartData,
      'interpretation': interpretation,
      'member_level': memberLevel,
      'created_at': DateTime.now().toIso8601String(),
      'synced': 0,
    });
  }

  Future<List<Map<String, dynamic>>> getMingLiRecords(String userId) async {
    final db = await database;
    return await db.query('mingli_records', where: 'user_id = ?', whereArgs: [userId], orderBy: 'created_at DESC');
  }

  Future<void> updateProfileBio(String userId, String bio) async {
    final db = await database;
    await db.insert('profiles', {
      'id': 'bio_$userId',
      'user_id': userId,
      'bio': bio,
      'bio_updated_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  Future<String?> getProfileBio(String userId) async {
    final db = await database;
    final maps = await db.query('profiles', where: 'user_id = ?', whereArgs: [userId]);
    if (maps.isEmpty) return null;
    return maps.first['bio'] as String?;
  }

  Future<void> syncMingLiRecord(String recordId) async {
    final db = await database;
    await db.update('mingli_records', {'synced': 1}, where: 'id = ?', whereArgs: [recordId]);
  }

  Future<List<Map<String, dynamic>>> getUnsyncedRecords(String userId) async {
    final db = await database;
    return await db.query('mingli_records', where: 'user_id = ? AND synced = 0', whereArgs: [userId]);
  }
}
