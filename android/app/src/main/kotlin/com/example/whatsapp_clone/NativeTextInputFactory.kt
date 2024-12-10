package com.example.whatsapp_clone

import android.content.Context
import android.graphics.Typeface
import android.text.SpannableString
import android.text.style.BackgroundColorSpan
import android.text.style.ForegroundColorSpan
import android.text.style.StyleSpan
import android.text.style.UnderlineSpan
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import android.widget.EditText
import io.flutter.plugin.common.StandardMessageCodec

class NativeTextInputFactory : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        var argsModel: NativeTextInputModel = NativeTextInputModel.fromMap(args as Map<String, Any>)

        return NativeTextInput(context, id, argsModel)
    }

    class NativeTextInput(
        private val context: Context?,
        private val id: Int,
        private val args: NativeTextInputModel
    ) : PlatformView {

        private val editText: EditText = EditText(context).apply {
            setImeActionLabel("", id)
            hint = args.hint ?: "Enter text here"
            setText(args.defaultText ?: "")
            textSize = (args.fontSize ?: 14.0).toFloat()
            isEnabled = args.isEnabled as? Boolean ?: true
            maxLines = (args.maxLines as? Int) ?: 1
            inputType = if (args.obscureText) {
                android.text.InputType.TYPE_CLASS_TEXT or android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD
            } else {
                android.text.InputType.TYPE_CLASS_TEXT
            }

            gravity = when (args.textAlign) { // Set text alignment
                "center" -> android.view.Gravity.CENTER
                "end" -> android.view.Gravity.END
                else -> android.view.Gravity.START
            }

            args.backgroundColor?.let { setBackgroundColor(it) }

            args.maxLength?.let { // Set maximum length if provided
                filters = arrayOf(android.text.InputFilter.LengthFilter(it))
            }
            args.contentPadding?.let { padding -> // Set content padding if provided
                setPadding(
                    padding.getOrNull(0)?.toInt() ?: 0,
                    padding.getOrNull(1)?.toInt() ?: 0,
                    padding.getOrNull(2)?.toInt() ?: 0,
                    padding.getOrNull(3)?.toInt() ?: 0
                )
            }

            args.textStyles?.let { styles ->
                val spannable = SpannableString(args.defaultText ?: "")
                styles.forEach { style ->
                    when (style.style) {
                        "bold" -> spannable.setSpan(
                            StyleSpan(Typeface.BOLD),
                            style.start,
                            style.end,
                            SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                        "italic" -> spannable.setSpan(
                            StyleSpan(android.graphics.Typeface.ITALIC),
                            style.start,
                            style.end,
                            SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                        "underline" -> spannable.setSpan(
                            UnderlineSpan(),
                            style.start,
                            style.end,
                            SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                        "color" -> style.color?.let {
                            spannable.setSpan(
                                ForegroundColorSpan(it),
                                style.start,
                                style.end,
                                SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                            )
                        }
                        "backgroundColor" -> style.backgroundColor?.let {
                            spannable.setSpan(
                                BackgroundColorSpan(it),
                                style.start,
                                style.end,
                                SpannableString.SPAN_EXCLUSIVE_EXCLUSIVE
                            )
                        }
                    }
                }
                setText(spannable)
            } ?: setText(args.defaultText ?: "")
        }

        override fun getView(): View {
            //editText.setTextCursorDrawable(R.drawable.cursor_color)
            return editText
        }

        override fun dispose() {
            // Clean up any resources if needed
        }
    }

}

data class NativeTextInputModel(
    val hint: String? = null, // Hint text for the EditText
    val defaultText: String? = null, // Default text to display in the EditText
    val fontSize: Float = 16.0f, // Font size for the text
    val isEnabled: Boolean = true, // Whether the EditText is enabled
    val maxLines: Int = 1, // Maximum number of lines
    val obscureText: Boolean = false, // Whether the text is obscured (password input)
    val textAlign: String = "start", // Text alignment ("start", "center", "end")
    val keyboardType: String = "text", // Input type ("text", "number", etc.)
    val maxLength: Int? = null, // Maximum length of the text
    val backgroundColor: Int? = null, // Background color (ARGB)
    val cursorColor: Int? = null, // Cursor color (ARGB)
    val contentPadding: List<Float>? = null, // Padding as [left, top, right, bottom]
    val textStyles: List<NativeTextStyle>? = null // List of styles to apply to text
) {
    // Converts the model to a Map
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "hint" to hint,
            "defaultText" to defaultText,
            "fontSize" to fontSize,
            "isEnabled" to isEnabled,
            "maxLines" to maxLines,
            "obscureText" to obscureText,
            "textAlign" to textAlign,
            "keyboardType" to keyboardType,
            "maxLength" to maxLength,
            "backgroundColor" to backgroundColor,
            "cursorColor" to cursorColor,
            "contentPadding" to contentPadding,
            "textStyles" to textStyles,
        )
    }

    // Creates a model instance from a Map
    companion object {
        fun fromMap(map: Map<String, Any?>): NativeTextInputModel {
            val textStyles = (map["textStyles"] as? List<Map<String, Any?>>)?.map { styleMap ->
                NativeTextStyle(
                    start = styleMap["start"] as? Int ?: 0,
                    end = styleMap["end"] as? Int ?: 0,
                    style = styleMap["style"] as? String ?: "",
                    color = (styleMap["color"] as? Int),
                    backgroundColor = (styleMap["backgroundColor"] as? Int)
                )
            }
            return NativeTextInputModel(
                hint = map["hint"] as? String,
                defaultText = map["defaultText"] as? String,
                fontSize = (map["fontSize"] as? Double ?: 16.0).toFloat(),
                isEnabled = map["isEnabled"] as? Boolean ?: true,
                maxLines = map["maxLines"] as? Int ?: 1,
                obscureText = map["obscureText"] as? Boolean ?: false,
                textAlign = map["textAlign"] as? String ?: "start",
                keyboardType = map["keyboardType"] as? String ?: "text",
                maxLength = map["maxLength"] as? Int,
                backgroundColor = map["backgroundColor"] as? Int,
                cursorColor = map["cursorColor"] as? Int,
                contentPadding = (map["contentPadding"] as? List<*>)?.map { (it as? Double)?.toFloat() ?: 0f },
                textStyles = textStyles
            )
        }
    }
}

data class NativeTextStyle(
    val start: Int,
    val end: Int,
    val style: String, // e.g., "bold", "italic", "underline"
    val color: Int? = null, // Text color (ARGB)
    val backgroundColor: Int? = null // Background color (ARGB)
)