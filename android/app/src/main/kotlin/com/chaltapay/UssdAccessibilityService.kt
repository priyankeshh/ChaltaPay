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
        // We only care about window content changes or state changes
        if (eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED ||
            eventType == AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED) {

            // OS-AGNOSTIC: No package name filtering.
            // We crawl the entire node tree to find meaningful text.
            val rootNode = event.source ?: return
            
            // Search for the longest text in the hierarchy, assuming USSD messages
            // or bank menus are likely the most significant text content.
            val foundText = findLongestText(rootNode)
            
            if (!foundText.isNullOrBlank()) {
                _ussdEvents.tryEmit(foundText)
            }
        }
    }

    // Recursively traverse the node hierarchy to find the longest text string.
    // This heuristic helps distinguish content from button labels (like "OK", "Cancel").
    private fun findLongestText(node: AccessibilityNodeInfo?): String {
        if (node == null) return ""

        var longest = ""
        
        // Check text of the current node
        if (node.text != null && node.text.toString().isNotBlank()) {
            longest = node.text.toString()
        }

        // Recursively check children
        for (i in 0 until node.childCount) {
            val childLongest = findLongestText(node.getChild(i))
            if (childLongest.length > longest.length) {
                longest = childLongest
            }
        }

        return longest
    }

    override fun onInterrupt() {
        // Required override
    }
}
