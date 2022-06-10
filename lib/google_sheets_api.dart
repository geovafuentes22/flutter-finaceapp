import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {

  "type": "service_account",
  "project_id": "flutter-gsheets-352822",
  "private_key_id": "cd548248bad5be2a541a7635c8072b675ad9b9e7",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQDTeA13MR/iDPn2\nA5oYxnno8Fb+GuTnAy2dzUE1+KbGQ3mOGIUsKp+sEzh9/YP6ygFJZI6FGrN/uqTS\nolIfP60rOoVuiQP+CXrz+qMyXVYj++r6Bq9OdHhMKd/V51yQj/BjLoSVFYs6eHxk\naI90tVb53XqPQULFHx5QwZ8xj4w9kRcLUGMAk0e+uJ/0vdtlN6DpL1X2TXUg/wtb\nrB6rXqgugqOvm8yfFnzVuDyP8fDsJ79gQFyfa5oAFofTTIRiNV/1sU+cU1G4OFUL\n7lpMS3+CYPy/k4aTJGVuSYENmj/hptkJ56NtwZVkz74cyiH9i3Hgil52LzXaSY7Y\nMt/EIj8XAgMBAAECgf94MEN2+vSkBbwLlwB+FFA1lGPdCGwQ4D2M8pudkTU4eiEc\nIdOOxqr5ofL5qJzabPVOQVi/Te23Kt2C2b7TA93oM9qieD1MpRa8lDcs6N+MlCF4\n+VOpw4ibwTD24gg6IZT+yfGQyi3XjaMlbkgajPZiDP8bbHwGjSktvN49zNhoJITN\n+8ULNuUgXwu2TmwNwgWBxaXb1n/rqW89AV7iUXJ56+ktz4wa7H01xE7F7m0oLXNj\nEIIHu4B+Yk1RfmpoMO7+Ot4QkX1inLsRL0JZvZJgSZIKybIe1Oc1lZtFYgJS0vZY\nlLTEBwUQCxN6h2lz3JSF3yDaLAtxO0jE8eTNS3UCgYEA/5b3/3AmR+y5/OdMhx1/\nYfkghPTD1Z1+sB4fM9QUB79lxfM4vFCO+g1LlcP60oJmzrEvvPnZrJ6Sptj16U+Y\nDsP5k8qLJ7Q1wqqp6DFwS+gaK/HS0Fv7qNth29/ZZnodwr8z1vNAObjHOj1QxBmc\nX9w7YcWyoX8f360IJcT8RmMCgYEA087z+DCQS8Gw6wsQUsRS8e+KldWTjJWw/wuD\nDHcRvdOh5zxv3I0KbI3pipM+BoFSyPuTAgJl4m0m/MXp/OWPhadQK+fjVvaiek/S\nYxZ1SkUw6p2d++AEoFm+n0ZngRGdspVnK8I7W4N0eihOc+p9hzktSpdTae2XQFJZ\n8d1jGL0CgYEAp1WU2jT3qyFOh0h7rv5d9qvfYYzKZiGt3upprUoNLyFdJWNe4tOv\nOADaWpwrrATaADq7MXM20zAifYAQSAbnW8tsrBjwUDdI90E66hzsE5ZLBDhXuDhw\npBW1lPmSYOhUcbsy2mj5xJC4RuX76deGrLAIZLPFhrwvBwdHDUtRi1cCgYBYnyXL\nOZ6WY/N/VMC+sLA31E87BALZdqR5AjsR0xwUPeFnHA19zXGIHBSUS6lPFXsq5sAK\nvjAc/iiq6LBPhUl41Zmg1UR01XsEDDPuC66Fpc+iytIYWhH1ebddcxrJkTJXT1W8\npGcrkiQBHK4+p+Vf19eQdyKKlsOLQSmrHkNhTQKBgFt1lhI+eJOiItOEbleANDUI\ns9nPNUYMlClqqpTqxZSnQ143RWKeHgdyoC+DChmavxO0UWWuihcXfdAUs4wJCxL+\nxH53Ivq21kAThI3GgocC/y+XZyOFwkcC1yN1PSWE4IZ7m3jUfunPAAQigT5VHcbf\nuaqZQPiyDXMhOKvw0Iyn\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets@flutter-gsheets-352822.iam.gserviceaccount.com",
  "client_id": "112656276343747121121",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets%40flutter-gsheets-352822.iam.gserviceaccount.com"

  
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1mp4SnLHZPiMD1WtMv9SQyRUbSWSfI41590BN2C2h5_w';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 1;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Guillermo');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
