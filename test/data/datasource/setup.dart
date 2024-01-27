import 'package:inventory_v1/data/models/part/part_model.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';

class ValuesForTest {
  List<Map<String, dynamic>> partsList = [
    {
      'name': 'SCREW,MACHINE',
      'partNumber': 'MS38483-1-12',
      'nsn': '5310-00-023-9878',
      'location': 'V1A2B',
      'quantity': 30,
      'requisitionPoint': 1,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12938',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'BOLT, HEX',
      'partNumber': 'MS38483-1-13',
      'nsn': '5310-00-023-9879',
      'location': 'V1A2C',
      'quantity': 25,
      'requisitionPoint': 2,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12939',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'NUT, HEX',
      'partNumber': 'MS38483-1-14',
      'nsn': '5310-00-023-9880',
      'location': 'V1A2D',
      'quantity': 40,
      'requisitionPoint': 3,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12940',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'WASHER, FLAT',
      'partNumber': 'MS38483-1-15',
      'nsn': '5310-00-023-9881',
      'location': 'V1A2E',
      'quantity': 20,
      'requisitionPoint': 4,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12941',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'SCREW, CAP',
      'partNumber': 'MS38483-1-16',
      'nsn': '5310-00-023-9882',
      'location': 'V1A2F',
      'quantity': 35,
      'requisitionPoint': 5,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12942',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'BOLT, SQUARE',
      'partNumber': 'MS38483-1-17',
      'nsn': '5310-00-023-9883',
      'location': 'V1A2G',
      'quantity': 28,
      'requisitionPoint': 6,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12943',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'NUT, WING',
      'partNumber': 'MS38483-1-18',
      'nsn': '5310-00-023-9884',
      'location': 'V1A2H',
      'quantity': 45,
      'requisitionPoint': 7,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12944',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'WASHER, LOCK',
      'partNumber': 'MS38483-1-19',
      'nsn': '5310-00-023-9885',
      'location': 'V1A2I',
      'quantity': 18,
      'requisitionPoint': 8,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12945',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'SCREW, SET',
      'partNumber': 'MS38483-1-20',
      'nsn': '5310-00-023-9886',
      'location': 'V1A2J',
      'quantity': 22,
      'requisitionPoint': 9,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12946',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'BOLT, THREADED',
      'partNumber': 'MS38483-1-21',
      'nsn': '5310-00-023-9887',
      'location': 'V1A2K',
      'quantity': 32,
      'requisitionPoint': 10,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12947',
      'unitOfIssue': 'EA',
    },
  ];

  List<Map<String, dynamic>> getPartList() {
    var parts = partsList.map((e) {
      var newData = Map<String, dynamic>.from(e);
      if (!e.containsKey('index')) {
        newData['index'] = partsList.indexOf(e);
      }
      return newData;
    }).toList();
    return parts;
  }

  List<PartEntity> parts() {
    var parts = getPartList().map((e) => Part.fromJson(e)).toList();
    return parts;
  }
}
