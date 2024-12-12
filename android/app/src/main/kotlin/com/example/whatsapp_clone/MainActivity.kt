package com.example.whatsapp_clone

import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformViewRegistry

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val registry: PlatformViewRegistry = flutterEngine.platformViewsController.registry
        registry.registerViewFactory("native-text-input", NativeTextInputFactory(flutterEngine.dartExecutor.binaryMessenger))

    }
}

