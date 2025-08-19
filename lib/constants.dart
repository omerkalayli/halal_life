import 'package:flutter/material.dart';
import 'package:halal_life/main/presentation/models/cuisine.dart';
import 'package:halal_life/main/presentation/models/language.dart';

const mint = Color(0xFF6B8E7A);
const lightMint = Color(0xFF8FA89B);
const darkMint = Color(0xFF5A7A68);

// MAIN PAGE HEADER STYLE
const mainHeaderStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Color(0xFF2D5F4D),
);

// MAIN APP BAR CONSTANTS
const mainAppBarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [mint, lightMint],
);
const mainAppBarPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
const mainAppBarTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);
const mainAppBarIconStyle = TextStyle(
  color: darkMint,
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
const mainAppBarIconDecoration = BoxDecoration(
  shape: BoxShape.circle,
  color: Colors.white,
);
const mainAppBarIconPadding = EdgeInsets.all(8);
const mainAppBarProfileContainerDecoration = BoxDecoration(
  shape: BoxShape.circle,
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightMint, mint],
  ),
);
const mainAppBarProfileIconPadding = EdgeInsets.zero;
const mainAppBarProfileIconSize = 20.0;
const mainAppBarProfileIconColor = Colors.white;

// LANGUAGE CONSTANTS
const List<Language> languages = [
  Language(code: 'tr', name: 'Türkçe', flag: '🇹🇷'),
  Language(code: 'en', name: 'English', flag: '🇬🇧'),
  Language(code: 'de', name: 'Deutsch', flag: '🇩🇪'),
  Language(code: 'fr', name: 'Français', flag: '🇫🇷'),
  Language(code: 'es', name: 'Español', flag: '🇪🇸'),
  Language(code: 'nl', name: 'Nederlands', flag: '🇳🇱'),
  Language(code: 'it', name: 'Italiano', flag: '🇮🇹'),
  Language(code: 'pt', name: 'Português', flag: '🇵🇹'),
  Language(code: 'pl', name: 'Polski', flag: '🇵🇱'),
  Language(code: 'ru', name: 'Русский', flag: '🇷🇺'),
  Language(code: 'sv', name: 'Svenska', flag: '🇸🇪'),
  Language(code: 'da', name: 'Dansk', flag: '🇩🇰'),
  Language(code: 'no', name: 'Norsk', flag: '🇳🇴'),
  Language(code: 'fi', name: 'Suomi', flag: '🇫🇮'),
  Language(code: 'cs', name: 'Čeština', flag: '🇨🇿'),
  Language(code: 'hu', name: 'Magyar', flag: '🇭🇺'),
  Language(code: 'ro', name: 'Română', flag: '🇷🇴'),
  Language(code: 'bg', name: 'Български', flag: '🇧🇬'),
  Language(code: 'hr', name: 'Hrvatski', flag: '🇭🇷'),
  Language(code: 'sk', name: 'Slovenčina', flag: '🇸🇰'),
  Language(code: 'sl', name: 'Slovenščina', flag: '🇸🇮'),
  Language(code: 'lv', name: 'Latviešu', flag: '🇱🇻'),
  Language(code: 'lt', name: 'Lietuvių', flag: '🇱🇹'),
  Language(code: 'et', name: 'Eesti', flag: '🇪🇪'),
  Language(code: 'el', name: 'Ελληνικά', flag: '🇬🇷'),
  Language(code: 'ar', name: 'العربية', flag: '🇸🇦'),
  Language(code: 'fa', name: 'فارسی', flag: '🇮🇷'),
  Language(code: 'ur', name: 'اردو', flag: '🇵🇰'),
  Language(code: 'hi', name: 'हिन्दी', flag: '🇮🇳'),
  Language(code: 'bn', name: 'বাংলা', flag: '🇧🇩'),
  Language(code: 'id', name: 'Bahasa Indonesia', flag: '🇮🇩'),
  Language(code: 'ms', name: 'Bahasa Melayu', flag: '🇲🇾'),
];

// CUISINE CONSTANTS

const List<Cuisine> worldCuisines = [
  Cuisine(flag: "🇹🇷", name: "Türk", id: "turkish"),
  Cuisine(flag: "🇮🇹", name: "İtalyan", id: "italian"),
  Cuisine(flag: "🇫🇷", name: "Fransız", id: "french"),
  Cuisine(flag: "🇯🇵", name: "Japon", id: "japanese"),
  Cuisine(flag: "🇨🇳", name: "Çin", id: "chinese"),
  Cuisine(flag: "🇮🇳", name: "Hint", id: "indian"),
  Cuisine(flag: "🇲🇽", name: "Meksika", id: "mexican"),
  Cuisine(flag: "🇰🇷", name: "Kore", id: "korean"),
  Cuisine(flag: "🇹🇭", name: "Tay", id: "thai"),
  Cuisine(flag: "🇬🇷", name: "Yunan", id: "greek"),
  Cuisine(flag: "🇪🇸", name: "İspanyol", id: "spanish"),
  Cuisine(flag: "🇱🇧", name: "Lübnan", id: "lebanese"),
  Cuisine(flag: "🇲🇦", name: "Fas", id: "moroccan"),
  Cuisine(flag: "🇻🇳", name: "Vietnam", id: "vietnamese"),
  Cuisine(flag: "🇺🇸", name: "Amerikan", id: "american"),
  Cuisine(flag: "🇧🇷", name: "Brezilya", id: "brazilian"),
  Cuisine(flag: "🇷🇺", name: "Rus", id: "russian"),
  Cuisine(flag: "🇮🇩", name: "Endonezya", id: "indonesian"),
  Cuisine(flag: "🇩🇪", name: "Alman", id: "german"),
  Cuisine(flag: "🇬🇪", name: "Gürcü", id: "georgian"),
];

const Color appBackgroundColor = Color(0xFFFAFAF7);
