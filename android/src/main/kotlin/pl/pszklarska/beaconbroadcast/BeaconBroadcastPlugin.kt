package pl.pszklarska.beaconbroadcast

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.NonNull
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.*
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


class BeaconBroadcastPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var beacon: Beacon
    private var context: Context? = null

    private var eventSink: EventChannel.EventSink? = null
    private var advertiseCallback: (Boolean) -> Unit = { isAdvertising ->
        eventSink?.success(isAdvertising)
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        beacon = Beacon()
        beacon.init(flutterPluginBinding.applicationContext)

        methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "pl.pszklarska.beaconbroadcast/beacon_state")
        methodChannel.setMethodCallHandler(this)

        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "pl.pszklarska.beaconbroadcast/beacon_events")
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "start" -> startBeacon(call, result)
            "stop" -> stopBeacon(result)
            "isAdvertising" -> result.success(beacon.isAdvertising())
            "isTransmissionSupported" -> isTransmissionSupported(result)
            else -> result.notImplemented()
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun startBeacon(call: MethodCall, result: Result) {
        if (call.arguments !is Map<*, *>) {
            throw IllegalArgumentException("Arguments are not a map! " + call.arguments)
        }

        val arguments = call.arguments as Map<String, Any>
        val beaconData = BeaconData(
                arguments["uuid"] as String,
                arguments["majorId"] as Int?,
                arguments["minorId"] as Int?,
                arguments["transmissionPower"] as Int?,
                arguments["advertiseMode"] as Int?,
                arguments["layout"] as String?,
                arguments["manufacturerId"] as Int?,
                arguments["extraData"] as List<Int>?
        )

        // Vérifier les permissions pour Android 12+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val context = this.context ?: run {
                result.error("PERMISSION_ERROR", "Context is not available", null)
                return
            }
            
            if (ContextCompat.checkSelfPermission(context, Manifest.permission.BLUETOOTH_ADVERTISE) 
                != PackageManager.PERMISSION_GRANTED) {
                result.error(
                    "PERMISSION_DENIED",
                    "BLUETOOTH_ADVERTISE permission is required for Android 12+. Please grant the permission before starting the beacon.",
                    null
                )
                return
            }
        }

        beacon.start(beaconData, advertiseCallback)
        result.success(null)
    }

    private fun stopBeacon(result: Result) {
        beacon.stop()
        result.success(null)
    }

    private fun isTransmissionSupported(result: Result) {
        result.success(beacon.isTransmissionSupported())
    }

    override fun onListen(event: Any?, eventSink: EventChannel.EventSink) {
        this.eventSink = eventSink
    }

    override fun onCancel(event: Any?) {
        this.eventSink = null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

}

data class BeaconData(
        val uuid: String,
        val majorId: Int?,
        val minorId: Int?,
        val transmissionPower: Int?,
        val advertiseMode: Int?,
        val layout: String?,
        val manufacturerId: Int?,
        val extraData: List<Int>?
)