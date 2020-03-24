import 'package:flutter/material.dart';
import 'package:vouched/src/blocs/user.dart';
import 'package:vouched/src/models/user.dart';
import 'package:vouched/src/screens/profile/widgets/skills/skill_edit.dart';

class SkillsPage extends StatelessWidget {
  final UserBloc userBloc;
  final User user;
  final bool allowUserEdit;

  SkillsPage({
    @required this.userBloc,
    @required this.user,
    @required this.allowUserEdit,
  });

  @override
  Widget build(BuildContext context) {
    final skills = user.skills.map((skill) {
      return GestureDetector(
        onTap: () => _editSkill(context, skill),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSkillRange(
              context,
              skill.name,
              skill.value,
            ),
            user.skills.last != skill ? Divider() : Container(),
          ],
        ),
      );
    }).toList();

    return Container(
      margin: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              bottom: 20,
            ),
            child: Text('Skills',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (user.skills == null || user.skills.isEmpty)
                  Center(
                    child: Text(
                      allowUserEdit
                          ? 'No skill added yet, click on + button to add a new skill'
                          : 'This user have no skill added yet',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                if (user.skills != null && user.skills.isNotEmpty) ...skills
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildSkillRange(context, String skillName, double percent) {
    final barColors = [Colors.red, Colors.grey, Colors.green, Colors.blue];
    final colorIndex = ((percent / 3) * 10).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          skillName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width - 70,
              margin: EdgeInsets.only(top: 5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(barColors[colorIndex]),
                  backgroundColor: Colors.grey[200],
                  value: percent,
                ),
              ),
            ),
            Text(
              (percent * 100).toInt().toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _editSkill(context, skill) {
    return Navigator.of(context).push(
      PageRouterSkill(
        skillUID: skill.uid,
        userBloc: userBloc,
        user: user,
        title: "Edit Skill",
        name: skill.name,
        value: skill.value,
        info:
            "You can add information about a skill that you consider important for your profile",
        warning: "Are you sure you want to exit without save?",
        editing: true,
      ),
    );
  }
}
