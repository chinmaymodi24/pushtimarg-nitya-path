import '../models/enums.dart';

/// Privacy policy and terms, written for this app. Keep in sync with any
/// hosted copy used for the Play Store listing.
class LegalDoc {
  const LegalDoc(this.updated, this.sections);
  final String updated;
  final List<(String, String)> sections;
}

abstract class LegalContent {
  static const updated = '21-10-2026';

  static LegalDoc privacy(Lang l) => LegalDoc(updated, switch (l) {
    Lang.gu => _privacyGu,
    Lang.hi => _privacyHi,
    Lang.en => _privacyEn,
  });

  static LegalDoc terms(Lang l) => LegalDoc(updated, switch (l) {
    Lang.gu => _termsGu,
    Lang.hi => _termsHi,
    Lang.en => _termsEn,
  });

  static const _privacyEn = [
    (
      'Overview',
      'Pushtimarg Nitya Path ("the app") is a text-only app for reading the daily paths of Pushtimarg. We built it so that it works without knowing anything about you.',
    ),
    (
      'Information we do not collect',
      'The app has no account or login. It does not collect your name, phone number, email, location, contacts, photos or any other personal information. It contains no advertising, analytics or tracking tools.',
    ),
    (
      'Information stored on your phone',
      'Your settings (script, meaning language, app language, text size, theme), your wishlist and your japa counts are saved only on your own device. They are never sent to us or to anyone else. Uninstalling the app or clearing its data removes them.',
    ),
    (
      'Feedback and email',
      'If you choose to send feedback or contact us, the app opens your own email app with a ready message. We receive only what you decide to send, such as your email address and message. We use it only to reply to you and to improve the app, and we do not share it with anyone.',
    ),
    (
      'Permissions',
      'The app does not ask for any special permission. It reads its paths from files inside the app and works without an internet connection.',
    ),
    (
      'Children',
      'The app is suitable for all ages and does not knowingly collect information from anyone, including children.',
    ),
    (
      'Changes to this policy',
      'If this policy changes, the updated version will be shown in the app with a new "last updated" date.',
    ),
    (
      'Contact',
      'For any question about this policy, write to chinmaymodi24@gmail.com.',
    ),
  ];

  static const _privacyGu = [
    (
      'પરિચય',
      'પુષ્ટિમાર્ગ નિત્ય પાઠ ("એપ") પુષ્ટિમાર્ગના નિત્ય પાઠ વાંચવા માટેની ફક્ત-લખાણ એપ છે. તે તમારી કોઈ માહિતી જાણ્યા વિના ચાલે એ રીતે બનાવી છે.',
    ),
    (
      'અમે કઈ માહિતી એકઠી કરતા નથી',
      'એપમાં કોઈ એકાઉન્ટ કે લૉગિન નથી. તે તમારું નામ, ફોન નંબર, ઈમેલ, સ્થાન, સંપર્કો, ફોટા કે અન્ય કોઈ અંગત માહિતી એકઠી કરતી નથી. તેમાં કોઈ જાહેરાત, એનાલિટિક્સ કે ટ્રેકિંગ નથી.',
    ),
    (
      'તમારા ફોનમાં સંગ્રહાતી માહિતી',
      'તમારાં સેટિંગ (લિપિ, અર્થની ભાષા, એપ ભાષા, અક્ષરનું કદ, થીમ), તમારી યાદી અને જપની ગણતરી ફક્ત તમારા ફોનમાં જ સચવાય છે. તે અમને કે બીજા કોઈને મોકલાતી નથી. એપ દૂર કરતાં કે તેનો ડેટા સાફ કરતાં તે ભૂંસાઈ જાય છે.',
    ),
    (
      'પ્રતિભાવ અને ઈમેલ',
      'તમે પ્રતિભાવ મોકલો કે સંપર્ક કરો ત્યારે એપ તમારી પોતાની ઈમેલ એપ ખોલે છે. તમે જે મોકલો તે જ (જેમ કે તમારું ઈમેલ સરનામું અને સંદેશ) અમને મળે છે. તેનો ઉપયોગ ફક્ત તમને જવાબ આપવા અને એપ સુધારવા માટે થાય છે, અને તે કોઈને આપવામાં આવતું નથી.',
    ),
    (
      'પરવાનગીઓ',
      'એપ કોઈ ખાસ પરવાનગી માગતી નથી. પાઠ એપની અંદરની ફાઈલોમાંથી વંચાય છે અને એપ ઇન્ટરનેટ વિના પણ ચાલે છે.',
    ),
    (
      'બાળકો',
      'એપ દરેક ઉંમરના લોકો માટે યોગ્ય છે અને બાળકો સહિત કોઈની માહિતી જાણીજોઈને એકઠી કરતી નથી.',
    ),
    (
      'નીતિમાં ફેરફાર',
      'આ નીતિ બદલાશે તો નવી આવૃત્તિ નવી તારીખ સાથે એપમાં દર્શાવાશે.',
    ),
    ('સંપર્ક', 'આ નીતિ વિશે કોઈ પ્રશ્ન હોય તો chinmaymodi24@gmail.com પર લખો.'),
  ];

  static const _privacyHi = [
    (
      'परिचय',
      'पुष्टिमार्ग नित्य पाठ ("ऐप") पुष्टिमार्ग के नित्य पाठ पढ़ने के लिए केवल-पाठ ऐप है। इसे इस तरह बनाया गया है कि यह आपकी कोई जानकारी जाने बिना चले।',
    ),
    (
      'हम कौन-सी जानकारी एकत्र नहीं करते',
      'ऐप में कोई खाता या लॉगिन नहीं है। यह आपका नाम, फोन नंबर, ईमेल, स्थान, संपर्क, फोटो या कोई अन्य व्यक्तिगत जानकारी एकत्र नहीं करता। इसमें कोई विज्ञापन, एनालिटिक्स या ट्रैकिंग नहीं है।',
    ),
    (
      'आपके फोन में सहेजी जानकारी',
      'आपकी सेटिंग (लिपि, अर्थ की भाषा, ऐप भाषा, अक्षर का आकार, थीम), आपकी सूची और जप की गिनती केवल आपके फोन में सहेजी जाती हैं। ये हमें या किसी और को नहीं भेजी जातीं। ऐप हटाने या उसका डेटा साफ करने पर ये मिट जाती हैं।',
    ),
    (
      'प्रतिक्रिया और ईमेल',
      'जब आप प्रतिक्रिया भेजते हैं या संपर्क करते हैं, तो ऐप आपका अपना ईमेल ऐप खोलता है। आप जो भेजते हैं वही (जैसे आपका ईमेल पता और संदेश) हमें मिलता है। इसका उपयोग केवल आपको उत्तर देने और ऐप सुधारने के लिए होता है, और इसे किसी के साथ साझा नहीं किया जाता।',
    ),
    (
      'अनुमतियाँ',
      'ऐप कोई विशेष अनुमति नहीं माँगता। पाठ ऐप के अंदर की फ़ाइलों से पढ़े जाते हैं और ऐप इंटरनेट के बिना भी चलता है।',
    ),
    (
      'बच्चे',
      'ऐप सभी आयु के लोगों के लिए उपयुक्त है और बच्चों सहित किसी की जानकारी जानबूझकर एकत्र नहीं करता।',
    ),
    (
      'नीति में परिवर्तन',
      'यह नीति बदलने पर नया संस्करण नई तिथि के साथ ऐप में दिखाया जाएगा।',
    ),
    (
      'संपर्क',
      'इस नीति के बारे में कोई प्रश्न हो तो chinmaymodi24@gmail.com पर लिखें।',
    ),
  ];

  static const _termsEn = [
    (
      'Acceptance',
      'By using Pushtimarg Nitya Path you agree to these terms. If you do not agree, please do not use the app.',
    ),
    (
      'Purpose of the app',
      'The app is offered free of charge to help Vaishnavas read the daily paths for personal devotion. It is not a substitute for the guidance of your Guru or of authoritative texts.',
    ),
    (
      'Accuracy of content',
      'The original compositions are centuries old and in the public domain. The text in this app has been prepared with care and the meanings are written by us, but there may be errors in a path or its meaning. We are continually improving the content. Please verify important matters with a learned Vaishnava or an authoritative edition, and report any mistake to us.',
    ),
    (
      'Permitted use',
      'You may use the app for personal, non-commercial purposes. You may not copy the app\'s meanings, design or compilation to publish or sell them without written permission.',
    ),
    (
      'Ownership',
      'The compositions themselves belong to the tradition. The meanings, arrangement, design, logo and code of the app belong to its developer.',
    ),
    (
      'No warranty',
      'The app is provided "as is", without any warranty. To the extent the law allows, the developer is not liable for any loss arising from use of the app or reliance on its content.',
    ),
    (
      'Changes',
      'We may update the app and these terms from time to time. The current terms are always available in the app.',
    ),
    (
      'Contact',
      'For any question about these terms, write to chinmaymodi24@gmail.com.',
    ),
  ];

  static const _termsGu = [
    (
      'સ્વીકાર',
      'પુષ્ટિમાર્ગ નિત્ય પાઠ એપનો ઉપયોગ કરીને તમે આ શરતો સ્વીકારો છો. જો તમે સંમત ન હો તો કૃપા કરી એપનો ઉપયોગ ન કરો.',
    ),
    (
      'એપનો હેતુ',
      'વૈષ્ણવો પોતાની ભક્તિ માટે નિત્ય પાઠ વાંચી શકે તે માટે આ એપ નિઃશુલ્ક આપવામાં આવે છે. તે ગુરુના માર્ગદર્શન કે પ્રમાણભૂત ગ્રંથોનો વિકલ્પ નથી.',
    ),
    (
      'લખાણની ચોકસાઈ',
      'મૂળ રચનાઓ સદીઓ જૂની અને જાહેર ક્ષેત્રની છે. એપનું લખાણ કાળજીપૂર્વક તૈયાર કર્યું છે અને અર્થ અમે લખ્યા છે, છતાં પાઠ કે તેના અર્થમાં ભૂલ હોઈ શકે છે. અમે સતત સુધારો કરી રહ્યા છીએ. મહત્ત્વની બાબતો કોઈ જાણકાર વૈષ્ણવ કે પ્રમાણભૂત ગ્રંથ સાથે ચકાસી લેવી, અને કોઈ ભૂલ જણાય તો અમને જણાવવી.',
    ),
    (
      'માન્ય ઉપયોગ',
      'તમે એપનો ઉપયોગ અંગત અને બિન-વ્યાવસાયિક હેતુ માટે કરી શકો છો. લેખિત મંજૂરી વિના એપના અર્થ, ડિઝાઇન કે સંકલન નકલ કરીને પ્રકાશિત કે વેચી શકાય નહીં.',
    ),
    (
      'માલિકી',
      'રચનાઓ પોતે પરંપરાની છે. એપના અર્થ, ગોઠવણી, ડિઝાઇન, લોગો અને કોડ તેના ડેવલપરના છે.',
    ),
    (
      'કોઈ ખાતરી નથી',
      'એપ "જેમ છે તેમ" આપવામાં આવે છે, કોઈ ખાતરી વિના. કાયદો મંજૂરી આપે ત્યાં સુધી, એપના ઉપયોગ કે તેના લખાણ પર આધાર રાખવાથી થતા કોઈ નુકસાન માટે ડેવલપર જવાબદાર નથી.',
    ),
    (
      'ફેરફાર',
      'અમે સમયાંતરે એપ અને આ શરતોમાં સુધારો કરી શકીએ છીએ. હાલની શરતો હંમેશાં એપમાં ઉપલબ્ધ રહેશે.',
    ),
    ('સંપર્ક', 'આ શરતો વિશે કોઈ પ્રશ્ન હોય તો chinmaymodi24@gmail.com પર લખો.'),
  ];

  static const _termsHi = [
    (
      'स्वीकृति',
      'पुष्टिमार्ग नित्य पाठ ऐप का उपयोग करके आप इन शर्तों को स्वीकार करते हैं। यदि आप सहमत नहीं हैं तो कृपया ऐप का उपयोग न करें।',
    ),
    (
      'ऐप का उद्देश्य',
      'वैष्णव अपनी भक्ति के लिए नित्य पाठ पढ़ सकें, इसलिए यह ऐप निःशुल्क दिया जाता है। यह गुरु के मार्गदर्शन या प्रामाणिक ग्रंथों का विकल्प नहीं है।',
    ),
    (
      'सामग्री की शुद्धता',
      'मूल रचनाएँ सदियों पुरानी और सार्वजनिक हैं। ऐप का पाठ सावधानी से तैयार किया गया है और अर्थ हमने लिखे हैं, फिर भी पाठ या उसके अर्थ में त्रुटि हो सकती है। हम निरंतर सुधार कर रहे हैं। महत्वपूर्ण बातें किसी जानकार वैष्णव या प्रामाणिक ग्रंथ से जाँच लें, और कोई त्रुटि दिखे तो हमें बताएँ।',
    ),
    (
      'अनुमत उपयोग',
      'आप ऐप का उपयोग व्यक्तिगत और गैर-व्यावसायिक उद्देश्य के लिए कर सकते हैं। लिखित अनुमति के बिना ऐप के अर्थ, डिज़ाइन या संकलन की नकल करके उन्हें प्रकाशित या बेचा नहीं जा सकता।',
    ),
    (
      'स्वामित्व',
      'रचनाएँ स्वयं परंपरा की हैं। ऐप के अर्थ, व्यवस्था, डिज़ाइन, लोगो और कोड उसके डेवलपर के हैं।',
    ),
    (
      'कोई वारंटी नहीं',
      'ऐप "जैसा है" के आधार पर, बिना किसी वारंटी के दिया जाता है। कानून जहाँ तक अनुमति दे, ऐप के उपयोग या उसकी सामग्री पर निर्भरता से होने वाली किसी हानि के लिए डेवलपर उत्तरदायी नहीं है।',
    ),
    (
      'परिवर्तन',
      'हम समय-समय पर ऐप और इन शर्तों में बदलाव कर सकते हैं। वर्तमान शर्तें हमेशा ऐप में उपलब्ध रहेंगी।',
    ),
    (
      'संपर्क',
      'इन शर्तों के बारे में कोई प्रश्न हो तो chinmaymodi24@gmail.com पर लिखें।',
    ),
  ];
}
