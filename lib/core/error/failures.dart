import "package:equatable/equatable.dart";

///Failure class, represents errors that occur during application
///use. Takes a [errorMessage] that presents the user with the error
abstract class Failure extends Equatable {
  ///Takes the error message as a param
  const Failure({required this.errorMessage});

  final String errorMessage;
  @override
  List<Object> get props => <Object>[];
}

///General failures that may occur during runtime

///Returned when an error is encounterd while getting data from the database
///
class FetchDataFailure extends Failure {
  ///Takes a error message that is then passed to the super class
  ///by default the error message is
  ///[Unable to retrive the document right now, please try later.]
  const FetchDataFailure(
      {String errMsg =
          'Unable to retrive the document right now, please try later.'})
      : super(errorMessage: errMsg);
}

///Returned when an error is encounter while creating data
///
class CreateDataFailure extends Failure {
  ///Takes an error message that is then passed to the super class
  ///by default the error message is
  ///[Unable to store your info in the database, please try again later.]
  const CreateDataFailure(
      {String errMsg =
          'Unable to store your info in the database, please try again later.'})
      : super(errorMessage: errMsg);
}

///Returned when an error occurs  while updating data

class UpdateDataFailure extends Failure {
  ///Takes an error message that is then passed to the super class
  ///by default the error message is
  ///[Unable to update the document right now, please try again later.]
  const UpdateDataFailure(
      {String errMsg =
          'Unable to update the document right now, please try again later.'})
      : super(errorMessage: errMsg);
}

///Returned when an error occurs while deleting data
class DeleteDataFailure extends Failure {
  ///Takes an error message that is then passed to the super class
  ///by default the error message is
  ///[Unable to delete the document right now, please try again later.]
  const DeleteDataFailure(
      {String errMsg =
          'Unable to delete the document right now, please try again later.'})
      : super(errorMessage: errMsg);
}

///Returned when an error occurs while checking permissions

class PermissionFailure extends Failure {
  ///Takes an error message that is then passed to the super class
  ///by default the error message is
  ///[Location permissions are permanently denied, we cannot request
  ///permissions.]
  const PermissionFailure(
      {String errMsg =
          // ignore: lines_longer_than_80_chars
          'Location permissions are permanently denied, we cannot request permissions.'})
      : super(errorMessage: errMsg);
}
