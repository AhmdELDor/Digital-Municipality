import 'utils/helpers/connectivity_helper.dart';
import 'presentation/app/app.dart';
import 'presentation/app/bootstrap.dart';

void main() {
  bootstrap(() async {
    final ConnectivityHelper connectivityHelper = ConnectivityHelper();
    return EducationApp(connectivityHelper: connectivityHelper);
  });
}
