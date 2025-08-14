class Note{
  String? uid;
  String title;
  String body;

  Note({required this.title, required this.body, required this.uid});

  Map<String, dynamic> toJson(){
    return {
      'uid': uid,
      'title': title,
      'body': body
    };
  }
}