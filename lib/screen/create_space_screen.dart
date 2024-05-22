import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easybudget/constant/color.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';

import 'mypage_screen.dart';

class CreateSpaceScreen extends StatefulWidget {
  const CreateSpaceScreen({super.key});

  @override
  _CreateSpaceScreenState createState() => _CreateSpaceScreenState();
}

class _CreateSpaceScreenState extends State<CreateSpaceScreen> {
  TextEditingController spaceNameController = TextEditingController();
  TextEditingController participationCodeController = TextEditingController();
  TextEditingController confirmParticipationCodeController = TextEditingController();
  TextEditingController tagController = TextEditingController();
  bool isApprovalRequired = false;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 생성하기',
        action: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MypageScreen(), // 수정
                  ),
                );
              },
              icon: Icon(CupertinoIcons.person_crop_circle_fill),
              iconSize: 30,
            ),
          ),
        ],
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(
              flex: 9,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '스페이스 이름',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: spaceNameController,
                      decoration: InputDecoration(
                        hintText: '이름을 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // 중복 확인 로직 추가
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromRGBO(0, 88, 246, 1),
                        side: BorderSide(color: Color.fromRGBO(0, 88, 246, 1), width: 2),
                      ),
                      child: Text('중복확인'),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '참여코드',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: participationCodeController,
                      decoration: InputDecoration(
                        hintText: '참여코드를 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '참여코드 확인',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          '*',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: confirmParticipationCodeController,
                      decoration: InputDecoration(
                        hintText: '참여코드를 한번 더 입력해 주세요.',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '태그',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextField(
                      controller: tagController,
                      decoration: InputDecoration(
                        hintText: '태그를 작성하여 주세요. ex) #경기대',
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '참여 기능 승인',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '참여 승인 기능을 ON으로 설정 시 스페이스에 새로   참여할 때 관리자의 승인을 반드시 받아야 합니다.',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isApprovalRequired = !isApprovalRequired;
                            });
                          },
                          child: Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isApprovalRequired
                                    ? Color.fromRGBO(0, 88, 246, 1)
                                    : Color.fromRGBO(194, 194, 194, 1),
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              children: [
                                AnimatedPositioned(
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeIn,
                                  left: isApprovalRequired ? 30 : 0,
                                  right: isApprovalRequired ? 0 : 30,
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isApprovalRequired
                                          ? Color.fromRGBO(0, 88, 246, 1)
                                          : Color.fromRGBO(194, 194, 194, 1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: isApprovalRequired ? Alignment.centerLeft : Alignment.centerRight,
                                  child: Text(
                                    isApprovalRequired ? 'ON' : 'OFF',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: isApprovalRequired
                                          ? Color.fromRGBO(0, 88, 246, 1)
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // 스페이스 생성 로직 추가
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blueColor,
                      foregroundColor: primaryColor,
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansKR',
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text('스페이스 생성'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
