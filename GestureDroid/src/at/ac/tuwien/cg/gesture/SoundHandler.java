package at.ac.tuwien.cg.gesture;

import java.util.HashMap;

import android.content.Context;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.media.SoundPool;
import android.media.MediaPlayer.OnErrorListener;
import android.util.Log;


/**
 * 
 * All sounds will be handled by this class. 
 *
 */
public class SoundHandler {
        
        private Context context = null;
        
        //private MediaPlayer levelAudioPlayer = null;
        
        private SoundPool soundPool = null;
       
        private HashMap<Integer, Integer> soundMap;
        
        private float volume = 1.0f;
        
        private boolean initialized = false;
        
        public Integer maximalSounds = 0;
        private Integer soundNumber = 0;
        
        
        public SoundHandler(Context context,Integer maximalSounds)
        {
                this.context = context;
                this.maximalSounds = maximalSounds;
                

        		soundMap = new HashMap<Integer, Integer>();
        		soundPool = new SoundPool(maximalSounds, AudioManager.STREAM_MUSIC, 100);
        	
                
                //LEVEL MUSIC
                //initLevelSound();
                
                //Sound EFFECT
                //initSoundEffects();
        }
        
//        /**
//         * 
//         * Creates an Audio-Player for the Music during a level. The MediaPlayer plays the music endless.
//         * 
//         */

        public void addSound(Integer resId) {
        	
        		initialized=false;
        		soundMap.put(resId, soundPool.load(context, resId, 1));
        		soundNumber++;
        		
        	        	
        }
        /**
         * 
         * All sound-effects will be loaded and stored in a hash.map. So it's easy to access the audio-files.
         * Also the volume-settings will be set.
         * 
         */
        public void initSound() {
                
                AudioManager audioM = (AudioManager)context.getSystemService(Context.AUDIO_SERVICE);
                // set volume to maximum
                audioM.setStreamVolume(AudioManager.STREAM_MUSIC, audioM.getStreamMaxVolume(AudioManager.STREAM_MUSIC), 0);
                volume = (float)audioM.getStreamVolume(AudioManager.STREAM_MUSIC)/(float)audioM.getStreamMaxVolume(AudioManager.STREAM_MUSIC);  
                initialized=true;
        }
        
        /**
         * 
         * The specify sound will be played.
         * 
         * @param soundEffect                   The specify sound which should be played.
         */
        public void playSound(int resId){
               // if(LevelActivity.IS_MUSIC_ON)
        	
        	if(!initialized)
        	{
        		initSound();
            }
        	
        	//volume=1;
        	int stremid = soundPool.play(soundMap.get(resId), volume, volume, 1, 0, 1);
        	Log.e("sondMapID",soundMap.get(resId)+"from:"+resId+" __ volume:"+volume+" streamid="+stremid);
        	
        	
        }
        
//        
        /**
         * Releases the Audio-Player which plays the level-music
         */
        public void releaseLevelAudioPlayer() {
                
//                //Stop music if it's running
//                if(levelAudioPlayer!=null){
//                        if(levelAudioPlayer.isPlaying()){
//                                levelAudioPlayer.stop();
//                        }
//                        levelAudioPlayer.release();
//                        levelAudioPlayer=null;
//                }
                
                //Release the SoundPool
                soundPool.release();
                
        }
//        
//        /**
//         * Starts the Audio-Player which plays the level-music.
//         */
//        public void startLevelAudioPlayer() {
//                
//                if(levelAudioPlayer != null && !levelAudioPlayer.isPlaying() )
//                {
//                        levelAudioPlayer.start();
//                }
//        }
//        
//        /**
//         * Pauses the Audio-Player which plays the level-music.
//         */
//        public void pauseLevelAudioPlayer() {
//                
//                if(levelAudioPlayer != null && levelAudioPlayer.isPlaying())
//                        levelAudioPlayer.pause();
//                
//        }
//        
//        /**
//         * Resumes the Audio-Player which plays the level-music.
//         */
//        public void resumeLevelAudioPlayer() {
//                
//                if(levelAudioPlayer != null && !levelAudioPlayer.isPlaying())
//                        levelAudioPlayer.start();
//                
//        }
}