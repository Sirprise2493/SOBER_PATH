// Clean Stimulus controller registration — NO eager loading
import { application } from "./application"

// Core chat + UI controllers
import AutoScrollController from "./auto_scroll_controller"
import ChatSwitcherController from "./chat_switcher_controller"
import ConnectionsController from "./connections_controller"
import EmojiPickerController from "./emoji_picker_controller"
import UserListController from "./user_list_controller"
import MessageThreadController from "./message_thread_controller"
import UserProfilePanelController from "./user_profile_panel_controller"

// Encouragement-related controllers
import EncouragementMessageController from "./encouragement_message_controller"
import EncouragementsSidebarController from "./encouragements_sidebar_controller"

// Other UI/feature controllers (global)
import FeatureDropdownController from "./feature_dropdown_controller"
import CountdownController from "./countdown_controller"
import HelloController from "./hello_controller"
import MapController from "./map_controller"
import MapFocusController from "./map_focus_controller"
import MeetingRowController from "./meeting_row_controller"
import NestedController from "./nested_controller"
import RangeController from "./range_controller"
import ResetFormController from "./reset_form_controller"
import SobrietyTrayController from "./sobriety_tray_controller"

// Register all controllers
application.register("auto-scroll", AutoScrollController)
application.register("chat-switcher", ChatSwitcherController)
application.register("connections", ConnectionsController)
application.register("emoji-picker", EmojiPickerController)
application.register("user-list", UserListController)
application.register("message-thread", MessageThreadController)
application.register("user-profile-panel", UserProfilePanelController)

application.register("encouragement-message", EncouragementMessageController)
application.register("encouragements-sidebar", EncouragementsSidebarController)

application.register("feature-dropdown", FeatureDropdownController)
application.register("countdown", CountdownController)
application.register("hello", HelloController)
application.register("map", MapController)
application.register("map-focus", MapFocusController)
application.register("meeting-row", MeetingRowController)
application.register("nested", NestedController)
application.register("range", RangeController)
application.register("reset-form", ResetFormController)
application.register("sobriety-tray", SobrietyTrayController)
