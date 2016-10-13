package at.ac.tuwien.cg.gesture.data;


import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import at.ac.tuwien.cg.gesture.math.Vector3f;

public class DeviceCalibrationData {

	static String calibrationId = "gestureDroidCalibration";
	private Vector3f accelerationMin;
	private Vector3f accelerationMax;
	private Vector3f zeroAccelerationMin;
	private Vector3f zeroAccelerationMax;

	private double actualEarthGravity;
	final static String PROPERTIE_FILE = "DeviceCalibrationData.txt";

	public DeviceCalibrationData(Vector3f accelerationMin,
			Vector3f accelerationMax, Vector3f zeroAccelerationMin,Vector3f zeroAccelerationMax) {
		
		Vector3f actualG = Vector3f.add(Vector3f.abs(accelerationMin),Vector3f.abs(accelerationMax));
		
		this.actualEarthGravity = (actualG.x+actualG.y+actualG.z)/6;

		this.accelerationMin = Vector3f.divide(new Vector3f(1.f, 1.f, 1.f), accelerationMin);
		this.accelerationMax = Vector3f.divide(new Vector3f(1.f, 1.f, 1.f), accelerationMax);
		this.zeroAccelerationMin = zeroAccelerationMin;
		this.zeroAccelerationMax = zeroAccelerationMax;

	}

	/**
	 * this method will load the specific calibration data for an unique
	 * device-id , if they exist!
	 * 
	 * @return
	 */
	public static DeviceCalibrationData loadDeviceCalibrationData(Activity activity) {

		// load the data
		SharedPreferences prefs = activity.getSharedPreferences(calibrationId,Context.MODE_WORLD_READABLE) ; 
		
		Vector3f accelerationMin = new Vector3f(Float.valueOf(prefs.getString("aMinX", "9.777f")), Float.valueOf(prefs.getString("aMinY", "9.61f")), Float.valueOf(prefs.getString("aMinZ", "9.636f")));
		Vector3f accelerationMax  = new Vector3f(Float.valueOf(prefs.getString("aMaxX", "9.777f")), Float.valueOf(prefs.getString("aMaxY", "9.61f")), Float.valueOf(prefs.getString("aMaxZ", "9.636f")));
		Vector3f zeroAccelerationMin = new Vector3f(Float.valueOf(prefs.getString("aZeroMinX", "0.f")), Float.valueOf(prefs.getString("aZeroMinY", "0.f")), Float.valueOf(prefs.getString("aZeroMinZ", "0.f")));
		Vector3f zeroAccelerationMax = new Vector3f(Float.valueOf(prefs.getString("aZeroMinX", "0.f")), Float.valueOf(prefs.getString("aZeroMinY", "0.f")), Float.valueOf(prefs.getString("aZeroMinZ", "0.f")));

		return new DeviceCalibrationData(accelerationMin, accelerationMax, zeroAccelerationMin, zeroAccelerationMax);
	}
	
	public void saveDeviceCalibrationData(Activity activity){
		
		SharedPreferences.Editor editor = activity.getSharedPreferences(calibrationId,Context.MODE_WORLD_WRITEABLE).edit();
        editor.putString("aMinX", this.accelerationMin.x.toString());
        editor.putString("aMinY", this.accelerationMin.y.toString());
        editor.putString("aMinZ", this.accelerationMin.z.toString());
        
        editor.putString("aMaxX", this.accelerationMax.x.toString());
        editor.putString("aMaxY", this.accelerationMax.y.toString());
        editor.putString("aMaxZ", this.accelerationMax.z.toString());
        
        editor.putString("aZeroMinX", this.zeroAccelerationMin.x.toString());
        editor.putString("aZeroMinY", this.zeroAccelerationMin.y.toString());
        editor.putString("aZeroMinZ", this.zeroAccelerationMin.z.toString());
        
        editor.putString("aZeroMaxX", this.zeroAccelerationMax.x.toString());
        editor.putString("aZeroMaxY", this.zeroAccelerationMax.y.toString());
        editor.putString("aZeroMaxZ", this.zeroAccelerationMax.z.toString());

        editor.commit();	

	}

	/**
	 * calibrate the given Vector and return it
	 * @param v Vector to calibrate
	 * @return the calibrated Vector
	 */
	public Vector3f calibrateAcceleration(Vector3f v) {

		if (v.x > 0)
			v.x *= accelerationMax.x;
		else
			v.x *= accelerationMin.x;

		if (v.y > 0)
			v.y *= accelerationMax.y;
		else
			v.y *= accelerationMin.y;

		if (v.z > 0)
			v.z *= accelerationMax.z;
		else
			v.z *= accelerationMin.z;
		
		//TODO: calibrate with zero values

		return v;
	}

	public Vector3f getAccelerationMin() {
		return accelerationMin;
	}

	public void setAccelerationMin(Vector3f accelerationMin) {
		this.accelerationMin = accelerationMin;
	}

	public Vector3f getAccelerationMax() {
		return accelerationMax;
	}

	public void setAccelerationMax(Vector3f accelerationMax) {
		this.accelerationMax = accelerationMax;
	}

	public void setAccelerationMinX(float x) {
		this.accelerationMin.x=(1.f/x);
	}

	public void setAccelerationMinY(float y) {
		this.accelerationMin.y=(1.f/y);
	}

	public void setAccelerationMinZ(float z) {
		this.accelerationMin.z=(1.f/z);
	}

	public void setAccelerationMaxX(float x) {
		this.accelerationMax.x=(1.f/x);
	}

	public void setAccelerationMaxY(float y) {
		this.accelerationMax.y=(1.f/y);
	}

	public void setAccelerationMaxZ(float z) {
		this.accelerationMax.z=(1.f/z);
	}
	
	public double getActualEarthGravity() {
		return actualEarthGravity;
	}

	@Override
	public String toString() {
		return "Min:"+accelerationMin+" Max:"+accelerationMax+ " zeroMin:"+zeroAccelerationMin+ " zeroMax:"+zeroAccelerationMax;
	}

}
