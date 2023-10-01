import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

sendEmail(String email, String messageWelcome, String content) async { 
  // من نوع اثنك لان تحتاج تتصل بالفاير بيس  ويبغا لها وقت على ماتتنفذ
  String username = 'lujainqm1@gmail.com';
  String password = 'hlbhuckrhjunkdfe';
  final smtpServer = gmail(username, password);

  final message = Message()
    ..from = Address(username, 'تراحم') // عنان الرساله
    ..recipients.add(email)
    ..subject = messageWelcome // مرحبا بك
    ..html = "<h1>$content</h1>"; 

  try { 
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
  } on MailerException catch (e) { // اذا حدث غلط
    print('Message not sent.');
    for (var p in e.problems) { // اذا كان فيه مشكله
      print('Problem: ${p.code}: ${p.msg}');
    }
  }
}
