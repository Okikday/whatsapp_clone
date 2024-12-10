package com.example.whatsapp_clone

import android.content.Context
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import android.widget.EditText
import io.flutter.plugin.common.StandardMessageCodec

class NativeTextInputFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        return NativeTextInput(context)
    }
}

class NativeTextInput(private val context: Context?) : PlatformView {
    private val editText: EditText = EditText(context)

    init {
        editText.hint = "Message bar"

    }

    override fun getView(): View {
        return editText
    }

    override fun dispose() {

    }
}
