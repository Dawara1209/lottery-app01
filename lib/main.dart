import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(LotteryApp());
}

class LotteryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '抽選アプリ',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LotteryScreen(),
    );
  }
}

class LotteryScreen extends StatefulWidget {
  @override
  _LotteryScreenState createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  int totalParticipants = 200; // 抽選人数
  int ticketNumber = 108; // 整理券番号
  int? myResult; // 自分の結果
  List<int> allResults = []; // 全抽選結果

  void drawLottery() {
    // 抽選ロジック
    List<int> numbers = List.generate(totalParticipants, (index) => index + 1);
    numbers.shuffle();

    setState(() {
      allResults = numbers.sublist(0, ticketNumber);
      myResult = allResults.last;
    });
  }

  void resetLottery() {
    setState(() {
      totalParticipants = 200;
      ticketNumber = 108;
      myResult = null;
      allResults = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抽選アプリ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: '抽選人数を設定（最大2000人）'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? input = int.tryParse(value);
                if (input != null && input > 0 && input <= 2000) {
                  totalParticipants = input;
                }
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: '自分の整理券番号を設定'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int? input = int.tryParse(value);
                if (input != null && input > 0 && input <= totalParticipants) {
                  ticketNumber = input;
                }
              },
            ),
            ElevatedButton(
              onPressed: drawLottery,
              child: Text('抽選を開始'),
            ),
            if (myResult != null) ...[
              Text('あなたの抽選結果: $myResult', style: TextStyle(fontSize: 20)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetLottery,
                child: Text('リセット'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResultScreen(
                        allResults: allResults,
                        ticketNumber: ticketNumber,
                      ),
                    ),
                  );
                },
                child: Text('詳細確認'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<int> allResults;
  final int ticketNumber;

  ResultScreen({required this.allResults, required this.ticketNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('抽選結果一覧'),
      ),
      body: ListView.builder(
        itemCount: allResults.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('整理券番号: ${index + 1}'),
            subtitle: Text('抽選結果: ${allResults[index]}'),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // 前の画面に戻る
          },
          child: Text('抽選に戻る'),
        ),
      ),
    );
  }
}
