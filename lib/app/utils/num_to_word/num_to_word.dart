String numToWordsIndia(int number) {
  return NumberToWordIndia().convert(number);
}

String numToWordsUs(int number) {
  return NumberToWordUS().convert(number);
}

class NumberToWordIndia {
  String convert(int digit) {
    final int number = digit;
    String numberString = '0000000000$number';
    numberString =
        numberString.substring(number.toString().length, numberString.length);
    var str = '';

    List<String> ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    str += (numberString[0]) != '0'
        ? '${ones[int.parse(numberString[0])]} Hundred '
        : ''; //hundreds

    if ((int.parse('${numberString[1]}${numberString[2]}')) < 20 &&
        (int.parse('${numberString[1]}${numberString[2]}')) > 9) {
      str +=
          '${ones[int.parse('${numberString[1]}${numberString[2]}')]} Crore ';
    } else {
      str += (numberString[1]) != '0'
          ? '${tens[int.parse(numberString[1])]} '
          : ''; //tens
      str += (numberString[2]) != '0'
          ? '${ones[int.parse(numberString[2])]} Crore '
          : ''; //ones
      str +=
          (numberString[1] != '0') && (numberString[2] == '0') ? 'Crore ' : '';
    }

    if ((int.parse('${numberString[3]}${numberString[4]}')) < 20 &&
        (int.parse('${numberString[3]}${numberString[4]}')) > 9) {
      str += '${ones[int.parse('${numberString[3]}${numberString[4]}')]} Lakh ';
    } else {
      str += (numberString[3]) != '0'
          ? '${tens[int.parse(numberString[3])]} '
          : ''; //tens
      str += (numberString[4]) != '0'
          ? '${ones[int.parse(numberString[4])]} Lakh '
          : ''; //ones
      str +=
          (numberString[3] != '0') && (numberString[4] == '0') ? 'Lakh ' : '';
    }

    if ((int.parse('${numberString[5]}${numberString[6]}')) < 20 &&
        (int.parse('${numberString[5]}${numberString[6]}')) > 9) {
      str +=
          '${ones[int.parse('${numberString[5]}${numberString[6]}')]} Thousand ';
    } else {
      str += (numberString[5]) != '0'
          ? '${tens[int.parse(numberString[5])]} '
          : ''; //ten thousands
      str += (numberString[6]) != '0'
          ? '${ones[int.parse(numberString[6])]} Thousand '
          : ''; //thousands
      str += (numberString[5] != '0') && (numberString[6] == '0')
          ? 'Thousand '
          : '';
    }

    str += (numberString[7]) != '0'
        ? '${ones[int.parse(numberString[7])]} Hundred '
        : ''; //hundreds
    if ((int.parse('${numberString[8]}${numberString[9]}')) < 20 &&
        (int.parse('${numberString[8]}${numberString[9]}')) > 9) {
      str += ones[int.parse('${numberString[8]}${numberString[9]}')];
    } else {
      str += (numberString[8]) != '0'
          ? '${tens[int.parse(numberString[8])]} '
          : ''; //tens
      str += (numberString[9]) != '0'
          ? ones[int.parse(numberString[9])]
          : ''; //ones
    }

    return str;
  }
}

class NumberToWordUS {
  String convert(int number) {
    if (number < 0) return 'Negative ${convert(-number)}';

    if (number == 0) return 'Zero Dollars';

    List<String> ones = [
      '',
      'One',
      'Two',
      'Three',
      'Four',
      'Five',
      'Six',
      'Seven',
      'Eight',
      'Nine',
      'Ten',
      'Eleven',
      'Twelve',
      'Thirteen',
      'Fourteen',
      'Fifteen',
      'Sixteen',
      'Seventeen',
      'Eighteen',
      'Nineteen'
    ];

    List<String> tens = [
      '',
      '',
      'Twenty',
      'Thirty',
      'Forty',
      'Fifty',
      'Sixty',
      'Seventy',
      'Eighty',
      'Ninety'
    ];

    String numberToWords(int n) {
      if (n == 0) return '';

      if (n < 20) return ones[n];

      if (n < 100) {
        return tens[n ~/ 10] + (n % 10 != 0 ? ' ${ones[n % 10]}' : '');
      }

      if (n < 1000) {
        return '${ones[n ~/ 100]} Hundred${n % 100 != 0 ? ' ${numberToWords(n % 100)}' : ''}';
      }

      if (n < 1000000) {
        return '${numberToWords(n ~/ 1000)} Thousand${n % 1000 != 0 ? ' ${numberToWords(n % 1000)}' : ''}';
      }

      if (n < 1000000000) {
        return '${numberToWords(n ~/ 1000000)} Million${n % 1000000 != 0 ? ' ${numberToWords(n % 1000000)}' : ''}';
      }

      return '${numberToWords(n ~/ 1000000000)} Billion${n % 1000000000 != 0 ? ' ${numberToWords(n % 1000000000)}' : ''}';
    }

    int dollars = number;

    String dollarPart = numberToWords(dollars);

    return '$dollarPart Dollar${dollars != 1 ? 's' : ''}';
  }
}
