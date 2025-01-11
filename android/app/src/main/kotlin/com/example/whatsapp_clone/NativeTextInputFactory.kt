package com.example.whatsapp_clone

import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import android.graphics.drawable.GradientDrawable
import android.os.Build
import android.text.Editable
import android.text.InputFilter
import android.text.InputType
import android.text.Spannable
import android.text.SpannableString
import android.text.TextWatcher
import android.text.style.BackgroundColorSpan
import android.text.style.ForegroundColorSpan
import android.text.style.LineHeightSpan
import android.text.style.ScaleXSpan
import android.text.style.StyleSpan
import android.text.style.UnderlineSpan
import android.util.Log
import android.view.MotionEvent
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import android.view.View
import android.view.ViewTreeObserver
import android.view.inputmethod.EditorInfo
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import android.widget.TextView
import android.widget.Toolbar
import androidx.annotation.ColorInt
import androidx.annotation.DrawableRes
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat.getSystemService
import androidx.core.os.HandlerCompat.postDelayed
import io.flutter.embedding.engine.systemchannels.TextInputChannel.TextInputType
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMessageCodec
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.util.Objects

class NativeTextInputFactory(
    private val messenger: BinaryMessenger // Pass BinaryMessenger from Flutter
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    @RequiresApi(Build.VERSION_CODES.Q)
    override fun create(context: Context?, id: Int, args: Any?): PlatformView {
        val argsModel: NativeTextInputModel = try {
            NativeTextInputModel.fromMap(args as? Map<String, Any> ?: emptyMap())
        } catch (e: Exception) {
            Log.e("NativeTextInputFactory", "Error parsing arguments", e)
            NativeTextInputModel() // Fallback to default values
        }


        return NativeTextInput(context, id, argsModel, messenger)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    class NativeTextInput(
        private val context: Context?,
        private val id: Int,
        private val args: NativeTextInputModel,
        private val messenger: BinaryMessenger
    ) : PlatformView {
        private val channel = MethodChannel(messenger, "native_text_input_$id")

        private val editText: EditText = EditText(context).apply {
            setImeActionLabel(args.label, id)
            hint = args.hint ?: "Enter text here"
            setText(args.defaultText ?: "")
            textSize = (args.fontSize ?: 14.0).toFloat()
            isEnabled = args.isEnabled as? Boolean ?: true
            args.minLines?.let { setMinLines(it)}
            args.maxLines?.let { setMaxLines(it) }
            args.lines?.let { setLines(it) }
            setRawInputType(_parseKeyboardType(args.keyboardType))
            args.hintTextColor.let { setHintTextColor(Color.parseColor(it)) }

            val imm = context?.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
            if (args.hasFocus) {
                requestFocus()
                imm?.showSoftInput(this, InputMethodManager.SHOW_IMPLICIT)
            } else {
                clearFocus()
                imm?.hideSoftInputFromWindow(windowToken, 0)
            }

            overScrollMode = View.OVER_SCROLL_NEVER


            args.inputBoxWidth?.let { setWidth(it) }
            args.inputBoxHeight?.let { setHeight(it) }
            args.minHeight?.let { setMinHeight(it) }
            args.maxHeight?.let { setMaxHeight(it) }

            gravity = when (args.textAlign) { // Set text alignment
                "center" -> android.view.Gravity.CENTER
                "end" -> android.view.Gravity.END
                else -> android.view.Gravity.START
            }
            args.fontColor?.let { setTextColor(Color.parseColor(it)) }


            args.highlightColor?.let { highlightColor = Color.parseColor(it) }



            styleTexts(this, textStyles = args.textStyles, context = context)

            val shapeDrawable = GradientDrawable()
            shapeDrawable.shape = GradientDrawable.RECTANGLE
            shapeDrawable.setColor(Color.TRANSPARENT) // Set the background color to transparent
            shapeDrawable.setStroke(0, Color.TRANSPARENT) // Set the border color to transparent
            shapeDrawable.cornerRadius = 0f // Optional: Set corner radius for rounded edges
            background = shapeDrawable

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

            setCursorProperties(this, cursorColor = args.cursorColor, cursorWidth = args.cursorWidth, cursorHandleColor = args.cursorHandleColor)

            setOnTouchListener { _, event ->
                if (event.action == MotionEvent.ACTION_DOWN) {
                    if (!hasFocus()) {
                        requestFocus() // Request focus
                    }

                    // Notify Flutter channel
                    channel.invokeMethod("onTap", null)

                    performClick()
                }
                false // Allow default touch behavior
            }


        }

        private var currentState: NativeTextInputModel? = args

        fun _parseKeyboardType(value: String): Int{
            return when (value) {
                "number" -> InputType.TYPE_CLASS_NUMBER
                "emailAddress" -> InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                "phone" -> InputType.TYPE_CLASS_PHONE
                "password" -> InputType.TYPE_TEXT_VARIATION_PASSWORD
                "multiline" -> InputType.TYPE_CLASS_TEXT or InputType.TYPE_TEXT_FLAG_CAP_SENTENCES or InputType.TYPE_TEXT_FLAG_MULTI_LINE
                "url" -> InputType.TYPE_TEXT_VARIATION_URI
                "datetime" -> InputType.TYPE_DATETIME_VARIATION_NORMAL
                "name" -> InputType.TYPE_TEXT_VARIATION_PERSON_NAME
                "address" -> InputType.TYPE_TEXT_VARIATION_POSTAL_ADDRESS
                "numberDecimal" -> InputType.TYPE_CLASS_NUMBER or InputType.TYPE_NUMBER_FLAG_DECIMAL
                else -> InputType.TYPE_CLASS_TEXT
            }
        }

        fun colorIntToHexString(color: Int): String{
            return String.format("#%08X", color);
        }
        @RequiresApi(Build.VERSION_CODES.Q)
        fun setCursorProperties(
            widget: EditText,
            cursorColor: String,
            cursorWidth: Int,
            cursorHandleColor: String
        ) {
            try {
                // Convert colors to ColorInt
                val parsedCursorColor = Color.parseColor(cursorColor)
                val parsedHandleColor = Color.parseColor(cursorHandleColor)

                // Cursor Drawable
                val cursorDrawable = GradientDrawable().apply {
                    shape = GradientDrawable.RECTANGLE
                    setColor(parsedCursorColor)
                    setSize(cursorWidth, widget.lineHeight)
                }
                widget.textCursorDrawable = cursorDrawable

                // Handle sizes and radii
                val handleSize = (24 * widget.context.resources.displayMetrics.density).toInt() // 24dp to px
                val handleRadius = handleSize / 2f

                // Create the middle (circle) handle
                val middleHandle = GradientDrawable().apply {
                    shape = GradientDrawable.OVAL
                    setColor(parsedHandleColor)
                    setSize(handleSize, handleSize)
                }

                // Create the left handle (rounded rectangle)
                val leftHandle = GradientDrawable().apply {
                    shape = GradientDrawable.RECTANGLE
                    setColor(parsedHandleColor)
                    cornerRadii = floatArrayOf(
                        handleRadius, handleRadius, // Top-left
                        0f, 0f,                     // Top-right
                        0f, 0f,                     // Bottom-right
                        handleRadius, handleRadius  // Bottom-left
                    )
                    setSize(handleSize / 2, handleSize * 2)
                }

                // Create the right handle (rounded rectangle)
                val rightHandle = GradientDrawable().apply {
                    shape = GradientDrawable.RECTANGLE
                    setColor(parsedHandleColor)
                    cornerRadii = floatArrayOf(
                        0f, 0f,                     // Top-left
                        handleRadius, handleRadius, // Top-right
                        handleRadius, handleRadius, // Bottom-right
                        0f, 0f                      // Bottom-left
                    )
                    setSize(handleSize / 2, handleSize * 2)
                }

                // Assign handles to the widget
                widget.setTextSelectHandle(middleHandle)
                widget.setTextSelectHandleLeft(leftHandle)
                widget.setTextSelectHandleRight(rightHandle)

                // Apply tint to cursor
                widget.textCursorDrawable?.mutate()?.setTint(parsedCursorColor)

            } catch (e: Exception) {
                Log.e("CursorCustomization", "Error customizing cursor: ${e.message}", e)
            }
        }




        fun styleTexts(
            widget: EditText,
            textStyles: List<NativeTextStyle>? = null,
            context: Context
        ) {
            // Get the current text from the EditText as the base for styling
            val baseText = widget.text.toString()
            val spannable = SpannableString(baseText)

            // If no styles are provided, just keep the existing text
            if (textStyles.isNullOrEmpty()) {
                return
            }

            val textLength = baseText.length

            textStyles.forEach { style ->
                // Ensure start and end are within the valid range
                val start = style.start.coerceIn(0, textLength)
                val end = style.end.coerceIn(start, textLength) // Ensures end is not before start

                when (style.style) {
                    "bold" -> spannable.setSpan(
                        StyleSpan(Typeface.BOLD),
                        start,
                        end,
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                    )
                    "italic" -> spannable.setSpan(
                        StyleSpan(Typeface.ITALIC),
                        start,
                        end,
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                    )
                    "underline" -> spannable.setSpan(
                        UnderlineSpan(),
                        start,
                        end,
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                    )
                    "color" -> style.color?.let {
                        spannable.setSpan(
                            ForegroundColorSpan(Color.parseColor(it)),
                            start,
                            end,
                            Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                    }
                    "backgroundColor" -> style.backgroundColor?.let {
                        spannable.setSpan(
                            BackgroundColorSpan(Color.parseColor(it)),
                            start,
                            end,
                            Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                        )
                    }
                }

                // Apply letterSpacing if defined
                style.letterSpacing?.let { letterSpacing ->
                    spannable.setSpan(
                        ScaleXSpan(1 + letterSpacing / 10),
                        start,
                        end,
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                    )
                }

                // Apply lineHeight if defined
                style.lineHeight?.let { lineHeight ->
                    spannable.setSpan(
                        object : LineHeightSpan {
                            override fun chooseHeight(
                                text: CharSequence?,
                                start: Int,
                                end: Int,
                                spanstartv: Int,
                                v: Int,
                                fm: Paint.FontMetricsInt?
                            ) {
                                fm?.let {
                                    val originalHeight = it.descent - it.ascent
                                    val newHeight = (lineHeight * context.resources.displayMetrics.density).toInt()
                                    if (newHeight > originalHeight) {
                                        val delta = newHeight - originalHeight
                                        it.descent += delta / 2
                                        it.ascent -= delta / 2
                                    }
                                }
                            }
                        },
                        start,
                        end,
                        Spannable.SPAN_EXCLUSIVE_EXCLUSIVE
                    )
                }
            }

            // Apply the styled text to the EditText widget
            widget.text = Editable.Factory.getInstance().newEditable(spannable)
        }





        @RequiresApi(Build.VERSION_CODES.Q)
        fun updateProperties(newState: NativeTextInputModel) {
            if (currentState != newState) {
                // Only apply changes if the new state is different from the current one
                if (currentState?.hint != newState.hint) {
                    editText.hint = newState.hint ?: "Enter text here"
                }
                if (currentState?.defaultText != newState.defaultText) {
                    editText.setText(newState.defaultText ?: "")
                }
                if (currentState?.fontSize != newState.fontSize) {
                    editText.textSize = newState.fontSize.toFloat()
                }
                if (currentState?.isEnabled != newState.isEnabled) {
                    editText.isEnabled = newState.isEnabled
                }
                if (currentState?.minLines != newState.minLines) {
                    newState.minLines?.let { editText.minLines = it }
                }
                if (currentState?.maxLines != newState.maxLines) {
                    newState.maxLines?.let { editText.maxLines = it }
                }
                if (currentState?.keyboardType != newState.keyboardType) {
                    editText.setRawInputType(_parseKeyboardType(newState.keyboardType))
                }
                if (newState.hasFocus != currentState?.hasFocus) {
                    val imm = context?.getSystemService(Context.INPUT_METHOD_SERVICE) as? InputMethodManager
                    if (newState.hasFocus) {
                        editText.requestFocus()
                        imm?.showSoftInput(editText, InputMethodManager.SHOW_IMPLICIT)
                    } else {
                        editText.clearFocus()
                        imm?.hideSoftInputFromWindow(editText.windowToken, 0)
                    }
                }

                if(newState.cursorColor != currentState?.cursorColor || newState.cursorHandleColor != currentState?.cursorHandleColor){
                    setCursorProperties(editText, cursorColor = newState.cursorColor, cursorWidth = newState.cursorWidth, cursorHandleColor = newState.cursorHandleColor)
                }
                if(newState.cursorWidth != currentState?.cursorWidth){
                    editText.width = newState.cursorWidth
                }
                if(newState.inputBoxHeight != currentState?.inputBoxHeight || newState.inputBoxWidth != currentState?.inputBoxWidth){
                    newState.inputBoxWidth?.let { editText.width = it }
                    newState.inputBoxHeight?.let { editText.height = it }

                }
                if(newState.maxLength != currentState?.maxLength){
                    newState.maxLength?.let { // Set maximum length if provided
                        editText.filters = arrayOf(android.text.InputFilter.LengthFilter(it))
                    }
                }
                if(newState.hintTextColor != currentState?.hintTextColor){
                    newState.hintTextColor.let { editText.setHintTextColor(Color.parseColor(it)) }
                }
                if(newState.minHeight != currentState?.minHeight || newState.maxHeight != currentState?.maxHeight){
                    newState.minHeight?.let { editText.setMinHeight(it) }
                    newState.maxHeight?.let { editText.setMaxHeight(it) }
                }
                if(newState.lines != currentState?.lines){
                    newState.lines?.let { editText.setLines(it) }
                }
                if(newState.highlightColor != currentState?.highlightColor){
                    newState.highlightColor?.let { editText.highlightColor = Color.parseColor(it) }
                }
                if(newState.fontColor != currentState?.fontColor){
                    newState.fontColor?.let { editText.setTextColor(Color.parseColor(it)) }
                }
                if(newState.textStyles != currentState?.textStyles){
                    if (context != null) {
                        styleTexts(editText, textStyles = newState.textStyles, context = context)
                    }
                }

                // Save the new state as the current state
                currentState = newState
            }
        }

        init {
            GlobalScope.launch(Dispatchers.Main) {
                editText.showSoftInputOnFocus = false
                editText.requestFocus()
                delay(250) // Delay for a short time
                editText.clearFocus()
                editText.showSoftInputOnFocus = true
            }
            editText.addTextChangedListener(object : TextWatcher {
                override fun beforeTextChanged(charSequence: CharSequence?, start: Int, count: Int, after: Int) {
                    // Optional: Handle before text change if needed
                }

                override fun onTextChanged(charSequence: CharSequence?, start: Int, before: Int, count: Int) {
                    // Send the updated text back to Flutter
                    val updatedText = charSequence.toString()
                    channel.invokeMethod("onTextChanged", updatedText)
                }

                override fun afterTextChanged(editable: Editable?) {
                    // Optional: Handle after text change if needed
                }
            })

            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getText" -> {
                        result.success(editText.text.toString())
                    }
                    "getProperties" -> {
                        // Construct the NativeTextInputModel from the current state of the EditText
                        val nativeModel = NativeTextInputModel(
                            hint = editText.hint?.toString(),
                            defaultText = editText.text.toString(),
                            fontSize = editText.textSize,
                            fontColor = colorIntToHexString(editText.currentTextColor),
                            isEnabled = editText.isEnabled,
                            maxLines = editText.maxLines,
                            maxHeight = editText.layout?.getLineTop(editText.layout.lineCount)?.toInt() ?: editText.lineHeight.toInt(),
                            lines = editText.layout.lineCount,
                            textAlign = when (editText.textAlignment) {
                                View.TEXT_ALIGNMENT_TEXT_START -> "start"
                                View.TEXT_ALIGNMENT_CENTER -> "center"
                                View.TEXT_ALIGNMENT_TEXT_END -> "end"
                                else -> "start"
                            },
                            keyboardType = when (editText.inputType) {
                                InputType.TYPE_CLASS_NUMBER -> "number"
                                InputType.TYPE_CLASS_TEXT -> "text"
                                InputType.TYPE_TEXT_VARIATION_PASSWORD -> "password"
                                InputType.TYPE_TEXT_FLAG_MULTI_LINE -> "multiline"
                                else -> "text"
                            },
                            maxLength = editText.filters.filterIsInstance<InputFilter.LengthFilter>().firstOrNull()?.max,
                            cursorColor = colorIntToHexString(editText.highlightColor), // Assumes highlightColor as cursorColor
                            contentPadding = listOf(
                                editText.paddingLeft.toFloat(),
                                editText.paddingTop.toFloat(),
                                editText.paddingRight.toFloat(),
                                editText.paddingBottom.toFloat()
                            ),
                            hasFocus = editText.isFocused,
                            cursorWidth = editText.paint.strokeWidth.toInt(), // May vary based on your custom cursor settings
                            inputBoxWidth = editText.width,
                            inputBoxHeight = editText.height,
                            textStyles = listOf(
                                NativeTextStyle(
                                    start = 0,
                                    end = editText.text.length,
                                    style = "normal", // Example style; you may replace with actual styles
                                    color = colorIntToHexString(editText.currentTextColor),
                                    backgroundColor = (editText.background as? ColorDrawable)?.color?.let {
                                        colorIntToHexString(
                                            it
                                        )
                                    },
                                    letterSpacing = editText.letterSpacing,
                                    lineHeight = editText.lineHeight.toFloat()
                                )
                            )
                        )
                        // Convert NativeTextStyle to a Map
                        val propertiesMap = nativeModel.toMap().toMutableMap()

                        // Convert the list of NativeTextStyle objects to a list of Maps
                        val textStylesMapList = nativeModel.textStyles?.map { it.toMap() }

                        // Update the propertiesMap to include the converted textStyles
                        propertiesMap["textStyles"] = textStylesMapList

                        result.success(propertiesMap)
                    }
                    "updateArguments" -> {
                        val args = call.arguments as? Map<*, *>
                        if (args != null) {
                            try {
                                val convertedTextStyles = (args["textStyles"] as? List<Map<String, Any?>>)?.map { styleMap ->
                                    NativeTextStyle.fromMap(styleMap) // Assuming you have this conversion function
                                }
                                val newState = NativeTextInputModel(
                                    hint = args["hint"] as? String ?: currentState?.hint,
                                    defaultText = args["defaultText"] as? String ?: currentState?.defaultText,
                                    fontSize = (args["fontSize"] as? Double)?.toFloat() ?: currentState?.fontSize ?: 16f,
                                    isEnabled = args["isEnabled"] as? Boolean ?: currentState?.isEnabled ?: true,
                                    minLines = args["minLines"] as? Int ?: currentState?.minLines,
                                    maxLines = args["maxLines"] as? Int ?: currentState?.maxLines,
                                    keyboardType = args["keyboardType"] as? String ?: currentState?.keyboardType ?: "text",
                                    hasFocus = args["hasFocus"] as? Boolean ?: currentState?.hasFocus ?: false,
                                    cursorColor = args["cursorColor"] as? String ?: currentState?.cursorColor ?: "#FFFFFF",
                                    cursorWidth = (args["cursorWidth"] as? Double)?.toInt() ?: currentState?.cursorWidth ?: 4,
                                    inputBoxHeight = (args["inputBoxHeight"] as? Double)?.toInt() ?: currentState?.inputBoxHeight,
                                    inputBoxWidth = (args["inputBoxWidth"] as? Double)?.toInt() ?: currentState?.inputBoxWidth,
                                    maxLength = args["maxLength"] as? Int ?: currentState?.maxLength,
                                    cursorHandleColor = args["cursorHandleColor"] as? String ?: currentState?.cursorHandleColor ?: "#000000",
                                    textStyles = convertedTextStyles ?: currentState?.textStyles,
                                    fontColor = args["fontColor"] as? String ?: currentState?.fontColor ?: "#000000",
                                    highlightColor = args["highlightColor"] as? String ?: currentState?.highlightColor ?: "#FFFFFF",
                                    hintTextColor = args["hintTextColor"] as? String ?: currentState?.hintTextColor ?: "#DDDDDD"
                                )

                                updateProperties(newState)
                                result.success(null)
                            } catch (e: Exception) {
                                result.error("error", "Failed to update arguments: ${e.message}", null)
                            }
                        } else {
                            result.error("error", "Arguments are null or invalid", null)
                        }
                    }

                    else -> {
                        result.notImplemented()
                    }
                }
            }
        }


        override fun getView(): View {
            return editText
        }

        override fun dispose() {
            channel.setMethodCallHandler(null)
            editText.clearFocus()
        }
    }

}

