import 'dart:async';
import 'package:expense_calculator/CRUD.dart';
import 'package:expense_calculator/auth_controller.dart';
import 'package:expense_calculator/data.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'top_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _title = TextEditingController();
  TextEditingController _amount = TextEditingController();
  TextEditingController _date = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  @override
  void initState() {
    super.initState();
    fetchBalance().then((value) {
      setState(() {
        print('Fetched');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthenticationHelper().signOut();
              Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginPage()));
            },
            color: Colors.black,
          )
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              TopNeuCard(
                balance: Data.totalBalance.toString(),
                income: Data.totalIncome.toString(),
                expense: Data.totalExpenses.toString(),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection(AuthenticationHelper().id).snapshots(),
                  builder: (context, snapshot){
                    if(!snapshot.hasData){
                      return CircularProgressIndicator();
                    }
                    else if(snapshot.hasError){
                      return Center(
                        child: Text('An error occurred'),
                      );
                    }
                    else{
                     return ListView.builder(
                       itemCount: snapshot.data!.docs.length,
                       shrinkWrap: true,
                       physics: BouncingScrollPhysics(),
                       itemBuilder: (context, index){
                         return Dismissible(
                           key: Key(snapshot.data!.docs[index].id),
                           background: Container(
                             color: Colors.deepPurple.withOpacity(0.4),
                           ),
                           onDismissed: (direction){
                             CRUD.deleteItem(snapshot.data!.docs[index].id, snapshot.data!.docs[index].data() as Map<String, dynamic>).then((value){
                               if(value){
                                 setState(() {
                                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Successfully Deleted')));
                                 });
                               }
                               else{
                                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error occurred')));
                               }
                             });
                           },
                           child: Card(
                             elevation: 2.0,
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10)
                             ),
                             child: ListTile(
                               onTap: (){
                                 _amount.text = snapshot.data!.docs[index]['amount'].toString();
                                 _title.text = snapshot.data!.docs[index]['title'];
                                 _date.text = snapshot.data!.docs[index]['date'];
                                 _isIncome = snapshot.data!.docs[index]['expenseOrIncome'];

                                 _transaction('Update', snapshot.data!.docs[index].id, snapshot.data!.docs[index].data() as Map<String, dynamic>);
                               },
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(10)
                               ),
                               tileColor: Colors.grey[100],
                               title: Text(snapshot.data!.docs[index]['title'],
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.grey[700],
                                   )),
                               subtitle: Text(snapshot.data!.docs[index]['date'],
                                   style: TextStyle(
                                     fontSize: 12,
                                     color: Colors.grey[500],
                                   )),
                               trailing: Text(
                                 (snapshot.data!.docs[index]['expenseOrIncome'] ? '+' : '-') + Data.rssymbol + snapshot.data!.docs[index]['amount'].toString(),
                                 style: TextStyle(
                                   fontSize: 16,
                                   color: snapshot.data!.docs[index]['expenseOrIncome'] ? Colors.green : Colors.red,
                                 ),
                               ),
                             ),
                           ),
                         );
                       },
                     );
                    }
                  },
                )
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ( )=> _transaction('Add'),
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Future<bool> fetchBalance() async {
    DocumentSnapshot balance = await FirebaseFirestore.instance.collection('balance').doc(AuthenticationHelper().id).get();
    print(balance.data());
    if(balance.data() == null){
      Data.totalBalance = 0;
      Data.totalExpenses = 0;
      Data.totalIncome = 0;
    }
    else{
      Map<String, dynamic> data = balance.data() as Map<String, dynamic>;
      Data.totalBalance = data['totalBalance'];
      Data.totalExpenses = data['totalExpenses'];
      Data.totalIncome = data['totalIncome'];
    }
    return true;
  }

  void _transaction(String action, [String id = '', Map<String, dynamic>? oldData]) {
    _date.text = DateTime.now().toString().substring(0,10);
    bool _loading = false;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text('$action Transaction'),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        action == "Add" ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Expense'),
                            Switch(
                              value: _isIncome,
                              onChanged: (newValue) {
                                setState(() {
                                  _isIncome = newValue;
                                });
                              },
                            ),
                            Text('Income'),
                          ],
                        ) : Container(),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Title',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter Title';
                                  }
                                  return null;
                                },
                                controller: _title,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Amount',
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Enter an amount';
                                  }
                                  return null;
                                },
                                controller: _amount,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Date',
                                ),
                                controller: _date,
                                onTap: () async {
                                    var date =  await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now().subtract(Duration(days: 14)),
                                        lastDate: DateTime.now());
                                    _date.text = date.toString().substring(0,10);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.deepPurple.withOpacity(0.4),
                    child:
                    Text('Cancel', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: Colors.deepPurple.withOpacity(0.4),
                    child: _loading ? Container(
                      margin: EdgeInsets.all(5),
                        child: CircularProgressIndicator(
                          color: Colors.deepPurpleAccent,
                        )
                    ) : Text(action, style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState((){
                          _loading = true;
                        });
                        if(action == "Add"){
                          await CRUD.addItem({
                            'amount' : int.parse(_amount.text),
                            'date' : _date.text,
                            'title' : _title.text,
                            'expenseOrIncome' : _isIncome
                          }).then((value){
                            if(value){
                              print('Success');
                              _date.clear();
                              _title.clear();
                              _amount.clear();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Successfully Added')));
                            }
                            else{
                              print('Failed');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
                            }
                          });
                        }
                        else{
                          await CRUD.updateItem(id, {
                            'amount' : int.parse(_amount.text),
                            'date' : _date.text,
                            'title' : _title.text,
                            'expenseOrIncome' : _isIncome
                          }, oldData!).then((value){
                            if(value){
                              print('Success');
                              _date.clear();
                              _title.clear();
                              _amount.clear();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Successfully Updated')));
                            }
                            else{
                              print('Failed');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
                            }
                          });
                        }
                        setState((){
                          _loading = false;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        }).then((value){
       setState(() {
         print('Updating');
       });
    });
  }
}
