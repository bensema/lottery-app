import 'dart:core';

import 'package:flutter/material.dart';
import 'package:lottery_app/commons/app_navigator.dart';
import 'package:lottery_app/commons/constants.dart';
import 'package:lottery_app/components/adaptor.dart';
import 'package:lottery_app/components/empty_widget.dart';
import 'package:lottery_app/shrink/model/number_three_shrink.dart';

class LotteryView extends StatefulWidget {
  NumberThreeShrink shrink;

  LotteryView({@required this.shrink});

  @override
  LotteryViewState createState() => new LotteryViewState();
}

class LotteryViewState extends State<LotteryView> {
  ///是否加载完成
  ///
  bool loading = true;

  ///缩水的数据
  List<List<int>> balls = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Adaptor.width(290),
      height: Adaptor.width(420),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Adaptor.width(5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: Adaptor.width(10)),
                child: Text(
                  '缩水结果',
                  style: TextStyle(
                    fontSize: Adaptor.sp(16),
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Positioned(
                right: Adaptor.width(14),
                top: Adaptor.width(10),
                bottom: Adaptor.width(10),
                child: GestureDetector(
                  onTap: () {
                    AppNavigator.goBack(context);
                  },
                  child: Container(
                    child: Icon(
                      IconData(0xe651, fontFamily: 'iconfont'),
                      size: Adaptor.sp(17),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Constant.line,
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (!loading) {
      if (balls.length > 0) {
        return Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      0,
                      Adaptor.width(15),
                      0,
                      Adaptor.width(15),
                    ),
                    alignment: Alignment.center,
                    child: Wrap(
                      spacing: Adaptor.width(7),
                      runSpacing: Adaptor.width(10),
                      children: balls
                          .map(
                            (ball) => _buildLottery(ball),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              Container(
                height: Adaptor.height(32),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xffFFF2EA),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Adaptor.width(5)),
                    bottomRight: Radius.circular(Adaptor.width(5)),
                  ),
                ),
                child: Text(
                  widget.shrink.type == 0
                      ? '直选共${balls.length}注号码'
                      : '组选共${balls.length}注号码',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: Adaptor.sp(14),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            EmptyView(
              icon: 'assets/images/empty.png',
              message: '没有符合的号码',
              callback: () {},
            )
          ],
        ),
      );
    }
    return Expanded(
      child: Center(
        child: Constant.loading(),
      ),
    );
  }

  Widget _buildLottery(List<int> balls) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: balls
            .map(
              (ball) => Container(
                height: Adaptor.width(18),
                width: Adaptor.width(18),
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: Adaptor.width(2.5)),
                decoration: BoxDecoration(
                  color: Color(0xfff2f2f2),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(Adaptor.width(14)),
                ),
                child: Text(
                  '$ball',
                  style: TextStyle(
                    fontSize: Adaptor.sp(11),
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1500), () {
      widget.shrink.shrink();
      setState(() {
        balls.addAll(
          widget.shrink.type == 0
              ? widget.shrink.direct
              : widget.shrink.combine,
        );
      });
    }).then((_) {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
