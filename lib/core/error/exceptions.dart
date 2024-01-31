///Thrown when an error occurs when interacting with the database
class DatabaseException implements Exception {}

///Thrown when an error occurs when creating new data
///in the database
class CreateDataException implements Exception {}

///Thrown when an error occurs when updating data
///in the database
class UpdateDataException implements Exception {}

///Thrown when an error occurs when reading data
///from the database
class ReadDataException implements Exception {}

///Thrown when an error occurs when deleting data
///from the database
class DeleteDataException implements Exception {}

//Thrown when an index is out of the specified bounds
class IndexOutOfBounds implements Exception {}
