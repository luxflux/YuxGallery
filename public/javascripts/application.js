
function raf_update_flash(kind,content) {
  
  function hide_after_a_while(element) {
    element.fade("out")
  }

  element = $("flash_" + kind);
  element.fade("out", {
    onFinish: function() {
      element.text(content);
      element.fade("in",
        {
          onFinish: function() {
            hide_after_a_while.delay(4000, element);
          }
        }
      )
    }
  });
}

