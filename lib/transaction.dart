import 'package:flutter/material.dart';

class MyTransaction extends StatelessWidget {
  final String transactionName;
  final String money;
  final bool expenseOrIncome;
  final String date;

  MyTransaction({
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.date
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[500]),
                    child: Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transactionName,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          )),
                      Text(date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          )),
                    ],
                  ),
                ],
              ),
              Text(
                (expenseOrIncome ? '-' : '+') + '\$' + money,
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color:
                      expenseOrIncome ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
