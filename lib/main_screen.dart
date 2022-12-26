import 'package:shared_preferences/shared_preferences.dart';
import 'package:fortune/settings_screen.dart';
import 'package:fortune/store_screen.dart';
import 'package:fortune/skin_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;
  late int _counter = 0;
  late String _fortune = "Click to Begin";
  late String _image = "images/cookie.png";
  late int _add = 1;
  late int _sound = 1;
  late int _dark = 0;
  late int _started = 0;
  late int _coin = 0;
  late int _envelope = 0;
  late int _selected = 1;

  void incrementCounter() async {
    if (_sound == 1) {
      SystemSound.play(SystemSoundType.click);
    }
    setState(() {
      _counter += _add;
      if (_counter == 1 || (((25 + sqrt(625 + 100 * _counter)) / 50) - ((25 + sqrt(625 + 100 * _counter)) / 50).floor()) == 0) {
        fetchFortune();
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  void fetchFortune() async {
    const url = "http://yerkee.com/api/fortune/wisdom";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    if (json["fortune"].length > 100) {
      fetchFortune();
    }
    else{
      setState(() {
        _fortune = json["fortune"];
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("fortune", _fortune);
    }
  }

  void getCounter() async {
    final prefs = await SharedPreferences.getInstance();
    int? counter = prefs.getInt("counter");
    if (counter != null) {
      _counter = counter;
    }
  }

  void getFortune() async {
    final prefs = await SharedPreferences.getInstance();
    String? fortune = prefs.getString("fortune");
    if (fortune != null) {
      _fortune = fortune;
    }
  }

  void getAdd() async {
    final prefs = await SharedPreferences.getInstance();
    int? add = prefs.getInt("add");
    if (add != null) {
      _add = add;
    }
  }

  void getSound() async {
    final prefs = await SharedPreferences.getInstance();
    int? sound = prefs.getInt("sound");
    if (sound != null) {
      _sound = sound;
    }
  }

  void getDark() async {
    final prefs = await SharedPreferences.getInstance();
    int? dark = prefs.getInt("dark");
    if (dark != null) {
      _dark = dark;
    }
  }

  void getCoin() async {
    final prefs = await SharedPreferences.getInstance();
    int? coin = prefs.getInt("coin");
    if (coin != null) {
      _coin = coin;
    }
  }

  void getEnvelope() async {
    final prefs = await SharedPreferences.getInstance();
    int? envelope = prefs.getInt("envelope");
    if (envelope != null) {
      _envelope = envelope;
    }
  }

  void getSelected() async {
    final prefs = await SharedPreferences.getInstance();
    int? selected = prefs.getInt("selected");
    if (selected != null) {
      _selected = selected;
    }
  }

  void setAdd(add) async {
    setState(() {
      _add = add;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('add', _add);
  }

  void setCounter(counter) async {
    setState(() {
      _counter = counter;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('counter', _counter);
  }

  void setSound(sound) async {
    setState(() {
      _sound = sound;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sound', _sound);
  }

  void setDark(dark) async {
    setState(() {
      _dark = dark;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dark', _dark);
  }

  void setCoin(coin) async {
    setState(() {
      _coin = coin;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('coin', _coin);
  }

  void setEnvelope(envelope) async {
    setState(() {
      _envelope = envelope;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('envelope', _envelope);
  }

  void setSelected(selected) async {
    setState(() {
      _selected = selected;
      if (selected == 1) {
        _image = "images/cookie.png";
      }
      else if (selected == 2) {
        _image = "images/pig.png";
      }
      else if (selected == 3) {
        _image = "images/cat.png";
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected', _selected);
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    getCounter();
    getFortune();
    getAdd();
    getSound();
    getDark();
    getCoin();
    getEnvelope();
    getSelected();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          toolbarHeight: 100,
          title: Column(
            children: [
              Text(_counter == 0 && _started == 0 ? 'Fortune Clicker' : 'Level ${((25 + sqrt(625 + 100 * _counter)) / 50).floor()}', style: const TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: "Kavoon-Regular")),
              padding(),
              score(),
              progress(),
            ],
          ),
          backgroundColor: Colors.transparent.withOpacity(0.4),
          elevation: 0.0,
        ),
        body: Container(
          decoration: _dark == 0 ? const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.png"),
                fit: BoxFit.cover,
              ))
              : const BoxDecoration(color: Colors.black),
          child: Column(
            mainAxisAlignment: _counter == 0 && _started == 0 ? MainAxisAlignment.center : MainAxisAlignment.end,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, bottom: 20.0),
                child: Text(_fortune, style: _dark == 0 ? const TextStyle(color: Colors.black, fontSize: 20.0, fontFamily: "Kavoon-Regular") : const TextStyle(color: Colors.white, fontSize: 20.0, fontFamily: "Kavoon-Regular")),
              ),
              Center(
                child: GestureDetector(
                  onTap: incrementCounter,
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: SizedBox(
                      height: 250,
                      child: Image.asset(_image),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _counter == 0 && _started == 0 ? Container() : skin(),
                  ),
                  Expanded(
                    child: _counter == 0 && _started == 0 ? Container() : store(),
                  ),
                  Expanded(
                    child: _counter == 0 && _started == 0 ? Container() : settings(),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }

  Widget skin() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding (
          padding: const EdgeInsets.only(top: 120.0, bottom: 40.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.black87,
            ),
            width: 75.0,
            height: 75.0,
            child: Center(
                child: IconButton(
                  onPressed: (){
                    if (_sound == 1) {
                      SystemSound.play(SystemSoundType.click);
                    }
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SkinScreen(
                                counter: _counter,
                                sound: _sound,
                                dark: _dark,
                                coin: _coin,
                                envelope: _envelope,
                                selected: _selected,
                              ),
                        )
                    ).then((list){
                      setSelected(list[0]);
                      setCoin(list[1]);
                      setEnvelope(list[2]);
                      setCounter(list[3]);
                    });
                  },
                  icon: const Icon(Icons.cookie, size: 30.0),
                  color: Colors.white,
                )
            ),
          ),
        )
    );
  }

  Widget store() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding (
        padding: const EdgeInsets.only(top: 120.0, bottom: 40.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.black87,
          ),
          width: 75.0,
          height: 75.0,
          child: Center(
            child: IconButton(
              onPressed: (){
                if (_sound == 1) {
                  SystemSound.play(SystemSoundType.click);
                }
                Navigator.push(context,
                  MaterialPageRoute(
                    builder: (context) =>
                        StoreScreen(
                          counter: _counter,
                          add: _add,
                          sound: _sound,
                          dark: _dark,
                        ),
                  )
                ).then((list){
                  setAdd(list[0]);
                  setCounter(list[1]);
                  _started = 1;
                });
              },
              icon: const Icon(Icons.store, size: 30.0),
              color: Colors.white,
            )
          ),
        ),
      )
    );
  }

  Widget settings() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding (
          padding: const EdgeInsets.only(top: 120.0, bottom: 40.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.black87,
            ),
            width: 75.0,
            height: 75.0,
            child: Center(
                child: IconButton(
                  onPressed: (){
                    if (_sound == 1) {
                      SystemSound.play(SystemSoundType.click);
                    }
                    Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SettingsScreen(
                                counter: _counter,
                                sound: _sound,
                                dark: _dark,
                              ),
                        )
                    ).then((list){
                      setSound(list[0]);
                      setDark(list[1]);
                    });
                  },
                  icon: const Icon(Icons.settings, size: 30.0),
                  color: Colors.white,
                )
            ),
          ),
        )
    );
  }

  Widget padding() {
    if (_counter == 0 && _started == 0) {
      return Container();
    }
    return const SizedBox(height: 5);
  }

  Widget score() {
    if (_counter == 0 && _started == 0) {
      return Container();
    }
    return Text(_counter == 1 ? '$_counter Cookie!' : '$_counter Cookies!', style: const TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: "Kavoon-Regular"));
  }

  Widget progress() {
    if (_counter == 0 && _started == 0) {
      return Container();
    }
    return LinearProgressIndicator(value: (((25 + sqrt(625 + 100 * _counter)) / 50) - ((25 + sqrt(625 + 100 * _counter)) / 50).floor()), minHeight: 10);
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
