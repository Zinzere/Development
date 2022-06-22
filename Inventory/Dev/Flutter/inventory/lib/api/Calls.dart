import './Urls.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Calls {
  static Future getProducts(json) async {}
  static Future getOrderReports() async {
    var url = Uri.parse(Urls.API_GET_ORDER_REPORT);
    var result = await http.get(url);
    var json = jsonDecode(result.body);
    if(json["res"]) { return json["data"];} else { return [];}
  }
  static Future getMstUnits() async {
    var url = Uri.parse(Urls.API_GET_UNITS);
    var result = await http.get(url);
    return jsonDecode(result.body);
  }
  static Future getGeneral() async {
    var url = Uri.parse(Urls.API_GET_GENERAL);
    var result = await http.get(url);
    return jsonDecode(result.body);
  }
  static Future insUpdDelMstUnits(sendMap) async {
    var url = Uri.parse(Urls.API_IUD_UNITS);
    var jsonBody = jsonEncode(sendMap);
    var result = await http.put(url,headers: {"Content-Type": "application/json"}, body: jsonBody);
    return jsonDecode(result.body);
  }
  static Future updBillStatus(sendMap) async {
    var jsonBody = jsonEncode(sendMap);
    var url = Uri.parse(Urls.API_UPD_BILL_STS);
    var result = await http.put(url,headers: {"Content-Type": "application/json"}, body: jsonBody);
    return jsonDecode(result.body);
  }
  static Future insDelMasterTypes(sendMap) async {
    var jsonBody = jsonEncode(sendMap);
    var url = Uri.parse(Urls.API_INS_DEL_MTYPE);
    var result = await http.put(url,headers: {"Content-Type": "application/json"}, body: jsonBody);
    return jsonDecode(result.body);
  }
  static Future search(sendMap) async {
    var jsonBody = jsonEncode(sendMap);
    var url = Uri.parse(Urls.API_SEARCH);
    var result = await http.put(url,headers: {"Content-Type": "application/json"}, body: jsonBody);
    return jsonDecode(result.body);
  }
}
