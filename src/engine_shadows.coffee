###*
The <code>Shadows</code> module provides a lighting extension to the Engine. Objects that have
an illuminate method will add light to the scene. Objects that have an true opaque attribute will cast
shadows.

@name Shadows
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
###
Engine.Shadows = (I, self) ->
  shadowCanvas = $("<canvas width=640 height=480 />").powerCanvas()

  self.bind "draw", (canvas) ->
    if I.ambientLight < 1
      shadowCanvas.compositeOperation "source-over"
      shadowCanvas.clear()
      # Fill with shadows
      shadowCanvas.fill("rgba(0, 0, 0, #{1 - I.ambientLight})")

      # Etch out the light from each light source
      shadowCanvas.compositeOperation "destination-out"
      shadowCanvas.withTransform I.cameraTransform, (shadowCanvas) ->
        I.objects.each (object, i) ->
          if object.illuminate
            shadowCanvas.globalAlpha 1
            object.illuminate(shadowCanvas)

      shadows = shadowCanvas.element()
      canvas.drawImage(shadows, 0, 0, shadows.width, shadows.height, 0, 0, shadows.width, shadows.height)

  return {}

