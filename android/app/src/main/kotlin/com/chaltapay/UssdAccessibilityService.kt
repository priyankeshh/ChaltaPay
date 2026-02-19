package com.chaltapay

import android.accessibilityservice.AccessibilityService
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow

class UssdAccessibilityService : AccessibilityService() {

    companion object {
        private val _ussdEvents = MutableSharedFlow<String>(extraBufferCapacity = 10)
        val ussdEvents = _ussdEvents.asSharedFlow()
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        val eventType = event.eventType
        if (eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
            eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

            val className = event.className?.toString()
            val packageName = event.packageName?.toString()

            // Filter for typical USSD dialog packages/classes
            if (packageName?.contains("com.android.phone") == true ||
                className?.contains("AlertDialog") == true) {

                val text = extractText(event.source)
                if (!text.isNullOrBlank()) {
                    _ussdEvents.tryEmit(text)
                }
            }
        }
    }

    private fun extractText(node: AccessibilityNodeInfo?): String {
        if (node == null) return ""

        val sb = StringBuilder()
        if (node.text != null) {
            sb.append(node.text).append("\n")
        }

        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            sb.append(extractText(child))
        }

        return sb.toString().trim()
    }

    override fun onInterrupt() {
        // Required override
    }
}
