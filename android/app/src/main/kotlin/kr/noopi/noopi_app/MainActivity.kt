package kr.noopi.noopi_app

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            // Android supplies the starting window until Flutter is ready.
            // Remove it immediately at handoff instead of animating a second
            // launch screen over our Flutter loading scene.
            splashScreen.setOnExitAnimationListener { view -> view.remove() }
        }
    }
}
