import Toybox.Graphics;
import Toybox.Lang;
using Toybox.System as Sys;
import Toybox.WatchUi;
using Toybox.Time.Gregorian;

using Toybox.ActivityMonitor; 
using Toybox.Activity;
using Toybox.Lang;

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
        // 1. Limpiar pantalla completa
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;

        // --- 1. FONDO (Primero para que no tape nada) ---
        try {
            var imagen = WatchUi.loadResource(Rez.Drawables.LogoLaCima); 
            var xLogo = centerX - (imagen.getWidth() / 2);
            var yLogo = centerY - (imagen.getHeight() / 2);
            dc.drawBitmap(xLogo, yLogo, imagen);
        } catch (ex) {}

        // --- 2. HORA Y FECHA ---
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_MEDIUM);
        
        var horaTexto = Lang.format("$1$:$2$", [info.hour.format("%02d"), info.min.format("%02d")]);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, 15, Graphics.FONT_LARGE, horaTexto, Graphics.TEXT_JUSTIFY_CENTER);

        var diasES = ["Dom", "Lun", "Mar", "Mie", "Jue", "Vie", "Sab"];
        var mesesES = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
        var diaSemanaNum = Gregorian.info(now, Time.FORMAT_SHORT).day_of_week - 1;
        var mesNum = Gregorian.info(now, Time.FORMAT_SHORT).month - 1;
        
        var fechaTexto = Lang.format("$1$, $2$ $3$ $4$", [diasES[diaSemanaNum], info.day.format("%d"), mesesES[mesNum], info.year.format("%04d")]);
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, height * 0.22, Graphics.FONT_XTINY, fechaTexto, Graphics.TEXT_JUSTIFY_CENTER);

        // --- 3. DATOS EXTRA (AJUSTE DE PRECISIÓN) ---
        // Para que se vea centrado, el bloque debe estar más equilibrado
        var col1X = width * 0.28; // Movido un poco a la derecha desde 0.25 para centrar el bloque
        var col2X = width * 0.55; 
        var textOffset = 22;      // Espacio entre icono y texto
        
        var fila1Y = height * 0.72; 
        var fila2Y = height * 0.80; 
        
        // El secreto de la alineación:
        var yIconAdj = 2;   // Baja el icono un poco
        var yTextAdj = 0;  // Sube el texto un poco
        
        var actInfo = ActivityMonitor.getInfo();
        var sensInfo = Activity.getActivityInfo();

        var colorContraste = Graphics.COLOR_BLACK;

        // FILA 1: PASOS Y BATERÍA
        // Pasos
        var pasos = actInfo.steps != null ? actInfo.steps : 0;
        dc.drawBitmap(col1X, fila1Y + yIconAdj, WatchUi.loadResource(Rez.Drawables.IconSteps));
        dc.setColor(colorContraste, Graphics.COLOR_TRANSPARENT);
        dc.drawText(col1X + textOffset, fila1Y + yTextAdj, Graphics.FONT_XTINY, pasos.toString(), Graphics.TEXT_JUSTIFY_LEFT);

        // Batería
        var bat = Sys.getSystemStats().battery;
        dc.drawBitmap(col2X, fila1Y + yIconAdj, WatchUi.loadResource(Rez.Drawables.IconBattery));
        dc.setColor(bat > 20 ? colorContraste : Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(col2X + textOffset, fila1Y + yTextAdj, Graphics.FONT_XTINY, bat.format("%d") + "%", Graphics.TEXT_JUSTIFY_LEFT);

        // FILA 2: PULSO
        

        // Pulso
        var pulso = (sensInfo != null && sensInfo.currentHeartRate != null) ? sensInfo.currentHeartRate : "--";
        dc.drawBitmap(col2X, fila2Y + yIconAdj, WatchUi.loadResource(Rez.Drawables.IconHeart));
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(col2X + textOffset, fila2Y + yTextAdj, Graphics.FONT_XTINY, pulso.toString(), Graphics.TEXT_JUSTIFY_LEFT);

        // --- 4. BLUETOOTH ---
        var settings = Sys.getDeviceSettings();
        if (settings.phoneConnected) {
            var iconBT = WatchUi.loadResource(Rez.Drawables.IconBluetooth);
            // Lo centramos en la parte más baja de la pantalla
            dc.drawBitmap(col1X, fila2Y + yIconAdj, iconBT);
        }
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
