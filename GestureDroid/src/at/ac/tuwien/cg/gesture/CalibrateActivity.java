package at.ac.tuwien.cg.gesture;

import android.app.Activity;
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.PowerManager;
import android.util.Log;
import at.ac.tuwien.cg.gesture.math.Matrix4f;
import at.ac.tuwien.cg.gesture.math.Vector3f;

public class CalibrateActivity extends Activity implements SensorEventListener{
	
private SensorManager sensorManager;
/** The PowerManagers Wake Lock. */
private PowerManager.WakeLock wakeLock;

float[] accelerometerValues;
float[] geomagneticValue;
float[] mR = new float[16];
float[] outR = new float[16];
float[] mI = new float[16];
	
@Override
protected void onCreate(Bundle savedInstanceState) {
	super.onCreate(savedInstanceState);
	
	PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
	wakeLock = powerManager.newWakeLock(PowerManager.FULL_WAKE_LOCK
			| PowerManager.ACQUIRE_CAUSES_WAKEUP
			| PowerManager.ON_AFTER_RELEASE, "GestureDroidWeakLock");
	sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);
	registerSensorListener();

	setContentView(R.layout.calibrate);
	Log.e("start", "GestureDroidActivity");
}

public void onAccuracyChanged(Sensor sensor, int accuracy) {
	// TODO Auto-generated method stub
	
}

public void onSensorChanged(SensorEvent event) {

	switch (event.sensor.getType())
	{
        case Sensor.TYPE_ACCELEROMETER:
            accelerometerValues = event.values.clone();
            break;
        case Sensor.TYPE_MAGNETIC_FIELD:
            geomagneticValue = event.values.clone();
            break;
        default:
            break;
	}   
	if (geomagneticValue == null || accelerometerValues == null)
		return;

    SensorManager.getRotationMatrix(mR, mI, accelerometerValues, geomagneticValue);
    
	Vector3f acceleration = new Vector3f(accelerometerValues[0], accelerometerValues[1], accelerometerValues[2]);
	Matrix4f invertedMatrix = new Matrix4f(mR).invert();
	Vector3f down = new Vector3f(0.f,0.f,-1.f);
    down = invertedMatrix.transform(down);
 
    //  acceleration =? down
    
    Log.d("acc=", acceleration+" "+down);
    Vector3f invertDown = new Vector3f(down);
    invertDown.invert();
    
    Vector3f cal =Vector3f.divide(acceleration,invertDown);
    Log.d("cal=", " "+cal);

}

@Override
	protected void onResume() {
		wakeLock.acquire();
		super.onResume();
		registerSensorListener();
	}

@Override
	protected void onStop() {
		super.onStop();
		unregisterSensorListener();
	}
@Override
	protected void onPause() {
		wakeLock.release();
		super.onPause();
		unregisterSensorListener();
	}

private void registerSensorListener() {

	sensorManager.registerListener(this, sensorManager
			.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
			Config.sensorDelayAcceleromater);
	sensorManager.registerListener(this, sensorManager
			.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD),
			Config.sensorDelayAcceleromater);
}
private void unregisterSensorListener() {
	sensorManager.unregisterListener(this);
}

}
