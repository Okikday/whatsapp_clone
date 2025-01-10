package com.example.whatsapp_clone

data class NativeTextInputModel(
    val hint: String? = null,
    val label: String? = null,
    val defaultText: String? = null,
    val fontSize: Float = 16.0f,
    val isEnabled: Boolean = true,
    val minLines: Int? = null,
    val maxLines: Int? = null,
    val lines: Int? = null,
    val textAlign: String = "start",
    val keyboardType: String = "text",
    val maxLength: Int? = null,
    val cursorColor: String = "#FFFFFF",
    val contentPadding: List<Float>? = null,
    val textStyles: List<NativeTextStyle>? = null,
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
    companion object {
        private val VALID_TEXT_ALIGNMENTS = setOf("start", "center", "end")
        private val VALID_KEYBOARD_TYPES = setOf(
            "text", "number", "emailAddress", "phone", "password",
            "multiline", "url", "datetime", "name", "address", "numberDecimal"
        )

        fun fromMap(map: Map<String, Any?>): NativeTextInputModel {
            // Safely convert text styles
            val convertedTextStyles = (map["textStyles"] as? List<*>)?.mapNotNull { style ->
                when (style) {
                    is Map<*, *> -> try {
                        @Suppress("UNCHECKED_CAST")
                        NativeTextStyle.fromMap(style as Map<String, Any?>)
                    } catch (e: Exception) {
                        null
                    }
                    else -> null
                }
            }

            // Validate text alignment
            val textAlign = (map["textAlign"] as? String)?.takeIf {
                it in VALID_TEXT_ALIGNMENTS
            } ?: "start"

            // Validate keyboard type
            val keyboardType = (map["keyboardType"] as? String)?.takeIf {
                it in VALID_KEYBOARD_TYPES
            } ?: "text"

            return NativeTextInputModel(
                hint = map["hint"] as? String,
                label = map["label"] as? String,
                defaultText = map["defaultText"] as? String,
                fontSize = (map["fontSize"] as? Number)?.toFloat() ?: 16.0f,
                isEnabled = map["isEnabled"] as? Boolean ?: true,
                minLines = (map["minLines"] as? Number)?.toInt(),
                maxLines = (map["maxLines"] as? Number)?.toInt(),
                lines = (map["lines"] as? Number)?.toInt(),
                textAlign = textAlign,
                keyboardType = keyboardType,
                maxLength = (map["maxLength"] as? Number)?.toInt(),
                cursorColor = map["cursorColor"] as? String ?: "#FFFFFF",
                contentPadding = (map["contentPadding"] as? List<*>)?.mapNotNull {
                    (it as? Number)?.toFloat()
                },
                textStyles = convertedTextStyles,
                hasFocus = map["hasFocus"] as? Boolean ?: false,
                cursorWidth = (map["cursorWidth"] as? Number)?.toInt() ?: 4,
                cursorHandleColor = map["cursorHandleColor"] as? String ?: "#000000",
                inputBoxWidth = (map["inputBoxWidth"] as? Number)?.toInt(),
                inputBoxHeight = (map["inputBoxHeight"] as? Number)?.toInt(),
                hintTextColor = map["hintTextColor"] as? String ?: "#DDDDDD",
                minHeight = (map["minHeight"] as? Number)?.toInt(),
                maxHeight = (map["maxHeight"] as? Number)?.toInt(),
                highlightColor = map["highlightColor"] as? String ?: "#FFFFFF",
                fontColor = map["fontColor"] as? String ?: "#000000"
            )
        }
    }

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
            "textStyles" to textStyles?.map { it.toMap() },
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