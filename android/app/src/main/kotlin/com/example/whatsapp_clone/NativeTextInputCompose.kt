package com.example.whatsapp_clone

import android.content.Context
import android.view.View
import androidx.compose.foundation.clickable
import androidx.compose.foundation.focusable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.foundation.text.KeyboardActions
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Text
import androidx.compose.runtime.*
import androidx.compose.ui.Modifier
import androidx.compose.ui.focus.FocusRequester
import androidx.compose.ui.focus.focusRequester
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.LocalSoftwareKeyboardController
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.*

class NativeTextInputCompose(
    private val messenger: BinaryMessenger,
    private val viewId: Int
) {
    private val channel = MethodChannel(messenger, "native_text_input_$viewId")

    @Composable
    fun NativeTextInput(
        modifier: Modifier = Modifier,
        hint: String? = null,
        label: String? = null,
        defaultText: String? = null,
        fontSize: Float = 16f,
        isEnabled: Boolean = true,
        minLines: Int? = null,
        maxLines: Int? = null,
        lines: Int? = null,
        textAlign: String = "start",
        keyboardType: String = "text",
        maxLength: Int? = null,
        cursorColor: String = "#FFFFFF",
        contentPadding: List<Float>? = null,
        hasFocus: Boolean = false,
        cursorWidth: Int = 4,
        cursorHandleColor: String = "#000000",
        inputBoxWidth: Int? = null,
        inputBoxHeight: Int? = null,
        hintTextColor: String = "#DDDDDD",
        minHeight: Int? = null,
        maxHeight: Int? = null,
        highlightColor: String? = "#FFFFFF",
        fontColor: String? = "#000000",
        textStyles: List<NativeTextStyle>? = null,
        onTextChanged: (String) -> Unit = {},
        onTap: () -> Unit = {}
    ) {
        var text by remember { mutableStateOf(defaultText ?: "") }
        val focusRequester = remember { FocusRequester() }
        val keyboardController = LocalSoftwareKeyboardController.current

        LaunchedEffect(hasFocus) {
            if (hasFocus) {
                focusRequester.requestFocus()
                keyboardController?.show()
            } else {
                keyboardController?.hide()
            }
        }

        val onValueChange: (String) -> Unit = { newText ->
            if (maxLength == null || newText.length <= maxLength) {
                text = newText
                onTextChanged(newText)
            }
        }

        val paddingValues = contentPadding?.let {
            PaddingValues(
                start = it.getOrNull(0)?.dp ?: 0.dp,
                top = it.getOrNull(1)?.dp ?: 0.dp,
                end = it.getOrNull(2)?.dp ?: 0.dp,
                bottom = it.getOrNull(3)?.dp ?: 0.dp
            )
        } ?: PaddingValues(0.dp)

        val composeTextAlign = when (textAlign.lowercase()) {
            "center" -> TextAlign.Center
            "end" -> TextAlign.End
            else -> TextAlign.Start
        }

        val composeKeyboardType = when (keyboardType.lowercase()) {
            "number" -> KeyboardType.Number
            "emailaddress" -> KeyboardType.Email
            "phone" -> KeyboardType.Phone
            "password" -> KeyboardType.Password
            "multiline" -> KeyboardType.Text
            "url" -> KeyboardType.Uri
            "datetime" -> KeyboardType.Number
            "name" -> KeyboardType.Text
            "address" -> KeyboardType.Text
            "numberdecimal" -> KeyboardType.Number
            else -> KeyboardType.Text
        }

        Box(
            modifier = modifier
                .then(inputBoxWidth?.let { Modifier.width(it.dp) } ?: Modifier)
                .then(inputBoxHeight?.let { Modifier.height(it.dp) } ?: Modifier)
                .then(minHeight?.let { Modifier.heightIn(min = it.dp) } ?: Modifier)
                .then(maxHeight?.let { Modifier.heightIn(max = it.dp) } ?: Modifier)
                .clickable { onTap() }
        ) {
            BasicTextField(
                value = text,
                onValueChange = onValueChange,
                modifier = Modifier
                    .fillMaxWidth()
                    .focusRequester(focusRequester)
                    .focusable()
                    .padding(paddingValues),
                enabled = isEnabled,
                textStyle = TextStyle(
                    color = Color(android.graphics.Color.parseColor(fontColor ?: "#000000")),
                    fontSize = fontSize.sp,
                    textAlign = composeTextAlign,
                    lineHeight = fontSize.sp
                ),
                cursorBrush = SolidColor(Color(android.graphics.Color.parseColor(cursorColor))),
                keyboardOptions = KeyboardOptions(
                    keyboardType = composeKeyboardType
                ),
                keyboardActions = KeyboardActions.Default,
                singleLine = maxLines == 1,
                maxLines = maxLines ?: Int.MAX_VALUE,
                minLines = minLines ?: 1,
                decorationBox = { innerTextField ->
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(8.dp)
                    ) {
                        if (text.isEmpty() && hint != null) {
                            Text(
                                text = hint,
                                color = Color(android.graphics.Color.parseColor(hintTextColor)),
                                fontSize = fontSize.sp,
                                modifier = Modifier.fillMaxWidth()
                            )
                        }
                        innerTextField()
                    }
                }
            )
        }

        LaunchedEffect(Unit) {
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getText" -> result.success(text)
                    "updateArguments" -> {
                        try {
                            val args = call.arguments as? Map<String, Any?>
                            if (args != null) {
                                val newState = NativeTextInputModel.fromMap(args)
                                text = newState.defaultText ?: ""
                                result.success(null)
                            } else {
                                result.error("error", "Arguments are null or invalid", null)
                            }
                        } catch (e: Exception) {
                            result.error("error", "Failed to update arguments: ${e.message}", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    companion object {
        fun create(messenger: BinaryMessenger): Pair<Int, NativeTextInputCompose> {
            val viewId = UUID.randomUUID().hashCode()
            return viewId to NativeTextInputCompose(messenger, viewId)
        }

        private const val VIEW_TYPE = "native_text_input"
        
        fun register(flutterEngine: FlutterEngine) {
            val platformViewRegistry = flutterEngine.platformViewsController.registry

            platformViewRegistry.registerViewFactory(
                VIEW_TYPE,
                object : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
                    override fun create(context: Context, viewId: Int, args: Any?): PlatformView {
                        return object : PlatformView {
                            private val composeView = ComposeView(context).apply {
                                setContent {
                                    NativeTextInputCompose(flutterEngine.dartExecutor.binaryMessenger, viewId).NativeTextInput()
                                }
                            }
                            override fun getView(): View = composeView
                            override fun dispose() {}
                        }
                    }
                }
            )
        }
    }
}
