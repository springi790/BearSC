package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.FlxState;
import flixel.util.FlxColor;
import openfl.utils.Assets;

class GateTransitionManager {
    private var gate:FlxSprite;
    private var currentState:FlxState;

    public function new(currentState:FlxState) {
        this.currentState = currentState;
        createGate();
    }

    private function createGate():Void {
        // Verificar si el sprite del portón está disponible
        var gateGraphic:String = "assets/images/gate.png";
        if (Assets.exists(gateGraphic)) {
            trace("Gate graphic exists, loading gate sprite.");
            gate = new FlxSprite(0, -FlxG.height, gateGraphic);
        } else {
            // Si no está disponible, crear un fondo blanco
            trace("Gate graphic does not exist, creating a white gate.");
            gate = new FlxSprite(0, -FlxG.height);
            gate.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
        }
        gate.scrollFactor.set();
        currentState.add(gate);
    }

    public function switchStateWithGate(createNextState:()->FlxState):Void {
        trace("Starting gate transition.");
        // Animar el portón para que baje
        FlxTween.tween(gate, { y: 0 }, 1, { onComplete: function(tween:FlxTween) {
            trace("Gate has moved down, waiting before opening.");
            // Esperar un segundo antes de abrir el portón
            FlxTween.tween(gate, { y: -FlxG.height }, 1, { startDelay: 1, onComplete: function(tween:FlxTween) {
                trace("Gate has moved up, switching state.");
                // Crear y cambiar al siguiente estado
                FlxG.switchState(createNextState());
            }});
        }});
    }
}
