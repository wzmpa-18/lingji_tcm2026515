import 'package:flutter/material.dart';
import '../../models/classic_book.dart';
import '../../services/study_service.dart';

class BookReaderScreen extends StatefulWidget {
  final ClassicBook book;
  final BookChapter chapter;

  const BookReaderScreen({
    super.key,
    required this.book,
    required this.chapter,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final StudyTimerService _timerService = StudyTimerService();
  bool _isNightMode = false;
  double _fontSize = 16;
  bool _isTimerActive = false;
  SessionProgress? _sessionProgress;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timerService.startSession('demo-user', widget.book.id);
    setState(() {
      _isTimerActive = true;
    });
    _updateProgress();
  }

  void _stopTimer() {
    _timerService.stopSession(
      'demo-user',
      DailyPointLimit(userId: 'demo-user', date: DateTime.now(), earnedToday: 0),
    );
    setState(() {
      _isTimerActive = false;
      _sessionProgress = null;
    });
  }

  void _updateProgress() {
    Future.doWhile(() {
      if (!mounted) return false;
      setState(() {
        _sessionProgress = _timerService.getSessionProgress('demo-user');
      });
      return Future.delayed(const Duration(seconds: 1), () => _isTimerActive);
    });
  }

  void _increaseFontSize() {
    if (_fontSize < 28) {
      setState(() {
        _fontSize += 2;
      });
    }
  }

  void _decreaseFontSize() {
    if (_fontSize > 12) {
      setState(() {
        _fontSize -= 2;
      });
    }
  }

  void _toggleNightMode() {
    setState(() {
      _isNightMode = !_isNightMode;
    });
  }

  void _addBookmark() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已添加书签')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isNightMode ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = _isNightMode ? Colors.grey[300] : Colors.black87;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: _isNightMode ? const Color(0xFF2A2A2A) : null,
        title: Text(widget.book.title, style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
        actions: [
          IconButton(
            icon: Icon(_isNightMode ? Icons.wb_sunny : Icons.nights_stay),
            onPressed: _toggleNightMode,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: _addBookmark,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_sessionProgress != null && _isTimerActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: _isNightMode ? const Color(0xFF2A2A2A) : Colors.blue[50],
              child: Row(
                children: [
                  Icon(
                    _sessionProgress!.isActive ? Icons.timer : Icons.pause,
                    color: _isNightMode ? Colors.grey[300] : Colors.blue,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '学习时间: ${_sessionProgress!.formattedTime}',
                    style: TextStyle(color: textColor),
                  ),
                  const Spacer(),
                  Text(
                    '+${_sessionProgress!.earnedPoints}学海积分',
                    style: TextStyle(
                      color: _isNightMode ? Colors.amber[300] : Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.chapter.title,
                    style: TextStyle(
                      fontSize: _fontSize + 4,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    widget.chapter.content,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: textColor,
                      height: 1.8,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _isNightMode ? const Color(0xFF2A2A2A) : Colors.grey[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decreaseFontSize,
                  color: textColor,
                ),
                Text(
                  '字号',
                  style: TextStyle(color: textColor),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _increaseFontSize,
                  color: textColor,
                ),
                const VerticalDivider(width: 32),
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {},
                  color: textColor,
                ),
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () {},
                  color: textColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
