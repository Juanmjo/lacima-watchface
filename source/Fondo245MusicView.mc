import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

class Fondo245MusicView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc) {
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
    dc.clear();

    
    var imagen = WatchUi.loadResource(Rez.Drawables.LogoLaCima);
    
    
    var x = (dc.getWidth() / 2) - (imagen.getWidth() / 2);
    var y = (dc.getHeight() / 2) - (imagen.getHeight() / 2);

    
    dc.drawBitmap(x, y, imagen);
    
    
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
    var horaTexto = Lang.format("$1$:$2$", [info.hour.format("%02d"), info.min.format("%02d")]);
    dc.drawText(dc.getWidth() / 2, dc.getHeight() - 60, Graphics.FONT_MEDIUM, horaTexto, Graphics.TEXT_JUSTIFY_CENTER);
}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
