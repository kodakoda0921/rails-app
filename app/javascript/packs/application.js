// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()
// ここから追加
let jQuery = require('jquery')
global.$ = global.jQuery = jQuery;
window.$ = window.jQuery = jQuery;
// ここまで
require("admin-lte");
require("admin-lte/plugins/jquery/jquery.min");
require("admin-lte/plugins/bootstrap/js/bootstrap.bundle.min");
require("admin-lte/plugins/overlayScrollbars/js/jquery.overlayScrollbars.min");
require("admin-lte/dist/js/adminlte.min");
require("admin-lte/dist/js/demo");

