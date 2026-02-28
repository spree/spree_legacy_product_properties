import '@hotwired/turbo-rails'
import { Application } from '@hotwired/stimulus'

let application

if (typeof window.Stimulus === "undefined") {
  application = Application.start()
  application.debug = false
  window.Stimulus = application
} else {
  application = window.Stimulus
}

import SpreeLegacyProductPropertiesController from 'spree_legacy_product_properties/controllers/spree_legacy_product_properties_controller' 

application.register('spree_legacy_product_properties', SpreeLegacyProductPropertiesController)