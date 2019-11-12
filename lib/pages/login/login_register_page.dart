import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_flutter/common/GlobalConfig.dart';
import 'package:wan_flutter/common/Router.dart';
import 'package:wan_flutter/common/Snack.dart';
import 'package:wan_flutter/common/User.dart';
import 'package:wan_flutter/fonts/IconF.dart';

class LoginRegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginRegisterPageState();
  }
}

class LoginRegisterPageState extends State<LoginRegisterPage> {
  var _isLogin = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _nameController.addListener(() {});
    _passwordController.addListener(() {});
    _confirmPswController.addListener(() {});
    return Scaffold(
        appBar: AppBar(
          title: Text(
              _isLogin ? GlobalConfig.loginTitle : GlobalConfig.registerTitle),
          leading: _buildBackButton(context),
          centerTitle: true,
        ),
        body: Builder(builder: (ct) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(24, 60, 24, 0),
            children: <Widget>[
              _buildUserNameEdit(),
              _buildPasswordEdit(),
              _buildConfirmPswEdit(),
              _buildRegOrLoginButton(ct),
              _buildRegOrLoginHintButton(),
            ],
          );
        }));
  }

  Widget _buildRegOrLoginButton(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.all(8.0),
      color: GlobalConfig.colorPrimary,
      child: Text(
        _isLogin ? "登录" : "注册",
        style: TextStyle(fontSize: 16),
      ),
      textColor: Colors.white,
      elevation: 3,
      onPressed: () {
        var password = _passwordController.text;
        var username = _nameController.text;
        var confirmPsw = _confirmPswController.text;
        if (password.length == 0 || username.length == 0) {
          Snack.show(context, "请输入用户名或密码");
          return;
        }

        if (password.length < 6 || username.length < 6) {
          Snack.show(context, "账号/密码不符合标准");
          return;
        }
        User().userName = username;
        var callback = (bool loginOK, String errorMsg) {
          if (loginOK) {
            Snack.show(context, "登录成功");
            Timer(Duration(milliseconds: 400), () {
              Router().back(context);
            });
          } else {
            Snack.show(context, errorMsg);
          }
        };
        if (_isLogin) {
          User().password = password;
          User().login(callback: callback);
        } else {
          if (confirmPsw.length == 0) {
            Snack.show(context, "请输入确认密码");
            return;
          }
          if (confirmPsw != password) {
            Snack.show(context, "两次输入密码不一致");
            return;
          }
          User().password = password;
          User().register(callback: callback);
        }
      },
    );
  }

  Widget _buildRegOrLoginHintButton() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          onPressed: () {
            setState(() {
              _isLogin = !_isLogin;
            });
          },
          child: Text(
            _isLogin ? "注册新账号" : "直接登录",
            style: TextStyle(fontSize: 15, color: Colors.black54),
          )),
    );
  }

  Widget _buildConfirmPswEdit() {
    return Offstage(
      offstage: _isLogin,
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          child: TextField(
            controller: _confirmPswController,
            maxLines: 1,
            maxLength: 15,
            obscureText: true,
            style: TextStyle(color: Colors.black54, fontSize: 16),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.event,
                  color: GlobalConfig.colorPrimary,
                ),
                labelText: "确认密码",
                hintText: "请再次输入密码",
                contentPadding: EdgeInsets.all(2),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10))),
          )),
    );
  }

  Widget _buildPasswordEdit() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextField(
        controller: _passwordController,
        maxLength: 15,
        maxLines: 1,
        obscureText: true,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black54, fontSize: 16),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.event_note,
              color: GlobalConfig.colorPrimary,
            ),
            labelText: "密码",
            hintText: "请输入密码",
            contentPadding: EdgeInsets.all(2),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Widget _buildUserNameEdit() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
      child: TextField(
        controller: _nameController,
        maxLines: 1,
        maxLength: 15,
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.black54, fontSize: 16),
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.person,
              color: GlobalConfig.colorPrimary,
            ),
            labelText: "用户名",
            hintText: "请输入用户名",
            contentPadding: EdgeInsets.all(2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            )),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return IconButton(
        icon: Icon(
          IconF.back,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  @override
  void dispose() {
    _passwordController?.dispose();
    _nameController?.dispose();
    _confirmPswController?.dispose();
    super.dispose();
  }
}
