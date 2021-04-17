class Student {
  String studentId;
  String studentNumber;
  String studentFirstName;
  String studentLastName;

  Student({
    this.studentId,
    this.studentNumber,
    this.studentFirstName,
    this.studentLastName,
  });

  factory Student.fromJson(Map<String, dynamic> responseData) {
    return Student(
      studentId: responseData['studentId'],
      studentNumber: responseData['studentNumber'],
      studentFirstName: responseData['studentFirstName'],
      studentLastName: responseData['studentLastName']
    );
  }
}