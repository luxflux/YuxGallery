//=require right
//=require right/rails
//=require right/tabs
//=require right/lightbox
//=require right/calendar
//=require right/in-edit
//=require right/autocompleter
//=require right/uploader
//=require right/tooltips
//=require right/json


function show_for_a_while(element, duration) {

  function hide_after_a_while(element) {
    element.fade("out")
  }
  
  element.fade("in",
    {
      onFinish: function() {
        hide_after_a_while.delay(duration, element);
      }
    }
  );

}

function raf_update_flash(kind,content) {
  
  element = $("flash_" + kind);
  element.fade("out", {
    onFinish: function() {
      element.text(content);
      show_for_a_while(element, 4000);
    }
  });
}

Lightbox.Options.hideOnEsc = false;
Lightbox.Options.hideOnOutClick = false;


// vieport determination
var viewportwidth;
var viewportheight;
var image_version

function set_lightbox_image_which_fits(image_prefix) {
  // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight
  
  if (typeof window.innerWidth != 'undefined')
  {
       viewportwidth = window.innerWidth,
       viewportheight = window.innerHeight
  }
  
  // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)
  
  else if (typeof document.documentElement != 'undefined'
      && typeof document.documentElement.clientWidth !=
      'undefined' && document.documentElement.clientWidth != 0)
  {
        viewportwidth = document.documentElement.clientWidth,
        viewportheight = document.documentElement.clientHeight
  }
  
  // older versions of IE
  
  else
  {
        viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
        viewportheight = document.getElementsByTagName('body')[0].clientHeight
  }

  if(viewportheight > 800) {
    $(image_prefix + '_image_version_800').show();
    $(image_prefix + '_image_version_400').hide();
  } else {
    $(image_prefix + '_image_version_800').hide();
    $(image_prefix + '_image_version_400').show();
  }

}

function load_form_response_in_lightbox(form_id) {
  $(form_id).on('ajax:complete', function(new_element, old_element) {
    Lightbox.current.dialog.show(new_element.text);
    $('error_explanation').show('slide', {duration:0, onFinish: function() {
      Lightbox.current.dialog.resize(null,"fade");
    }});
  });
}

