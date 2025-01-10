package com.example.whatsapp_clone

data class NativeTextInputModel(
    val hint: String? = null, // Hint text for the EditText
    val label: String? = null,
    val defaultText: String? = null, // Default text to display in the EditText
    val fontSize: Float = 16.0f, // Font size for the text
    val isEnabled: Boolean = true, // Whether the EditText is enabled
    val minLines: Int? = null,
    val maxLines: Int? = null, // Maximum number of lines
    val lines: Int? = null,
    val textAlign: String = "start", // Text alignment ("start", "center", "end")
    val keyboardType: String = "text", // Input type ("text", "number", etc.)
    val maxLength: Int? = null, // Maximum length of the text
    val cursorColor: String = "#FFFFFF", // Cursor color (ARGB)
    val contentPadding: List<Float>? = null, // Padding as [left, top, right, bottom]
    val textStyles: List<NativeTextStyle>? = null, // List of styles to apply to text
    val hasFocus: Boolean = false,
    val cursorWidth: Int = 4,
    val cursorHandleColor: String = "#000000",
    val inputBoxWidth: Int? = null,
    val inputBoxHeight: Int? = null,
    val hintTextColor: String = "#DDDDDD",
    val minHeight: Int? = null,
    val maxHeight: Int? = null,
    val highlightColor: String? = "#FFFFFF",
    val fontColor: String? = "#000000",
) {
    // Converts the model to a Map
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "hint" to hint,
            "label" to label,
            "defaultText" to defaultText,
            "fontSize" to fontSize,
            "isEnabled" to isEnabled,
            "minLines" to minLines,
            "maxLines" to maxLines,
            "lines" to lines,
            "textAlign" to textAlign,
            "keyboardType" to keyboardType,
            "maxLength" to maxLength,
            "cursorColor" to cursorColor,
            "contentPadding" to contentPadding,
            "textStyles" to textStyles,
            "hasFocus" to hasFocus,
            "cursorWidth" to cursorWidth,
            "cursorHandleColor" to cursorHandleColor,
            "inputBoxWidth" to inputBoxWidth,
            "inputBoxHeight" to inputBoxHeight,
            "hintTextColor" to hintTextColor,
            "minHeight" to minHeight,
            "maxHeight" to maxHeight,
            "highlightColor" to highlightColor,
            "fontColor" to fontColor
        )
    }

    // Creates a model instance from a Map
    companion object {
        fun fromMap(map: Map<String, Any?>): NativeTextInputModel {
            val convertedTextStyles = (map["textStyles"] as? List<Map<String, Any?>>)?.map { styleMap ->
                NativeTextStyle.fromMap(styleMap)
            }

            return NativeTextInputModel(
                hint = map["hint"] as? String,
                label = map["label"] as? String,
                defaultText = map["defaultText"] as? String,
                fontSize = (map["fontSize"] as? Double ?: 16.0).toFloat(),
                isEnabled = map["isEnabled"] as? Boolean ?: true,
                minLines = map["minLines"] as? Int,
                maxLines = map["maxLines"] as? Int,
                lines = map["lines"] as? Int,
                textAlign = map["textAlign"] as? String ?: "start",
                keyboardType = map["keyboardType"] as? String ?: "text",
                maxLength = map["maxLength"] as? Int,
                cursorColor = map["cursorColor"] as? String ?: "#FFFFFF",
                contentPadding = (map["contentPadding"] as? List<*>)?.map { (it as? Double)?.toFloat() ?: 0f },
                textStyles = convertedTextStyles,
                hasFocus = map["hasFocus"] as? Boolean ?: false,
                cursorWidth = map["cursorWidth"] as? Int ?: 4,
                cursorHandleColor = map["cursorHandleColor"] as? String ?: "#000000",
                inputBoxWidth = map["inputBoxWidth"] as? Int,
                inputBoxHeight = map["inputBoxHeight"] as? Int,
                hintTextColor = map["hintTextColor"] as? String ?: "#DDDDDD",
                minHeight = map["minHeight"] as? Int,
                maxHeight = map["maxHeight"] as? Int,
                highlightColor = map["highlightColor"] as? String ?: "#FFFFFF",
                fontColor = map["fontColor"] as? String ?: "#000000",
            )
        }
    }

}

data class NativeTextStyle(
    val start: Int = 0,
    val end: Int = 0,
    val style: String, // e.g., "bold", "italic", "underline"
    val color: String? = "#00000000", // Text color (ARGB)
    val backgroundColor: String? = "#00000000", // Background color (ARGB)
    val letterSpacing: Float? = null,
    val lineHeight: Float? = null
) {
    // Convert the object to a Map
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "start" to start,
            "end" to end,
            "style" to style,
            "color" to color,
            "backgroundColor" to backgroundColor,
            "letterSpacing" to letterSpacing,
            "lineHeight" to lineHeight
        )
    }

    // Companion object to create from a Map
    companion object {
        fun fromMap(map: Map<String, Any?>): NativeTextStyle {
            return NativeTextStyle(
                start = map["start"] as? Int ?: 0,
                end = map["end"] as? Int ?: 0,
                style = map["style"] as? String ?: "",
                color = map["color"] as? String ?: "#00000000",
                backgroundColor = map["backgroundColor"] as? String ?: "#00000000",
                letterSpacing = (map["letterSpacing"] as? Number)?.toFloat(),
                lineHeight = (map["lineHeight"] as? Number)?.toFloat()
            )
        }
    }
}