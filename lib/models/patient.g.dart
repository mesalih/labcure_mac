// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatientAdapter extends TypeAdapter<Patient> {
  @override
  final int typeId = 0;

  @override
  Patient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Patient(
      uid: fields[0] as String,
      pid: fields[1] as String,
      title: fields[2] as String,
      name: fields[3] as String,
      age: fields[4] as String,
      gender: fields[6] as String,
      admissionDate: fields[7] as String?,
      reportDate: fields[8] as String?,
      tested: fields[9] as bool,
      urgent: fields[10] as bool,
      postpone: fields[11] as bool,
      tests: (fields[12] as List).cast<Test>(),
    );
  }

  @override
  void write(BinaryWriter writer, Patient obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.pid)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(6)
      ..write(obj.gender)
      ..writeByte(7)
      ..write(obj.admissionDate)
      ..writeByte(8)
      ..write(obj.reportDate)
      ..writeByte(9)
      ..write(obj.tested)
      ..writeByte(10)
      ..write(obj.urgent)
      ..writeByte(11)
      ..write(obj.postpone)
      ..writeByte(12)
      ..write(obj.tests);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
