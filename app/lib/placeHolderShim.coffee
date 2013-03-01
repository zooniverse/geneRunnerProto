(($) ->
  
  # @todo Document this.
  $.extend $,
    placeholder:
      browser_supported: ->
        (if @_supported isnt `undefined` then @_supported else (@_supported = !!("placeholder" of $("<input type=\"text\">")[0])))

      shim: (opts) ->
        config =
          color: "#888"
          cls: "placeholder"
          lr_padding: 4
          selector: "input[placeholder], textarea[placeholder]"

        $.extend config, opts
        not @browser_supported() and $(config.selector)._placeholder_shim(config)

  $.extend $.fn,
    _placeholder_shim: (config) ->
      calcPositionCss = (target) ->
        op = $(target).offsetParent().offset()
        ot = $(target).offset()
        top: ot.top - op.top + ($(target).outerHeight() - $(target).height()) / 2
        left: ot.left - op.left + config.lr_padding
        width: $(target).width() - config.lr_padding
      @each ->
        $this = $(this)
        if $this.data("placeholder")
          $ol = $this.data("placeholder")
          $ol.css calcPositionCss($this)
          return true
        possible_line_height = {}
        if not $this.is("textarea") and $this.css("height") isnt "auto"
          possible_line_height =
            lineHeight: $this.css("height")
            whiteSpace: "nowrap"
        ol = $("<label />").text($this.attr("placeholder")).addClass(config.cls).css($.extend(
          position: "absolute"
          display: "inline"
          float: "none"
          overflow: "hidden"
          textAlign: "left"
          color: config.color
          cursor: "text"
          paddingTop: $this.css("padding-top")
          paddingLeft: $this.css("padding-left")
          fontSize: $this.css("font-size")
          fontFamily: $this.css("font-family")
          fontStyle: $this.css("font-style")
          fontWeight: $this.css("font-weight")
          textTransform: $this.css("text-transform")
          zIndex: 99
        , possible_line_height)).css(calcPositionCss(this)).attr("for", @id).data("target", $this).click(->
          $(this).data("target").focus()
        ).insertBefore(this)
        $this.data("placeholder", ol).focus(->
          ol.hide()
        ).blur(->
          ol[(if $this.val().length then "hide" else "show")]()
        ).triggerHandler "blur"
        $(window).resize ->
          $target = ol.data("target")
          ol.css calcPositionCss($target)



) jQuery
jQuery(document).add(window).bind "ready load", ->
  jQuery.placeholder.shim()  if jQuery.placeholder
