import 'package:inventory_v1/domain/entities/checked-out/cart_check_out_entity.dart';
import 'package:inventory_v1/domain/entities/checked-out/checked_out_entity.dart';
import 'package:inventory_v1/domain/entities/part/part_entity.dart';
import 'package:inventory_v1/data/models/part/part_model.dart';

class ValuesForTest {
  List<Map<String, dynamic>> partsList = [
    {
      'name': 'SCREW,SEQUENCE',
      'partNumber': 'MS40483-1-12',
      'nsn': '5310-00-024-9878',
      'location': 'V1A2B',
      'quantity': 30,
      'requisitionPoint': 10,
      'requisitionQuantity': 34,
      'serialNumber': 'SY13938',
      'unitOfIssue': 'HD',
    },
    {
      'name': 'BOLT, HEX',
      'partNumber': 'MS41483-1-13',
      'nsn': '5310-00-223-9849',
      'location': 'V1A2C',
      'quantity': 25,
      'requisitionPoint': 30,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12939',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'NUT, HEX',
      'partNumber': 'MS40483-1-14',
      'nsn': '5310-00-024-9878',
      'location': 'V1A2D',
      'quantity': 40,
      'requisitionPoint': 13,
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
      'requisitionPoint': 40,
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
      'requisitionPoint': 35,
      'requisitionQuantity': 1,
      'serialNumber': 'SY12942',
      'unitOfIssue': 'EA',
    },
    {
      'name': 'BOLT, SQUARE',
      'partNumber': 'MS38483-1-17',
      'nsn': '5310-00-023-9878',
      'location': 'V1A2G',
      'quantity': 28,
      'requisitionPoint': 6,
      'requisitionQuantity': 1,
      'serialNumber': 'SY13943',
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
      'requisitionPoint': 23,
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
    var parts = getPartList().map((e) => PartModel.fromJson(e)).toList();
    return parts;
  }

  List<PartModel> partModels() {
    return parts().map((element) {
      return PartEntityToModelAdapter.fromEntity(element);
    }).toList();
  }

  List<CheckedOutEntity> createCheckedOutList() {
    return [
      CheckedOutEntity(
        index: 0,
        checkedOutQuantity: 2,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CheckedOutEntity(
        index: 1,
        checkedOutQuantity: 3,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CheckedOutEntity(
        index: 2,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),

      CheckedOutEntity(
        index: 3,
        checkedOutQuantity: 3,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 7)),
        partEntityIndex: parts()[0].index,
        isVerified: true,
        verifiedDate: DateTime.now().subtract(const Duration(days: 6)),
      ),
      CheckedOutEntity(
        index: 4,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 5,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 6,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 7,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 8,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 9,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 4)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),
      CheckedOutEntity(
        index: 10,
        checkedOutQuantity: 10,
        quantityDiscrepancy: 0,
        dateTime: DateTime.now().subtract(const Duration(days: 10)),
        partEntityIndex: parts()[0].index,
        isVerified: false,
        verifiedDate: null,
      ),

      // Add more variations as needed
    ];
  }

  List<CartCheckoutEntity> getCartCheckoutEntities() {
    List<CartCheckoutEntity> newList = [];

    for (var checkoutPart in createCheckedOutList()) {
      newList.add(CartCheckoutEntity(
          checkedOutEntity: checkoutPart,
          partEntity: parts()[checkoutPart.partEntityIndex]));
    }

    return newList;
  }
}
