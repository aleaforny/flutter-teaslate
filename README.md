# flutter_teaslate

TEAslate - Translation made easy

## What's TEAslate?

TEAslate is a user-friendly API that helps you to generate dynamic translations for your app. It's very useful because you don't have to resubmit your app to the Stores if you need to change a text in your app (plus it can be translated easily).

As of now, this flutter plugin does not support plural forms (but it will).

## Disclaimer

**This project is not production-ready! Use it at your own risks!**

## Getting Started

Import `package:flutter_teaslate/flutter_teaslate.dart`, then instantiate a new `TeaSlate` object (it should be global) which will connect the TEAslate API. Finally, you'll be able to call any translation text.

Example:

```
import 'package:flutter_teaslate/flutter_teaslate.dart';

void main() {
  // Instantiate the TeaSlate object
  TeaSlate teaslate = TeaSlate(key: "my_api_key")
  
  // Connect to TEAslate API (async)
  teaslate.connect().then((bool connected) {
    // You should always check if connection was successful
    if (connected) {
      teaslate.translate("whatIsYourName", lang:"en") // Returns a string "What is your name?"
      teaslate.translate("whatIsYourName", lang:"fr") // Returns a string "Quel est votre nom ?"
    }
  });
```

The first argument of `translate()` function is the UID of your translation you've created on TEAslate API. If it does not exist, it will throw an Exception (UID is case sensitive).

If you try to call a translation that does not have the language, it will return the first translation you've created on the TEAslate API:
```
//TEAslate API's json is: [{"uid":"whatIsYourName","translation_set":[{"lang":"en","default":"What is your name?","plural":"","none":""},{"lang":"fr","default":"Quel est votre nom ?","plural":"","none":""}]}]

// The below code will return the first translation set, so "What is your name?"
teaslate.translate("whatIsYourName", lang:"hu")
```

You can also specify a default language translation when initializing the `TeaSlate` object, so that you're not required to specify the lang parameter when translating:

```
// Instantiate the TeaSlate object
  TeaSlate teaslate = TeaSlate(key: "my_api_key", defaultLang: "fr")

  // Connect to TEAslate API (async)
  teaslate.connect().then((bool connected) {
    // You should always check if connection was successful
    if (connected) {
      // Returns a string "Quel est votre nom ?"
      teaslate.translate("whatIsYourName")

      // You can also still specify a lang if you want to force translation (it returns "What is your name?"
      teaslate.translate("whatIsYourName", lang:"en")
    }
  });
```