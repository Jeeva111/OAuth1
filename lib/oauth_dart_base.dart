// ignore_for_file: constant_identifier_names
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'consumer.dart';
import 'signature_method.dart';
import 'token.dart';

class Oauth1 {
  final Consumer consumer;
  final Token token;
  final String signatureMethod;
  final String account;

  Oauth1(
      {required this.consumer,
      required this.token,
      required this.account,
      this.signatureMethod = SignatureMethod.HMACSHA256});

  Future<http.Response> get(String uri) {
    Uri url = Uri.parse(uri);
    Uri baseUrl = Uri.https(url.authority, url.path);
    final Map<String, String> query = Uri.splitQueryString(url.query);

    var queryMap = _getParams(query);
    final String queryString = Uri(
        queryParameters: queryMap
            .map((key, value) => MapEntry(key, value?.toString()))).query;

    List<String> baseList = [
      'GET',
      Uri.encodeComponent(baseUrl.toString()),
      Uri.encodeComponent(queryString)
    ];

    String baseString = baseList.join('&');
    String signature = _hashFunction(baseString);

    Map<String, String> requestHeaders = {
      'Authorization': header(signature, queryMap),
      'Content-type': 'application/json',
    };

    return http.get(url, headers: requestHeaders);
  }

  Map<String, dynamic> _getParams(Map<String, String> query) {
    Map<String, String> params = {
      'oauth_consumer_key': consumer.key,
      'oauth_nonce': _getNonce(),
      'oauth_signature_method': signatureMethod,
      'oauth_timestamp': _getTimeStamp(),
      'oauth_token': token.key,
      'oauth_version': '1.0'
    };

    params.addAll(query);
    return Map.fromEntries(
        params.entries.toList()..sort((e1, e2) => e1.key.compareTo(e2.key)));
  }

  String _getTimeStamp() {
    var millisecondsSinceEpoch = DateTime.now().toUtc().millisecondsSinceEpoch;
    var timeStamp = (millisecondsSinceEpoch / 1000).round();

    return timeStamp.toString();
  }

  String _getNonce({int length = 32}) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();

    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  String header(String signature, Map<String, dynamic> header) {
    var authHeader = {
      'realm': Uri.encodeComponent(account),
      'oauth_consumer_key': Uri.encodeComponent(consumer.key),
      'oauth_token': Uri.encodeComponent(token.key),
      'oauth_signature_method': Uri.encodeComponent(signatureMethod),
      'oauth_timestamp': Uri.encodeComponent(header['oauth_timestamp']!),
      'oauth_nonce': Uri.encodeComponent(header['oauth_nonce']!),
      'oauth_version': Uri.encodeComponent(header['oauth_version']!),
      'oauth_signature': Uri.encodeComponent(signature)
    };

    var headerString = 'OAuth ';
    authHeader.forEach((key, value) {
      headerString += '$key="$value", ';
    });

    return headerString.substring(0, headerString.length - 2);
  }

  String _hashFunction(String message) {
    List<int> bytes = utf8.encode(message);
    List<int> secret = utf8.encode('${consumer.secret}&${token.secret}');

    Hmac hmacSha256 = Hmac(sha256, secret);
    Digest digest = hmacSha256.convert(bytes);

    return base64Encode(digest.bytes);
  }
}
