import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_app/models/question_model.dart';
import 'package:quiz_app/models/tech_stack_model.dart';
import 'package:quiz_app/services/app_exception.dart';
import 'package:quiz_app/utils/colored_log.dart';

class QuizRepo {
  Future<List<TechStackModel>> getTechStack({String? q}) async {
    try {
      Query query = FirebaseFirestore.instance
          .collection("tech stack")
          .orderBy(FieldPath.documentId);

      QuerySnapshot querySnapshot = await query.get();
      List<TechStackModel> stacks = querySnapshot.docs.map((doc) {
        return TechStackModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      if (q != null && q.trim().isNotEmpty) {
        String searchKey = q.trim().toLowerCase();
        stacks = stacks
            .where((stack) => stack.category!.toLowerCase().contains(searchKey))
            .toList();
      }

      return stacks;
    } on FirebaseException catch (e) {
      ColoredLog(e.toString());
      throw FirebaseAuthError(title: e.code, message: e.message);
    } catch (e) {
      ColoredLog(e.toString());
      throw AppExceptionHandler.throwException(e);
    }
  }

  Future<List<QuestionModel>> getQuations(String category) async {
    try {
      final query = FirebaseFirestore.instance
          .collection("tech stack")
          .doc(category)
          .collection("questions");

      QuerySnapshot querySnapshot = await query.get();
      List<QuestionModel> questions = querySnapshot.docs.map((doc) {
        return QuestionModel.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
      questions.shuffle(Random());
      return questions.take(20).toList();
    } on FirebaseException catch (e) {
      ColoredLog(e.toString());
      throw FirebaseAuthError(title: e.code, message: e.message);
    } catch (e) {
      ColoredLog(e.toString());
      throw AppExceptionHandler.throwException(e);
    }
  }
}
