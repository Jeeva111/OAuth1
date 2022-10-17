import 'package:flutter/material.dart';

import 'consumer.dart';
import 'oauth_dart_base.dart';
import 'token.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('API DEMO')),
        body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _fetch(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 20.0),
                    color: Colors.blue,
                    child: const Text(
                      'Material Required',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Text(result)
            ],
          ),
        ));
  }

  void _fetch() {
    var baseUrl = 'some_url';
    String consumerKey =
        '9363a82abf93a9a6c7e1ec39a5f115c1fa1e898b761351fb804f63b116ca095f';
    String consumerSecret =
        '98829b488b5694aaab6b92b46a8102316c3c3c7a8b8e71a2e8d49309f9d23e3b';
    String tokenKey =
        'f446dd6ce19a62fcdf8e2319d3ff993d5f3928a40aeceeac5f6f11ae0ae024ff';
    String tokenSecret =
        'b9ad063a4ff67bc1c098aca19cab52f98f3080900f80f8e4fab7cfef0a22fa54';

    Consumer consumer = Consumer(consumerKey, consumerSecret);
    Token token = Token(tokenKey, tokenSecret);

    var oauth =
        Oauth1(consumer: consumer, token: token, account: '7460472_SB1');
    var request = oauth.get(baseUrl);

    request.then((response) {
      setState(() {
        result = response.body;
      });
    });
  }
}
