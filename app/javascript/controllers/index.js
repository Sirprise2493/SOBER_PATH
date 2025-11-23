// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

import FeatureDropdownController from "./feature_dropdown_controller"
application.register("feature-dropdown", FeatureDropdownController)

