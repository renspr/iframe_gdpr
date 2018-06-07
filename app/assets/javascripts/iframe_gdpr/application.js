function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}

function getService(element) {
  return element.getAttribute("data-service");
}

function getOriginalSrc(element) {
  return element.getAttribute("data-original-src");
}

var activateFrame = document.getElementById("activate-frame");
if (activateFrame) {
  activateFrame.onclick = function() {
    var src = getOriginalSrc(window.frameElement);
    window.location = src;
    return false;
  }
}

var activateService = document.getElementById("activate-service");
if (activateService) {
  activateService.onclick = function() {
    var service = getService(window.frameElement);

    setCookie("iframe_gdpr_" + service, "true", 365);

    var iframes = window.top.document.getElementsByTagName("iframe");
    for (var i=0; i < iframes.length; i++) {
      var _iframe  = iframes[i];
      var _service = getService(_iframe);
      var _src     = getOriginalSrc(_iframe);

      if (service === _service) {
        // do not change the src of the iframe as this results in errors when
        // the iframe is part of a LayerSlider slideshow.
        _iframe.contentWindow.location = _src;
      }
    }

    return false;
  }
}
