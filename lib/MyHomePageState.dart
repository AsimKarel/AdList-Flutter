import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'main.dart';

class MyHomePageState extends State<MyHomePage> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Widget _appBarTitle = new Text('Search Example');
  List names = new List();
  List filteredNames = new List();
  String brand = '';
  String ownership = '';
  String type = '';

  Map brand_filter = {};
  Map own_filter = {};
  Map type_filter = {};
  Map brand_filter_for_reset = {};
  Map own_filter_for_reset = {};
  Map type_filter_for_reset = {};

  List brands = [];
  List ownerships = [];
  List types = [];

  MyHomePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = '';
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Incrememnt',
        child: Image.asset(
          'icons/robot.png',
          color: Colors.white,
          width: 40,
        ),
        onPressed: () => modal(context),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: new TextField(
        controller: _filter,
        decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
      ),
      leading: new IconButton(
        icon: Icon(Icons.search),
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    // if (!(_searchText.isEmpty)) {
    List tempList = new List();
    for (int i = 0; i < filteredNames.length; i++) {
      if (filteredNames[i]['title']
          .toLowerCase()
          .contains(_searchText.toLowerCase().trim())) {
        brand_filter.forEach((key, value) {
          if (value == true && filteredNames[i]['brand'] == key) {
            type_filter.forEach((key, value) {
              if (value == true && filteredNames[i]['type'] == key) {
                own_filter.forEach((key, value) {
                  if (value == true && filteredNames[i]['used_status'] == key) {
                    var index = tempList.indexWhere(
                        (element) => element['id'] == filteredNames[i]['id']);
                    //
                    print(index);

                    if (index == -1) {
                      tempList.add(filteredNames[i]);
                    }
                  }
                });
              }
            });
          }
        });
      }
    }
    filteredNames = tempList;
    // }
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return Center(
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: filteredNames[index]['image'] != null
                      ? Image.network(
                          filteredNames[index]['image'],
                          width: 100,
                          height: 100,
                        )
                      : Icon(Icons.cancel),
                  title: Text(filteredNames[index]['title']),
                  subtitle: Text(filteredNames[index]['subtitle']),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Image.asset(
                      'icons/unity.png',
                      height: 20,
                      width: 20,
                      color: Colors.amber,
                    ),
                    Icon(
                      Icons.location_pin,
                      color: Colors.grey,
                    ),
                    Text(filteredNames[index]['city']),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  modal(BuildContext context) {
    Future<void> future = showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        context: context,
        builder: (context) {
          return new StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              color: Colors.transparent,
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        leading: Image.asset(
                          'icons/robot.png',
                          color: Colors.blue,
                          width: 50,
                        ),
                        title: Text(
                            'Welcome! I am Masoud, your virtual assistant')),
                    ListTile(
                      subtitle: Text('What kind of car are you looking?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: List<Widget>.generate(
                            types.length,
                            (int index) {
                              return Wrap(children: [
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text(
                                    types[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  selected: type_filter[types[index]],
                                  backgroundColor: Colors.blue,
                                  selectedColor: Colors.blueGrey,
                                  avatarBorder: CircleBorder(),
                                  onSelected: (bool selected) {
                                    type_filter[types[index]] =
                                        !type_filter[types[index]];
                                    setState(() {});
                                  },
                                )
                              ]);
                            },
                          ).toList(),
                        )
                      ],
                    ),
                    ListTile(
                      subtitle: Text('What brand are you looking for?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: List<Widget>.generate(
                            brands.length,
                            (int index) {
                              print(brand_filter);
                              return Wrap(children: [
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text(
                                    brands[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  selected: brand_filter[brands[index]],
                                  backgroundColor: Colors.blue,
                                  selectedColor: Colors.blueGrey,
                                  avatarBorder: CircleBorder(),
                                  onSelected: (bool selected) {
                                    brand_filter[brands[index]] =
                                        !brand_filter[brands[index]];
                                    setState(() {});
                                  },
                                )
                              ]);
                            },
                          ).toList(),
                        )
                      ],
                    ),
                    ListTile(
                      subtitle: Text('Are you looking for new or used car?'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                          children: List<Widget>.generate(
                            ownerships.length,
                            (int index) {
                              return Wrap(children: [
                                const SizedBox(width: 8),
                                ChoiceChip(
                                  label: Text(
                                    ownerships[index],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  selected: own_filter[ownerships[index]],
                                  backgroundColor: Colors.blue,
                                  selectedColor: Colors.blueGrey,
                                  avatarBorder: CircleBorder(),
                                  onSelected: (bool selected) {
                                    own_filter[ownerships[index]] =
                                        !own_filter[ownerships[index]];
                                    setState(() {});
                                  },
                                ),
                              ]);
                            },
                          ).toList(),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Wrap(
                          children: [
                            ElevatedButton(
                                onPressed: () => _applyFilter(context),
                                child: Text('Apply')),
                            const SizedBox(width: 8),
                            ElevatedButton(
                                onPressed: () => _cancelFilter(context),
                                child: Text('Clear Filter'))
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              height: 800,
            );
          });
        });
    future.then((void value) => _closeModal(value));
  }

  void _applyFilter(BuildContext ctx) {
    setState(() {
      filteredNames = names;
    });
    Navigator.pop(ctx);
  }

  void _cancelFilter(BuildContext ctx) {
    setState(() {
      type_filter = new Map.from(type_filter_for_reset);
      brand_filter = new Map.from(brand_filter_for_reset);
      own_filter = new Map.from(own_filter_for_reset);
      filteredNames = names;
    });
    // _applyFilter(ctx);
    Navigator.pop(ctx);
  }

  void _closeModal(void value) {}

  void _searchPressed() {
    setState(() {
      filteredNames = names;
      _filter.clear();
    });
  }

  void _getData() async {
    List items = [];
    List brandList = [];
    List typeList = [];
    List usedList = [];
    Map usedFilter = {};
    Map typesFilter = {};
    Map brandsFilter = {};
    CollectionReference ref = FirebaseFirestore.instance.collection('cars');
    await ref
        .get()
        .then((value) => {
              // print(value.docs[2])
              items = value.docs.map((doc) {
                var car = doc.data();
                if (brandList.indexOf(car['brand']) == -1) {
                  brandList.add(car['brand']);
                  brandsFilter[car['brand']] = true;
                }
                if (car['type'] != null) {
                  if (typeList.indexOf(car['type']) == -1) {
                    typeList.add(car['type']);
                    typesFilter[car['type']] = true;
                  }
                }
                if (car['used_status'] != null) {
                  if (usedList.indexOf(car['used_status']) == -1) {
                    usedList.add(car['used_status']);
                    usedFilter[car['used_status']] = true;
                  }
                }
                return car;
              }).toList()
              // _searchPressed();
            })
        .catchError((e) => {print(e)});
    setState(() {
      names = items;
      filteredNames = names;
      brands = brandList;
      brand_filter = brandsFilter;
      types = typeList;
      type_filter = typesFilter;
      ownerships = usedList;
      own_filter = usedFilter;
      own_filter_for_reset = new Map.from(usedFilter);
      type_filter_for_reset = new Map.from(typesFilter);
      brand_filter_for_reset = new Map.from(brandsFilter);
    });
  }
}
