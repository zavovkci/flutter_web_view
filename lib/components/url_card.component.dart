import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_web_view_private/components/web_view.component.dart';
import 'package:flutter_web_view_private/shared/interfaces/orientation.interface.dart';
import 'package:flutter_web_view_private/shared/utils/storage.dart';
import 'package:flutter_web_view_private/shared/widgets/spacing.widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

OrientationType orientationType = OrientationType();
StorageUtil storageUtil = StorageUtil();

Widget urlCard(
    TextEditingController urlController,
    ValueNotifier<String> urlNotifier,
    TextEditingController jsController,
    ValueNotifier<String> jsNotifier,
    ValueNotifier<bool> expectResultNotifier,
    BuildContext context,
    ) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
    child: Card(
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            cardTitle(),
            xsSpacing(orientationType.Vertical),
            title('URL'),
            xsSpacing(orientationType.Vertical),
            urlInputBox(urlController, urlNotifier),
            sSpacing(orientationType.Vertical),
            title('JS (WebView)'),
            xsSpacing(orientationType.Vertical),
            jsInputBox(jsController, jsNotifier),
            xsSpacing(orientationType.Vertical),
            expectResultCheckBox(expectResultNotifier),
            xsSpacing(orientationType.Vertical),
            runButton(urlNotifier, jsNotifier, expectResultNotifier, context),
          ],
        ),
      ),
    ),
  );
}

Widget cardTitle() {
  return Container(
    padding: const EdgeInsets.all(8.0),
    child: const Text(
      'URL & JS Card',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget title(
    String title
    ) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text('$title'),
    ],
  );
}

Widget urlInputBox(
    TextEditingController urlController,
    ValueNotifier<String> urlNotifier
    ) {
  return TextField(
    controller: urlController,
    onChanged: (value) {
      urlNotifier.value = value;
    },
    maxLines: null,
    keyboardType: TextInputType.multiline,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
    ),
  );
}

Widget jsInputBox(
    TextEditingController jsController,
    ValueNotifier<String> jsNotifier
    ) {
  return TextField(
    controller: jsController,
    onChanged: (value) {
      jsNotifier.value = value;
    },
    maxLines: null,
    keyboardType: TextInputType.multiline,
    decoration: const InputDecoration(
      border: OutlineInputBorder(),
    ),
  );
}

Widget expectResultCheckBox(ValueNotifier<bool> expectResult) {
  return StatefulBuilder(
    builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          setState(() {
            expectResult.value = !expectResult.value;
          });
        },
        child: Row(
          children: [
            Checkbox(
                value: expectResult.value,
                onChanged: (value) { setState(() { expectResult.value = value!; });},
            ),
            const Text('Expect Result from JS'),
          ],
        ),
      );
    },
  );
}

Widget runButton(
    ValueNotifier<String> urlNotifier,
    ValueNotifier<String> jsNotifier,
    ValueNotifier<bool> expectResult,
    BuildContext context
    ) {
  return ElevatedButton(
    child: const Text('RUN'),
    onPressed: () {
      Completer<WebViewController> webViewController = Completer<WebViewController>();
      Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewComponent(
        webViewController: webViewController,
        type: 'url',
        expectResult: expectResult,
        storageUtil: storageUtil,
        jsNotifier: jsNotifier,
        urlNotifier: urlNotifier
      )));
    },
  );
}