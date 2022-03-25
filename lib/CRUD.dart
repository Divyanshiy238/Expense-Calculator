import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_calculator/data.dart';

class CRUD {
  static final _balanceDb = FirebaseFirestore.instance.collection('balance');
  static final _dataDb = FirebaseFirestore.instance.collection('allExpensesAndIncome');

  static Future<bool> addItem(Map<String, dynamic> data) async {
    await _dataDb.add(data);

    if(data['expenseOrIncome']){
      Data.totalBalance += int.parse(data['amount'].toString());
      Data.totalIncome += int.parse(data['amount'].toString());
    }
    else{
      Data.totalBalance -= int.parse(data['amount'].toString());
      Data.totalExpenses += int.parse(data['amount'].toString());
    }

    await _balanceDb.doc('data').update({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }

  static Future<bool> updateItem(String id, Map<String, dynamic> data, Map<String, dynamic> oldData) async {
    await _dataDb.doc(id).update(data);

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

    await _balanceDb.doc('data').update({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }

  static Future<bool> deleteItem(String id, Map<String, dynamic> data) async {
    await _dataDb.doc(id).delete();

    if(data['expenseOrIncome']){
      Data.totalBalance -= int.parse(data['amount'].toString());
      Data.totalIncome -= int.parse(data['amount'].toString());
    }
    else{
      Data.totalBalance += int.parse(data['amount'].toString());
      Data.totalExpenses -= int.parse(data['amount'].toString());
    }

    await _balanceDb.doc('data').update({
      'totalBalance' : Data.totalBalance,
      'totalIncome' : Data.totalIncome,
      'totalExpenses' : Data.totalExpenses
    });

    return true;
  }
}