import 'package:easybudget/constant/color.dart';
import 'package:easybudget/firebase/search_db.dart';
import 'package:easybudget/layout/appbar_layout.dart';
import 'package:easybudget/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/login_db.dart';

class MemberManagementScreen extends StatelessWidget {
  //const MemberManagementScreen({super.key});
  final String spaceName;
  final String currentUserId;
  const MemberManagementScreen({super.key, required this.spaceName, required this.currentUserId});

  Future<List<Map<String, dynamic>>> fetchMembers() async {

    String? sdocid = '';

    await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get()
        .then((value) {
          for (var element in value.docs) {
            sdocid = element.id;
          }
    });

    Map <String, dynamic> members = {};
    List<Map<String, dynamic>> testmember = [];
    int count = 0;

    final spaceQuerySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .doc(sdocid)
        .collection('Member')
        .get();

    if (spaceQuerySnapshot.docs.isEmpty) {
      // 해당하는 스페이스가 없을 경우 빈 리스트를 반환합니다.
      return [];
    }

    for (var doc in spaceQuerySnapshot.docs) {
      print(doc['uid']);
      if (doc.data().isNotEmpty) {
        String memberData = doc.get('uid');
        print("--------------------------");
        members['uid$count'] = memberData;
        print(members);
        count++;
      }
    }
    // print(members);
    testmember.add(members);

    return testmember;
/*    // Space 컬렉션에서 members 배열을 가져옵니다.
    final spaceQuerySnapshot = await FirebaseFirestore.instance
        .collection('Space')
        .where('sname', isEqualTo: spaceName)
        .get();

    // 문서가 하나 이상일 경우 첫 번째 문서를 선택합니다.
    final spaceSnapshot = spaceQuerySnapshot.docs.isNotEmpty
        ? spaceQuerySnapshot.docs.first
        : null;

    if (spaceSnapshot == null) {
      // 해당하는 스페이스가 없을 경우 빈 리스트를 반환합니다.
      return [];
    }

    List<dynamic> memberIds = spaceSnapshot.data()?['members'] ?? [];

    // members 배열의 각 문서 ID를 사용하여 user 컬렉션에서 데이터를 가져옵니다.
    List<Map<String, dynamic>> members = [];
    for (String memberId in memberIds) {
      final userSnapshot = await FirebaseFirestore.instance.collection('User').doc(memberId).get();
      if (userSnapshot.exists) {
        members.add(userSnapshot.data()!);
      }
    }

    return members;*/
  }


  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      appbar: AppbarLayout(
        title: '스페이스 멤버 관리',
        action: [], back: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Members Found'));
          }

          final members = snapshot.data!;
          final spaceId = members.isNotEmpty ? members.first['sid'] : '';

          return FutureBuilder<int>(
            future: fetchCurrentUserAuthority(spaceId),
            builder: (context, authoritySnapshot) {
              if (authoritySnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (authoritySnapshot.hasError) {
                return Center(child: Text('Error: ${authoritySnapshot.error}'));
              }

              final currentUserAuthority = authoritySnapshot.data ?? 0;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    for (var member in members)
                      _MemberContainer(
                        name: member['uname'] ?? 'Unknown',
                        uid: member['uid'] ?? 'Unknown',
                        sid: member['sid'] ?? 'Unknown',
                        authority: member['authority'] ?? 0,
                        profile: 'asset/img/profile_img_2.png',
                        currentUserAuthority: currentUserAuthority,
                        onRemove: () {
                          setState(() {
                            members.remove(member);
                          });
                        },
                      ),
                    Divider(
                      color: Color(0xffe9ecef),
                    ),
                  ],
                ),
                // Add other notification widgets
              ],
            ),
          );
        },
      ),
    );
  }
}


class _MemberContainer extends StatefulWidget {
  final String name;
  final String uid;
  final String sid;
  final String profile;
  int authority;
  _MemberContainer({Key? key, required this.name, required this.uid, required this.sid, required this.authority, required this.profile});

  @override
  _MemberContainerState createState() => _MemberContainerState();
}

class _MemberContainerState extends State<_MemberContainer> {
  String authorityText = '';

  @override
  void initState() {
    super.initState();
    updateAuthorityText();
  }

  void updateAuthorityText() {
    switch (widget.authority) {
      case 1:
        authorityText = '관리자';
        break;
      case 2:
        authorityText = '일반';
        break;
      case 3:
        authorityText = '기록제한';
        break;
      default:
        authorityText = 'Unknown';
        break;
    }
  }

  void _showAuthorityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            "권한 선택",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'NotoSansKR',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAuthorityOption(1, '관리자'),
              _buildAuthorityOption(2, '일반'),
              _buildAuthorityOption(3, '기록제한'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAuthorityOption(int authorityValue, String text) {
    return ListTile(
      title: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
          fontFamily: 'NotoSansKR',
        ),
      ),
      onTap: () {
        setState(() {
          widget.authority = authorityValue;
          updateAuthorityText();
          Navigator.pop(context);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 30),
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xffe9ecef)), // 위쪽 테두리
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.profile),
              ),
              SizedBox(width: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.name}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                  Text(
                    '(${widget.uid})',
                    style: TextStyle(
                      color: Colors.black38,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'NotoSansKR',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              OutlinedButton(
                onPressed: _showAuthorityDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: blueColor,
                  side: BorderSide(color: blueColor),
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                ),
                child: Row(
                  children: [
                    Text(
                      authorityText,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'NotoSansKR',
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              SizedBox(width: 5),
              ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때 수행할 작업

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: primaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5), // 버튼을 조금 더 각지게 만듦
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(
                  '탈퇴',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSansKR',
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
