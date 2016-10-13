package at.ac.tuwien.cg.gesture;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.PorterDuff.Mode;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.PowerManager;
import android.os.Vibrator;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Gravity;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextSwitcher;
import android.widget.TextView;
import android.widget.ViewSwitcher;
import at.ac.tuwien.cg.gesture.connection.ConnectionHandler;
import at.ac.tuwien.cg.gesture.connection.ConnectionTools;
import at.ac.tuwien.cg.gesture.data.DeviceCalibrationData;
import at.ac.tuwien.cg.gesture.data.MeasuringPoint;
import at.ac.tuwien.cg.gesture.math.AccelerationCalculation;
import at.ac.tuwien.cg.gesture.math.Matrix4f;
import at.ac.tuwien.cg.gesture.math.Quaternion;
import at.ac.tuwien.cg.gesture.math.Vector3f;

public class GestureDroidActivity extends Activity implements SensorEventListener, OnLongClickListener, OnClickListener,
															  ViewSwitcher.ViewFactory{
	
	private ConnectionHandler connection;
	private DeviceCalibrationData dcd;
	private AccelerationCalculation accCalc;
	
	private SensorManager sensorManager;
	AlertDialog dialog_sensor_delay;
	AlertDialog dialog_server_ip;
	AlertDialog dialog_calibrate;
	SoundHandler soundHandler;
	
	//Vibration
	Vibrator vibrator;
	Animation shake;

	private final Handler vibratorHandler = new Handler();
	int timeGap = 2000;
	long shortVibrate = 200;
	int vibrateGap = 100;
	long[] pattern = {0,shortVibrate,vibrateGap,shortVibrate};
	long[] patternPast = {100,shortVibrate};
	
	private TextSwitcher textSwitcher;
	private CountDown cd;
	boolean isCountDownFinished = true;


	/** The select sensor delay dialog id. */
	private static final int DIALOG_ID_SENSOR_DELAY = 0;
	private static final int DIALOG_ID_SET_SERVER_IP = 1;
	private static final int DIALOG_ID_CALIBRATE = 2;

	/** The PowerManagers Wake Lock. */
	private PowerManager.WakeLock wakeLock;

	String imei;
	int increassingId = 0;
	boolean isRealMeasurement = false;
	boolean isTimeGapMeasurement = false;
	int measurementID = 0;

	/** temporery data */
	Vector3f acceleration = new Vector3f(0.f, 0.f, 0.f);
	Vector3f orientation = new Vector3f(0.f, 0.f, 0.f);
	Vector3f d = new Vector3f(0.f, 0.f, 1.f);
	private long lastMeasurePointTime = 0;
	private boolean hasRotationCalibration = false;
	
	/** temporery orientatio data*/
	
	float[] accelerometerValues;
	float[] geomagneticValue;
	float[] mR = new float[16];
	float[] outR = new float[16];
	float[] mI = new float[16];
	float[] actualOrientationValues = new float[3];
	float yRotationCalibration = 0.f;
	
	final int SOUND_BEEP = R.raw.beep;
	
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		Log.e("start", "GestureDroidActivity");
		
		vibrator = (Vibrator) getSystemService(Context.VIBRATOR_SERVICE);
		shake = AnimationUtils.loadAnimation(this, R.anim.shake);

		LinearLayout ll = (LinearLayout) findViewById(R.id.ll_main);
		ll.setOnLongClickListener(this);
		ll.setOnClickListener(this);
		
		//TextSwitcher
		textSwitcher = (TextSwitcher) findViewById(R.id.textswitcher);
		textSwitcher.setFactory(this);
		Animation in = AnimationUtils.loadAnimation(this,android.R.anim.fade_in);
        Animation out = AnimationUtils.loadAnimation(this,android.R.anim.fade_out);
        textSwitcher.setInAnimation(in);
        textSwitcher.setOutAnimation(out);
        
        //SoundHandler
        soundHandler = new SoundHandler(this, 1);
        soundHandler.addSound(SOUND_BEEP);
        soundHandler.initSound();
    
				
		connection = new ConnectionHandler();
		connection.start();
		
		accCalc = new AccelerationCalculation();
		
		Config.serverIpAdress = ConnectionTools.discoverServerIP();

		PowerManager powerManager = (PowerManager) getSystemService(Context.POWER_SERVICE);
		wakeLock = powerManager.newWakeLock(PowerManager.FULL_WAKE_LOCK
				| PowerManager.ACQUIRE_CAUSES_WAKEUP
				| PowerManager.ON_AFTER_RELEASE, "GestureDroidWeakLock");

		initSensorDelayDialog();
		initSetInternetIpDialog();
		initCalibrateDelayDialog();
		sensorManager = (SensorManager) getSystemService(SENSOR_SERVICE);

		connection.addToQueue("initGestureDroid");

		connection.addToQueue("Phone Canonical Host Name:"
				+ ConnectionTools.getCurrentEnvironmentNetworkIp());

		TelephonyManager mTelephonyMgr = (TelephonyManager) getSystemService(TELEPHONY_SERVICE);
		imei = mTelephonyMgr.getDeviceId(); // Requires READ_PHONE_STATE
		dcd = DeviceCalibrationData.loadDeviceCalibrationData(this);
		
		this.hasRotationCalibration=false;
	}

	@Override
	protected void onResume() {
		super.onResume();
		wakeLock.acquire();
		registerSensorListener();
		
		connection = new ConnectionHandler();
		connection.setRunning(true);
		connection.start();

	}

	@Override
	protected void onStop() {
		connection.setRunning(false);
		unregisterSensorListener();
		super.onStop();
	}

	@Override
	protected void onPause() {
		connection.setRunning(false);
		super.onPause();
		wakeLock.release();
	}

	private void registerSensorListener() {
		// Register this class as a listener for the accelerometer and the
		// orientation sensor
		sensorManager.registerListener(this, sensorManager
				.getDefaultSensor(Sensor.TYPE_ACCELEROMETER),
				Config.sensorDelayAcceleromater);
		sensorManager.registerListener(this, sensorManager
				.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD),
				Config.sensorDelayAcceleromater);

		connection.addToQueue("Accelerometer Sensor resolution"
				+ ": "
				+ sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)
						.getResolution());
		connection.addToQueue("Orientation Sensor resolution"
				+ ": "
				+ sensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD)
						.getResolution());

		connection.addToQueue("sensor Listener registiert");
	
	}

	private void unregisterSensorListener() {
		sensorManager.unregisterListener(this);
	}

	
	public void onAccuracyChanged(Sensor sensor, int accuracy) {
		// TODO Auto-generated method stub

	}

	/**
	 * 
	 */
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
        
		if(!hasRotationCalibration)
		{
			yRotationCalibration= new Quaternion(new Matrix4f(mR)).getAngles(null).z;
			hasRotationCalibration=true;
		}
		
		Vector3f acceleration = new Vector3f(accelerometerValues[0], accelerometerValues[1], accelerometerValues[2]);
		
		
		if(Math.max(Math.max(Vector3f.abs(acceleration).x,Vector3f.abs(acceleration).y),Vector3f.abs(acceleration).z)>(9.81*1.9))
		{
			Log.e("to fast!", acceleration+"");
			soundHandler.playSound(SOUND_BEEP);
			}
		
		//Log.d("gd", "acc="+acceleration);
		dcd.calibrateAcceleration(acceleration);
        //Log.d("gd", "cac="+acceleration);
        
		//Matrix4f invertedMatrix = new Matrix4f(mR).invert();
		Vector3f down = new Vector3f(0.f,0.f,-1.f);
	    //down =invertedMatrix.transform(down);
	    
	    acceleration.add(down);
	    //Log.d("gd", "dac="+acceleration);
	    
	    //meter pro sekunden²
	    acceleration.mult((float)dcd.getActualEarthGravity());
	    //Log.d("gd", "dag="+acceleration);
	    
	    SensorManager.getRotationMatrix(mR, mI, accelerometerValues, geomagneticValue);
	    
	    Matrix4f matrix = new  Matrix4f(mR);
	    matrix = Matrix4f.rotate(matrix,-yRotationCalibration, new Vector3f(0.f,0.f,1.f));
		

	    if(Math.abs(acceleration.x)<0.3)
	    	acceleration.x=0f;
	    
	    if(Math.abs(acceleration.y)<0.3)
	    	acceleration.y=0f;
	    
	    if(Math.abs(acceleration.z)<0.3)
	    	acceleration.z=0f;
	    
	    //Build MeasuringPoint
	    MeasuringPoint m;
	    if(isRealMeasurement)
	    {
			//actually deltaTime in nanoSec

			float deltaTime = ((System.nanoTime()-lastMeasurePointTime)/1000000000f);
			
			//Log.d("ACdeltaTime1", "acdeltaTime1= "+deltaTime);
			
	    	accCalc.accCalculation(acceleration,deltaTime);
	    	
	    	m = new MeasuringPoint(acceleration, matrix ,lastMeasurePointTime,
					   isRealMeasurement,accCalc.getDistanceTX(),accCalc.getVelocityTX(),measurementID);
	    }
	    else if(isTimeGapMeasurement)
	    {
			float deltaTime = ((System.nanoTime()-lastMeasurePointTime)/1000000000f);
			
			//Log.d("ACdeltaTime2", "acdeltaTime2= "+deltaTime);
	    	accCalc.accCalculation(acceleration,deltaTime);
	    	
	    	m = new MeasuringPoint(acceleration, matrix ,lastMeasurePointTime,
					   			   isRealMeasurement,new Vector3f(0f, 0f, 0f),new Vector3f(0f, 0f, 0f),measurementID);

	    }
	    else
	    {
	    	m = new MeasuringPoint(acceleration, matrix ,lastMeasurePointTime,
	    						   isRealMeasurement,new Vector3f(0f, 0f, 0f),new Vector3f(0f, 0f, 0f),measurementID);
	    	accCalc.resetAccCalculator();
	    }
		
        //m = new MeasuringPoint(acceleration, matrix ,lastMeasurePointTime);

		m.setID(imei);

    	Vector3f[] raw = new Vector3f[3];
    	raw[0]=new Vector3f(accelerometerValues[0], accelerometerValues[1], accelerometerValues[2]);
    	raw[1]=down;
    	raw[2]=new Vector3f(geomagneticValue[0] ,geomagneticValue[1] , geomagneticValue[2]);
    	m.setRowData(raw);
    	
		connection.addToQueue(m);
		
		lastMeasurePointTime=System.nanoTime();
		

	}

	
	/*
	 * Initialize Dialog
	 */

	private void initSensorDelayDialog() {
		final CharSequence[] items = { "FASTEST", "GAME", "UI", "NORMAL" };

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(R.string.menue_set_sensor_delay);
		builder.setSingleChoiceItems(items, Config.sensorDelayAcceleromater,
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int item) {
						Config.sensorDelayAcceleromater = item;

						// re-register the Sensor
						unregisterSensorListener();
						registerSensorListener();

						dialog_sensor_delay.dismiss();
					}
				});
		dialog_sensor_delay = builder.create();
	}
	private void initCalibrateDelayDialog() {
		final CharSequence[] items = { "ROTATION", "SPHERICAL", "SHOW ROTATION" };

		AlertDialog.Builder builder = new AlertDialog.Builder(this);
		builder.setTitle(R.string.menue_choose_calibration);
		builder.setItems(items, new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int item) {
				
				switch (item)
				{
					case 0:	
						//now set rotation calibration data
						yRotationCalibration= new Quaternion(new Matrix4f(mR)).getAngles(null).z;
					break;
					
					case 1:
						//now init sperical calibration
						Intent c = new Intent(GestureDroidActivity.this, CalibrateActivity.class);         
						GestureDroidActivity.this.startActivity(c); 
					break;
				
					case 2:
						//now send rotation calibration data
						
						Intent i = new Intent(GestureDroidActivity.this, CompassActivity.class);         
						GestureDroidActivity.this.startActivity(i); 
					break;
				

				}
			}
		});
		

		dialog_calibrate = builder.create();
	}
	private void initSetInternetIpDialog() {

		AlertDialog.Builder alert = new AlertDialog.Builder(this);

		alert.setTitle(R.string.menue_server_ip);
		// alert.setMessage("Message");

		// Set an EditText view to get user input
		final EditText input = new EditText(this);
		input.setText(Config.serverIpAdress);
		alert.setView(input);

		alert.setPositiveButton("Ok", new DialogInterface.OnClickListener() {
			public void onClick(DialogInterface dialog, int whichButton) {
				String value = input.getText().toString();
				Config.serverIpAdress = value;

			}
		});

		alert.setNeutralButton("Broadcast",
				new DialogInterface.OnClickListener() {

					public void onClick(DialogInterface dialog, int whichButton) {

						String broadcastIP = ConnectionTools.discoverServerIP();
						input.setText(broadcastIP);
						Config.serverIpAdress = broadcastIP;

					}

				});

		alert.setNegativeButton("Cancel",
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int whichButton) {

					}
				});

		dialog_server_ip = alert.create();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see android.app.Activity#onCreateDialog(int)
	 */
	@Override
	protected Dialog onCreateDialog(int id) {
		switch (id) {
		case DIALOG_ID_SENSOR_DELAY:
			return dialog_sensor_delay;
		case DIALOG_ID_SET_SERVER_IP:
			return dialog_server_ip;
		case DIALOG_ID_CALIBRATE:
			return dialog_calibrate;
		}
		return super.onCreateDialog(id);
	}

	/*
	 * now comes the menue
	 */

	/*
	 * (non-Javadoc)
	 * 
	 * @see android.app.Activity#onCreateOptionsMenu(android.view.Menu)
	 */
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.menue, menu);
		return true;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see android.app.Activity#onPrepareOptionsMenu(android.view.Menu)
	 */
	@Override
	public boolean onPrepareOptionsMenu(Menu menu) {
		int size = menu.size();
		for (int i = 0; i < size; i++) {
			MenuItem item = menu.getItem(i);
			switch (item.getItemId()) {
			case R.id.menue_sensor_delay:
				item.setTitle(R.string.menue_sensor_delay);
				break;
			}
		}
		return super.onPrepareOptionsMenu(menu);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see android.app.Activity#onOptionsItemSelected(android.view.MenuItem)
	 */
	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {

		case R.id.menue_sensor_delay:
			showDialog(DIALOG_ID_SENSOR_DELAY);
			return true;
		case R.id.menue_set_server_ip:
			showDialog(DIALOG_ID_SET_SERVER_IP);
			return true;
		case R.id.menue_sensor_calibrate:
			showDialog(DIALOG_ID_CALIBRATE);
			return true;
		}
		return false;
	}

	public boolean onLongClick(View v) {
		
		if(!isRealMeasurement && !isTimeGapMeasurement && isCountDownFinished)
		{
			vibrator.vibrate(shortVibrate);
			findViewById(R.id.fingerprint).startAnimation(shake);
			isTimeGapMeasurement=true;
			cd = new CountDown(5000, 1000,true);
			isCountDownFinished=false;
			cd.start();
			
		}
		return false;
	}

	public void onClick(View v) {
		
		
		if(isRealMeasurement && isCountDownFinished)
		{

			vibrator.vibrate(patternPast,-1);
			isRealMeasurement=false;
			ImageView iv = (ImageView) findViewById(R.id.fingerprint);
	    	iv.setColorFilter(0x00000000, Mode.SRC_ATOP);
	    	findViewById(R.id.fingerprint).startAnimation(shake);
			cd = new CountDown(3000, 1000,false);
			isCountDownFinished=false;
			cd.start();
		}
				
	}

	public View makeView() {
		TextView tv = new TextView(this);
		tv.setTextSize(72);
        tv.setGravity(Gravity.TOP | Gravity.CENTER_HORIZONTAL);
        return tv;
	}
	
	public class CountDown extends CountDownTimer{
		
		int i =0;
		boolean isMeasuringBegin;
		
		public CountDown(long millisInFuture, long countDownIntervall, boolean isMeasuringBegin){
			super(millisInFuture,countDownIntervall);
			i=(int) (millisInFuture/1000)-1;
			this.isMeasuringBegin=isMeasuringBegin;
		}
		
		public void onFinish(){
			textSwitcher.setText("");
			isCountDownFinished=true;
		}
		
		public void onTick(long millisUntilFinished){
			if(isMeasuringBegin)
			{
				if(i>1)
				{
					textSwitcher.setText(String.valueOf(i-1));
				}
				else
				{
					textSwitcher.setText("START");
					//vibrator.vibrate(pattern, -1);
					measurementID++;
			    	isTimeGapMeasurement = false;
			    	isRealMeasurement=true;
			    	ImageView iv = (ImageView) findViewById(R.id.fingerprint);
			    	iv.setColorFilter(0x7700FF00, Mode.SRC_ATOP);
			    	findViewById(R.id.fingerprint).startAnimation(shake);
				}
				i--;
			}
			else
			{
				textSwitcher.setText("Ende");
			}
		}
	}
}

