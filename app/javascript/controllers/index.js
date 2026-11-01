// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from 'controllers/application'
import { eagerLoadControllersFrom } from '@hotwired/stimulus-loading'
import ProgramEditorController from './program_editor_controller'
import PhoneMaskController from './phone_mask_controller'

application.register('program-editor', ProgramEditorController)
application.register('phone-mask', PhoneMaskController)
eagerLoadControllersFrom('controllers', application)
