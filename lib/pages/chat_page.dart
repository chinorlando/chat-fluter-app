import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();
  bool _estaEscribiendo = false;

  List<ChatMessage> _messages = [
    // ChatMessage(uid: '123', texto: 'hola mundo'),
    // ChatMessage(uid: '1231', texto: 'hola mundo'),
    // ChatMessage(uid: '123', texto: 'hola mundo'),
    // ChatMessage(uid: '1231', texto: 'hola mundo'),
    // ChatMessage(uid: '123', texto: 'hola mundo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(height: 3),
            Text(
              'Orlando Mamani ',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              ),
            ),
            Divider(height: 1),
            Container(
              color: Colors.white,
              height: 100,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String texto) {
                  setState(() {
                    if (texto.trim().length > 0)
                      _estaEscribiendo = true;
                    else
                      _estaEscribiendo = false;
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: "Enviar Mensaje"),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estaEscribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estaEscribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) {
      return;
    }
    print(texto);

    final newMessages = new ChatMessage(
      uid: '123',
      texto: texto,
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 400),
      ),
    );
    _messages.insert(0, newMessages);
    newMessages.animationController.forward();

    _textController.clear();
    _focusNode.requestFocus();
    setState(() {
      _estaEscribiendo = false;
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
