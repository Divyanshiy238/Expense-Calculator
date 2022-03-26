import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_calculator/auth_controller.dart';
import 'package:expense_calculator/data.dart';

class CRUD {
  static Future<bool> addItem(Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().email).add(data);

    if(data['expenseOrIncome']){
      Data.totalBalance += int.parse(data['amount'].toString());
      Data.totalIncome += int.parse(data['amount'].toString());
    }
    else{
      Data.totalBalance -= int.parse(data['amount'].toString());
      Data.totalExpenses += int.parse(data['amount'].toString());
    }

    await FirebaseFirestore.instance.collection('balance').doc(AuthenticationHelper().email).set({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }

  static Future<bool> updateItem(String id, Map<String, dynamic> data, Map<String, dynamic> oldData) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().email).doc(id).update(data);

    if(data['expenseOrIncome']){
      Data.totalBalance -= int.parse(oldData['amount'].toString());
      Data.totalIncome -= int.parse(oldData['amount'].toString());
    }
    else{
      Data.totalBalance += int.parse(oldData['amount'].toString());
      Data.totalExpenses -= int.parse(oldData['amount'].toString());
    }

    if(data['expenseOrIncome']){
      Data.totalBalance += int.parse(data['amount'].toString());
      Data.totalIncome += int.parse(data['amount'].toString());
    }
    else{
      Data.totalBalance -= int.parse(data['amount'].toString());
      Data.totalExpenses += int.parse(data['amount'].toString());
    }

    await FirebaseFirestore.instance.collection('balance').doc(AuthenticationHelper().email).set({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }

  static Future<bool> deleteItem(String id, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(AuthenticationHelper().email).doc(id).delete();

    if(data['expenseOrIncome']){
      Data.totalBalance -= int.parse(data['amount'].toString());
      Data.totalIncome -= int.parse(data['amount'].toString());
    }
    else{
      Data.totalBalance += int.parse(data['amount'].toString());
      Data.totalExpenses -= int.parse(data['amount'].toString());
    }

    await FirebaseFirestore.instance.collection('balance').doc(AuthenticationHelper().email).set({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }
}