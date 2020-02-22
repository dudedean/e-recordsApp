import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_records/utils/constant.dart';
import 'package:auto_size_text/auto_size_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Firestore _firestore = Firestore.instance;
  List<DocumentSnapshot> records = [];
  List<Map<dynamic, dynamic>> list = new List();
  var items = List<Map<dynamic, dynamic>>();
  bool _loadingRecords = true;
  TextEditingController searchingController = TextEditingController();

  getRecords() async {
    Query q = _firestore.collection("records").orderBy("artist");

    setState(() {
      _loadingRecords = true;
    });

    QuerySnapshot querySnapshot = await q.getDocuments();

    records = querySnapshot.documents;

    list = records.map((DocumentSnapshot docSnapshot) {
      return docSnapshot.data;
    }).toList();

    items.addAll(list);

    setState(() {
      _loadingRecords = false;
    });
  }

  void filterSearchResults(String query) {
    List<Map<dynamic, dynamic>> dummySearchList = List<Map<dynamic, dynamic>>();
    dummySearchList.addAll(list);

    if (query.isNotEmpty) {
      List<Map<dynamic, dynamic>> dummyListData = List<Map<dynamic, dynamic>>();
      dummySearchList.forEach((item) {
        if (item['song'].contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(list);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'e-Records',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'List of Records in Galeri Lebok Dana',
              style: Theme.of(context).textTheme.display1,
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  fillColor: Colors.black,
                  hintText: 'Azizah',
                  hintStyle: Theme.of(context).textTheme.caption,
                ),
                onChanged: (value) {
                  filterSearchResults(value);
                },
                style: kTextFieldInputStyle,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Expanded(
                child: _loadingRecords == true
                    ? Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      )
                    : Container(
                        child: items.length == 0
                            ? Center(
                                child: Text("No records to show"),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: items.length,
                                itemBuilder: (context, index) {
//                                  return ListTile(
//                                    title: Text(items[index]["artist"]),
//                                    subtitle: Text(items[index]["song"]),
//                                  );
                                  return Container(
                                    margin: EdgeInsets.only(
                                      bottom: 15,
                                    ),
                                    height: 125,
                                    child: Card(
                                      elevation: 5,
                                      color: Color(0xff424242),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AutoSizeText(
                                                'Artist : ${items[index]["artist"]}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AutoSizeText(
                                                'Song : ${items[index]["song"]}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AutoSizeText(
                                                'Record No. : ${items[index]["rec_no"]}',
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: AutoSizeText(
                                                'Directory : ${items[index]["directory"]}',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                      )),
          ],
        ),
      ),
    );
  }
}
