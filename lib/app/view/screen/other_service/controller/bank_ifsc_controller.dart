import 'package:advance_emi/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_typography.dart';
import '../../../../model/bank_ifsc_model.dart';

class BankIFSCController extends GetxController {
  Rx<BankIfscModel> bankIfscList = BankIfscModel().obs;
  TextEditingController searchBankController = TextEditingController();
  RxList<String> filteredIfscList = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    getBankList();
  }

  getBankList() {
    filteredIfscList.assignAll(ifscList);
  }

  Widget commonTile(String title, {Widget? screen, bool isLeading = false}) =>
      ListTile(
        onTap: () {
          if (screen != null) {
            showAdAndNavigate(() {
              navigateTo(screen);
            });
          }
        },
        leading: isLeading
            ? Image.asset(
                "assets/icons/bank.png",
                height: 18.h,
                color: AppColors.black,
              )
            : null,
        title: Text(
          title,
          style: notoSans.get12,
          maxLines: 1,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_outlined,
          size: 12.h,
        ),
      );

  List<String> ifscList = [
    "Abhyudaya Co-op Bank",
    "Abu Dhabi Commercial Bank",
    "Akola District Central Co-op Bank",
    "Akola Janata Commercial Co-op Bank",
    "Allahabad Bank",
    "Almora Urban Co-op Bank",
    "Andhra Bank",
    "Andhra Pragathi Grameena Bank",
    "Apna Sahakari Bank Ltd",
    "Australia & New Zealand Banking Group Ltd",
    "Axis Bank",
    "Bandhan Bank Ltd",
    "Bank Internasional Indonesia",
    "Bank of America",
    "Bank of Bahrain & Kuwait",
    "Bank of Baroda",
    "Bank of Ceylon",
    "Bank of India",
    "Bank of Maharashtra",
    "Bank of Tokyo-Mitsubishi Ufj Ltd",
    "Barclays Bank",
    "Bassein Catholic Co-op Bank",
    "Bharatiya Mahila Bank",
    "BNP Paribas",
    "Calyon Bank",
    "Canara Bank",
    "Capital Local Area Bank",
    "Catholic Syrian Bank",
    "Central Bank of India",
    "Chinatrust Commercial Bank",
    "Citibank",
    "Citizencredit Co-op Bank",
    "City Union Bank",
    "Commonwealth Bank of Australia",
    "Corporation Bank",
    "Credit Suisse",
    "DBS Bank",
    "Dena Bank",
    "Deutsche Bank",
    "Deutsche Securities India Pvt. Ltd",
    "Development Credit Bank Ltd",
    "Dhanlaxmi Bank Ltd",
    "DICGC",
    "Doha Bank",
    "Dombivli Nagari Sahakari Bank Ltd",
    "Export Import Bank of India",
    "Firstrand Bank Ltd",
    "Gurgaon Gramin Bank",
    "HDFC BANK",
    "HSBC",
    "ICICI Bank",
    "IDBI Bank",
    "IDFC Bank",
    "IDRBT",
    "Indian Bank",
    "Indian Overseas Bank",
    "Indusind Bank",
    "Industrial & Commercial Bank of China Ltd",
    "Industrial Bank of Korea",
    "ING Vysya Bank",
    "Jalgaon Janata Sahkari Bank Ltd",
    "Janakalyan Sahakari Bank Ltd",
    "Janaseva Sahakari Bank (Borivli) Ltd",
    "Janaseva Sahakari Bank Ltd (Pune)",
    "Janata Sahakari Bank Ltd (Pune)",
    "JPMorgan Chase",
    "Kallappanna Awade Ich Janata S Bank",
    "Kapol Co-op Bank",
    "Karnataka Bank Ltd",
    "Karnataka Vikas Grameena Bank",
    "Karur Vysya Bank",
    "KEB Hana Bank",
    "Kerala Gramin Bank",
    "Kotak Mahindra Bank",
    "Mahanagar Co-op Bank Ltd",
    "Maharashtra State Co-op Bank",
    "Mashreq Bank",
    "Mizuho Corporate Bank Ltd",
    "Nagar Urban Co-op Bank",
    "Nagpur Nagrik Sahakari Bank Ltd",
    "National Australia Bank",
    "National Bank Of Abu Dhabi PJSC",
    "New India Co-op Bank Ltd",
    "NKGSB Co-op Bank Ltd",
    "North Malabar Gramin Bank",
    "Nutan Nagarik Sahakari Bank Ltd",
    "Oman International Bank Saog",
    "Oriental Bank Of Commerce",
    "Parsik Janata Sahakari Bank Ltd",
    "Pragathi Krishna Gramin Bank",
    "Prathama Bank",
    "Prime Co-op Bank Ltd",
    "Punjab & Maharashtra Co-op Bank Ltd",
    "Punjab & Sind Bank",
    "Punjab National Bank",
    "Rabobank International (ccrb)",
    "Rajgurunagar Sahakari Bank Ltd",
    "Rajkot Nagarik Sahakari Bank Ltd",
    "Reserve Bank of India",
    "Samarth Sahakari Bank Ltd",
    "SBER Bank",
    "Shikshak Sahakari Bank Ltd",
    "Shinhan Bank",
    "Shivalik Mercantile Co-op Bank Ltd",
    "Shri Chhatrapati Rajashri Shahu Urban Co-op Bank Ltd",
    "Societe Generale",
    "Solapur Janata Sahkari Bank Ltd.Solapur",
    "South Indian Bank",
    "Standard Chartered Bank",
    "State Bank of Bikaner & Jaipur",
    "State Bank of Hyderabad",
    "State Bank of India - SBI",
    "State Bank of Mauritius Ltd",
    "State Bank of Mysore",
    "State Bank of Patiala",
    "State Bank of Travancore",
    "Sumitomo Mitsui Banking Corporation",
    "Surat National Co-op Bank Ltd",
    "Syndicate Bank",
    "Tamilnad Mercantile Bank Ltd",
    "The A P Mahesh Co-op Urban Bank Ltd",
    "The Ahmedabad Mercantile Co-op Bank Ltd",
    "The Andhra Pradesh State Co-op Bank Ltd",
    "The Bank of Nova Scotia",
    "The Bank of Rajasthan Ltd",
    "The Bharat Co-op Bank (Mumbai) Ltd",
    "The Cosmos Co-op Bank Ltd",
    "The Delhi State Co-op Bank Ltd",
    "The Federal Bank Ltd",
    "The Gadchiroli District Central Co-op Bank Ltd",
    "The Greater Bombay Co-op Bank Ltd",
    "The Gujarat State Co-op Bank Ltd",
    "The Hasti Coop Bank Ltd",
    "The Jalgaon Peoples Co-op Bank",
    "The Jammu & Kashmir Bank Ltd",
    "The Kalupur Commercial Co-Op Bank Ltd",
    "The Kalyan Janata Sahakari Bank Ltd",
    "The Kangra Central Co-op Bank Ltd",
    "The Kangra Co-op Bank Ltd",
    "The Karad Urban Co-op Bank Ltd",
    "The Karanataka State Co-op Apex Bank Ltd",
    "The Kurmanchal Nagar Sahakari Bank Ltd",
    "The Lakshmi Vilas Bank Ltd",
    "The Mehsana Urban Co-op Bank Ltd",
    "The Mumbai District Central Co-op Bank Ltd",
    "The Municipal Co-op Bank Ltd Mumbai",
    "The Nainital Bank Ltd",
    "The Nasik Merchants Co-op Bank Ltd (Nashik)",
    "The Pandharpur Urban Co-op Bank Ltd (Pandharpur)",
    "The Rajasthan State Co-op Bank Ltd",
    "The Ratnakar Bank Ltd",
    "The Royal Bank of Scotland N.V",
    "The Sahebrao Deshmukh Co-op Bank Ltd",
    "The Saraswat Co-op Bank Ltd",
    "The Seva Vikas Co-op Bank Ltd (Svb)",
    "The Shamrao Vithal Co-op Bank Ltd",
    "The Surat District Co-op Bank Ltd",
    "The Surat Peoples Co-op Bank Ltd",
    "The Sutex Co-Op Bank Ltd",
    "The Tamilnadu State Apex Co-op Bank Ltd",
    "The Thane Bharat Sahakari Bank Ltd",
    "The Thane District Central Co-op Bank Ltd",
    "The Varachha Co-op Bank Ltd",
    "The Vishweshwar Sahakari Bank Ltd (Pune)",
    "The West Bengal State Co-op Bank Ltd",
    "The Zoroastrian Co-op Bank Ltd",
    "TJSB Sahakari Bank Ltd",
    "Tumkur Grain Merchants Co-op Bank Ltd",
    "UBS AG",
    "UCO Bank",
    "Union Bank of India",
    "United Bank of India",
    "United Overseas Bank",
    "Vasai Vikas Sahakari Bank Ltd",
    "Vijaya Bank",
    "Westpac Banking Corporation",
    "Woori Bank",
    "Yes Bank",
    "Zila Sahkari Bank Ltd Ghaziabad",
  ];

  void filterSearchResults(String query) {
    List<String> searchResults = filteredIfscList
        .where((bank) => bank.toLowerCase().contains(query.toLowerCase()))
        .toList();
    filteredIfscList.assignAll(searchResults);
    if (query.isEmpty) {
      filteredIfscList.assignAll(ifscList);
    }
  }
}
