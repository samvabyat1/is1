// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'account.dart';
import 'onbuy.dart';

class Marketplace extends StatefulWidget {
  const Marketplace({super.key});

  @override
  State<Marketplace> createState() => _MarketplaceState();
}

class _MarketplaceState extends State<Marketplace> {
  var isVisible = true;

  var companies = [
    {'name': '', 'price': '0', 'train': ''}
  ];
  Future<void> initiate() async {
    final ref =
        FirebaseDatabase.instance.ref().child('market').orderByChild('name');

    ref.onValue.listen((event) {
      for (final child in event.snapshot.children) {
        if (mounted && child.key != 'date') {
          setState(() {
            companies.add({
              'name': child.child('name').value.toString(),
              'price': child.child('price').value.toString(),
              'train': child.child('train').value.toString(),
            });
          });
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initiate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Marketplace',
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xff7151a9),
                      ),
                    ),
                    Icon(
                      Icons.business_rounded,
                      color: Color(0xff7151a9),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                TextField(
                  enabled: false,
                  onTap: () {
                    setState(() {
                      isVisible = false;
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search_rounded),
                    prefixIconColor: Color(0xff7151a9),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Color(0xff573d7f)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff7151a9), width: 3),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide:
                          BorderSide(color: Color(0xff7151a9), width: 3),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey, width: 3),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: isVisible,
                  child: Image(
                    image: AssetImage("asset/undraw_Ready_for_waves_vlke.png"),
                    height: 200,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: companies.length - 1,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Buy(company: {
                              'name': companies[index + 1]['name'],
                              'price': companies[index + 1]['price'],
                              'train': companies[index + 1]['train'],
                            }),
                          )),
                      child: Card(
                        color: Color(0xffebe0ff),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    companies[index + 1]['name']!,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    '₹ ${companies[index + 1]['price']}/-',
                                  ),
                                  Container(
                                    color: Colors.purple,
                                    width: 1,
                                    height: 15,
                                  ),
                                  Icon(
                                    Icons.add_task_rounded,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Buy extends StatefulWidget {
  final company;
  const Buy({super.key, required this.company});

  @override
  State<Buy> createState() => _BuyState();
}

class _BuyState extends State<Buy> {
  double slidemark = 1;
  var pricelist = [];

  final List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();

    if (mounted) {
      setState(() {
        pricelist = widget.company['train'].toString().split(' ');

        print(widget.company['train']);

        print(pricelist);

        for (int i = 1; i < pricelist.length; i++) {
          chartData.add(ChartData(i, int.parse(pricelist[i])));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffcaf0f8),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.company['name']}',
                      style: TextStyle(
                        fontSize: 28,
                        color: Color(0xff03045e),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Account',
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Account(),
                          )),
                      icon: Icon(Icons.person_rounded),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  textAlign: TextAlign.center,
                                  '₹ ${widget.company['price']}',
                                  style: TextStyle(fontSize: 30),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  'per 1% company sold share',
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Performance',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  'Good',
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rating',
                                  style: TextStyle(fontSize: 10),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  '⭐⭐⭐',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      child: Card(
                        color: Color(0xff023e8a),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.security_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Slider(
                          activeColor: Color(0xff023e8a),
                          value: slidemark,
                          label: '${slidemark.round()}%',
                          divisions: 10,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              slidemark = value;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Count: $slidemark%',
                                  style: TextStyle(fontSize: 10),
                                ),
                                Text(
                                    'Pay: ₹ ${slidemark * int.parse(widget.company['price'])}'),
                              ],
                            ),
                            TextButton(
                                onPressed: () async {
                                  // final Uri url = Uri.parse(
                                  //     'psm://open.com?${widget.company['name'].toString().replaceAll(' ', '_')}+${(slidemark * int.parse(widget.company['price'])).toInt()}');
                                  // if (slidemark > 0.0) {
                                  //   try {
                                  //     await launchUrl(url);
                                  //   } catch (e) {
                                  //     Fluttertoast.showToast(
                                  //         msg: 'Target app not found');
                                  //   }
                                  // }

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OnBuy(
                                          url:
                                              'psm://open.com?${widget.company['name'].toString().replaceAll(' ', '_')}+${(slidemark * int.parse(widget.company['price'])).toInt()}',
                                        ),
                                      ));
                                },
                                child: Text(
                                  'BUY',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: (slidemark > 0.0)
                                          ? Color(0xff023e8a)
                                          : Colors.grey),
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Text(
                  'You are ready to buy $slidemark% shares from ${widget.company['name']}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  height: 35,
                ),
                SfCartesianChart(series: <ChartSeries>[
                  // Renders line chart
                  LineSeries<ChartData, int>(
                      dataSource: chartData,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y)
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final int x;
  final int y;
}
