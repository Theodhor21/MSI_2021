class Workspace {
  String name;
  int currentInWorkspace;
  List<EnterLog> enterLog;
  List<Machines> machines;

  Workspace({
    this.name,
    this.currentInWorkspace,
    this.enterLog,
    this.machines
  });

  Workspace.fromJson(Map<String, dynamic> json) {
    name: json['name'] ?? '';
    currentInWorkspace: json['currentInWorkspace'] as int;
    if (json['enterLog'] != null) {
      enterLog = List<EnterLog>();
      json['enterLog'].forEach((entry) {
        enterLog.add(EnterLog.fromJson(entry));
      });
    }
    if (json['machines'] != null) {
      machines = List<Machines>();
      json['machines'].forEach((entry) {
        machines.add(Machines.fromJson(entry));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['currentInWorkspace'] = this.currentInWorkspace;
    if(this.enterLog != null) {
      data['enterLog'] = this.enterLog.map((entry) => entry.toJson()).toList();
    }
    if(this.machines != null) {
      data['machines'] = this.machines.map((entry) => entry.toJson()).toList();
    }
    return data;
  }
}

class EnterLog {
  String studentId;
  String studentFirstName;
  String studentLastName;
  String enterTimestamp;
  String leaveTimestamp;

  EnterLog({
    this.studentId,
    this.studentFirstName,
    this.studentLastName,
    this.enterTimestamp
  });

  EnterLog.fromJson(Map<String, dynamic> json) {
    studentId: json['studentId'];
    studentFirstName: json['studentFirstName'];
    studentLastName: json['studentLastName'];
    enterTimestamp: json['enterTimestamp'];
    leaveTimestamp: json['leaveTimestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['studentId'] = this.studentId;
    data['studentFirstName'] = this.studentFirstName;
    data['studentLastName'] = this.studentLastName;
    data['enterTimestamp'] = this.enterTimestamp;
    data['leaveTimestamp'] = this.leaveTimestamp;
    return data;
  }
}

class Machines {
  String machineId;
  String machineType;
  String machineCertificateStatus;

  Machines({
    this.machineId,
    this.machineType,
    this.machineCertificateStatus
  });

  factory Machines.fromJson(Map<String, dynamic> json) {
    return Machines(
      machineId: json['machineId'],
      machineType: json['machineType'],
      machineCertificateStatus: json['machineCertificateStatus']
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['machineId'] = this.machineId;
    data['machineType'] = this.machineType;
    data['machineCertificateStatus'] = this.machineCertificateStatus;
    return data;
  }
}