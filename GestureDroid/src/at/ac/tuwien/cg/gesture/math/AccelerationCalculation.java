package at.ac.tuwien.cg.gesture.math;

import android.util.Log;


public class AccelerationCalculation {
	
	Vector3f velocityT0 = new Vector3f(0f, 0f, 0f);
	Vector3f distanceT0 = new Vector3f(0f, 0f, 0f);
	
	Vector3f velocityTX = new Vector3f(0f, 0f, 0f);
	Vector3f distanceTX = new Vector3f(0f, 0f, 0f);
	
	Vector3f acc = new Vector3f(0f, 0f, 0f);
	
	boolean isFirstCalculation;
	
	public AccelerationCalculation(){
		isFirstCalculation=true;
	}
	
	public void resetAccCalculator(){
		isFirstCalculation=true;
		velocityT0.set(0f,0f,0f);
		distanceT0.set(0f,0f,0f);
	}
	
	public void accCalculation(Vector3f acc, float deltaTime){
		Log.d("ACdeltaTime2", "acdeltaTime11= "+deltaTime);
		this.acc.set(acc);
		
		//FirstCalculation
		if(isFirstCalculation)
		{
			Log.e("FirstAccCalculation", "-******-");
			Log.d("acc", " "+acc);
			Log.d("deltaTime", " "+deltaTime);
			velocityTX  = Vector3f.mult(acc, deltaTime);
			Log.d("velocityTX", ""+velocityTX);
			velocityTX.add(velocityT0);
			Log.d("velocityTX", ""+velocityTX);
			
			distanceTX = Vector3f.mult(acc, (1/2*deltaTime*deltaTime));
			distanceTX.add(Vector3f.mult(velocityT0, deltaTime));
			distanceTX.add(distanceT0);
				
			isFirstCalculation=false;
			Log.d("acc", " "+acc);
			
			Log.d("velocityT0", ""+velocityT0);
			Log.d("distanceT0", ""+distanceT0);
			Log.d("velocityTX", ""+velocityTX);
			Log.d("distanceTX", ""+distanceTX);
		}
		//None-FirstCalculation
		else
		{
			velocityT0 = velocityTX;
			distanceT0 = distanceTX;
			
			velocityTX  = Vector3f.mult(acc, deltaTime);
			velocityTX.mult(0.955f);
			velocityTX.add(velocityT0);
			
			distanceTX = Vector3f.mult(acc, (1/2*deltaTime*deltaTime));
			distanceTX.add(Vector3f.mult(velocityT0, deltaTime));
			distanceTX.add(distanceT0);
//			
//			Log.d("accCalculation", "-------");
//			Log.d("velocityT0", ""+velocityT0);
//			Log.d("distanceT0", ""+distanceT0);
//			Log.d("velocityTX", ""+velocityTX);
//			Log.d("distanceTX", ""+distanceTX);
			
		}
	}
		
	public Vector3f getVelocityTX(){
		return velocityTX;
	}
	
	public Vector3f getDistanceTX(){
		return distanceTX;
	}
}
